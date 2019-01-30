package autonomos.com.br.jopeb.autonosapp;
import android.content.Context;
import android.content.Intent;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.lang.annotation.Native;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import autonomos.com.br.jopeb.autonosapp.adapter.ProfessionalMarkInfoAdapter;


public class NativeMapActivity extends AppCompatActivity implements OnMapReadyCallback,
        GoogleMap.OnMarkerClickListener {

  private GoogleMap m_map;
  public static final String KEY_DATA_LIST = "dataList";
  public static final String KEY_LATITUDE = "latitude";
  public static final String KEY_LONGITUDE = "longitude";
  public static final String KEY_UID = "uid";
  public static final String KEY_NOME = "nome";
  public static final String KEY_TELEFONE ="telefone";
  public static final String KEY_PHOTO_URL = "photoUrl";

  private ArrayList<HashMap<String,Object>> m_dataList;
  private LatLng m_myPlace;
  private MethodChannelHolder m_channelHolder = MethodChannelHolder.getInstance();

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_maps);
    Intent intent = getIntent();

    m_dataList = (ArrayList<HashMap<String, Object>>) intent.getSerializableExtra(KEY_DATA_LIST);
    m_myPlace = new LatLng( intent.getDoubleExtra(KEY_LATITUDE, 0.D),
            intent.getDoubleExtra(KEY_LONGITUDE, 0.D));

    SupportMapFragment fragment =  (SupportMapFragment) getSupportFragmentManager()
            .findFragmentById(R.id.map);

    if (fragment!=null)
      fragment.getMapAsync( this );
  }

  @Override
  public void onMapReady( GoogleMap googleMap ) {
    m_map = googleMap;

    m_map.setInfoWindowAdapter( new ProfessionalMarkInfoAdapter(NativeMapActivity.this) );

    Iterator<HashMap<String,Object>> listIterator = m_dataList.iterator();
    while (listIterator.hasNext()){
      HashMap<String, Object> professionalJsonData = listIterator.next();

      MarkerOptions markerOptions = new MarkerOptions();
      Double lat = (Double)professionalJsonData.get(KEY_LATITUDE);
      Double lng = (Double)professionalJsonData.get(KEY_LONGITUDE);

      markerOptions.position(new LatLng( lat, lng) );
      markerOptions.draggable(false);

      m_map.addMarker( markerOptions ).setTag( professionalJsonData );
      m_map.setOnMarkerClickListener( this );
    }

      m_map.moveCamera(CameraUpdateFactory.newLatLng(m_myPlace) );
      m_map.animateCamera(CameraUpdateFactory.newLatLngZoom(m_myPlace, 12.0f), 1500, null );
      m_map.setOnInfoWindowClickListener(new GoogleMap.OnInfoWindowClickListener() {

      @Override
      public void onInfoWindowClick(Marker marker) {
        HashMap<String, Object> professionalJsonData  = (HashMap<String, Object>) marker.getTag();
        Log.i("DBG", "User selected " + professionalJsonData.get(KEY_UID) );
        //m_channelHolder.getChannel().invokeMethod("message", professionalJsonData);
      }
    });
  }

    @Override
    public boolean onMarkerClick(Marker marker) {
      HashMap<String,Object> data = (HashMap<String, Object>) marker.getTag();
      Log.i("DBG", "usuario: " + data.get( KEY_UID ));
      return false;
    }
}
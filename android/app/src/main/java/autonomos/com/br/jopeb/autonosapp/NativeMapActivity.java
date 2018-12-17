package autonomos.com.br.jopeb.autonosapp;
import android.content.Intent;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;


public class NativeMapActivity extends AppCompatActivity implements OnMapReadyCallback{

  private GoogleMap m_map;
  public static final String KEY_DATA_LIST = "dataList";
  public static final String KEY_LATITUDE = "latitude";
  public static final String KEY_LONGITUDE = "longitude";
  private static final String KEY_NOME = "nome";

  private ArrayList<HashMap<String,Object>> m_dataList;

  private LatLng m_myPlace;

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
    Iterator<HashMap<String,Object>> listIterator = m_dataList.iterator();
    while (listIterator.hasNext()){
      HashMap<String, Object> json = listIterator.next();

      MarkerOptions markerOptions = new MarkerOptions();
      Double lat = (Double)json.get(KEY_LATITUDE);
      Double lng = (Double)json.get(KEY_LONGITUDE);
      markerOptions.position(new LatLng( lat, lng) );

      markerOptions.draggable(false);
      markerOptions.title( (String)json.get(KEY_NOME));
      m_map.addMarker( markerOptions );

    }
    //m_map.addMarker(new MarkerOptions().position(m_myPlace).title("Marker in Sydney"));
    m_map.moveCamera(CameraUpdateFactory.newLatLng(m_myPlace) );
    m_map.animateCamera(CameraUpdateFactory.newLatLngZoom(m_myPlace, 12.0f), 1500, null );

  }
}
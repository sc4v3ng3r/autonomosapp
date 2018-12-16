package autonomos.com.br.jopeb.autonosapp;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;


public class NativeMapActivity extends AppCompatActivity implements OnMapReadyCallback{

  private GoogleMap m_map;
  public static final String KEY_LATITUDE = "latitude";
  public static final String KEY_LONGITUDE = "longitude";
  private LatLng m_myPlace;

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_maps);

    Bundle args = getIntent().getExtras();
    m_myPlace = new LatLng( args.getDouble(KEY_LATITUDE), args.getDouble(KEY_LONGITUDE) );

    SupportMapFragment fragment =  (SupportMapFragment) getSupportFragmentManager()
            .findFragmentById(R.id.map);

    if (fragment!=null)
      fragment.getMapAsync( this );
  }


  @Override
  public void onMapReady( GoogleMap googleMap ) {
    m_map = googleMap;
    m_map.addMarker(new MarkerOptions().position(m_myPlace).title("Marker in Sydney"));
    //m_map.moveCamera(CameraUpdateFactory.newLatLng(m_myPlace) );
    m_map.animateCamera(CameraUpdateFactory.newLatLngZoom(
            m_myPlace, 14.0f), 1500, null );

  }
}
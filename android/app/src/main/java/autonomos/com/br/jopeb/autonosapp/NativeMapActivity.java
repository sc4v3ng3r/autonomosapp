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

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_maps);

    SupportMapFragment fragment =  (SupportMapFragment) getSupportFragmentManager()
            .findFragmentById(R.id.map);

    if (fragment!=null)
      fragment.getMapAsync( this );
  }


  @Override
  public void onMapReady(GoogleMap googleMap) {
    m_map = googleMap;
    // Add a marker in Sydney and move the camera
    LatLng sydney = new LatLng(-34.0, 151.0);
    m_map.addMarker(new MarkerOptions().position(sydney).title("Marker in Sydney"));
    m_map.moveCamera(CameraUpdateFactory.newLatLng(sydney));

  }
}
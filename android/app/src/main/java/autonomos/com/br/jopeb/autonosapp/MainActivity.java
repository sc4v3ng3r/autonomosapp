package autonomos.com.br.jopeb.autonosapp;
import android.content.Intent;
import android.os.Bundle;
import java.util.ArrayList;
import java.util.HashMap;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

  public static final String CHANNEL = "autonomos.com.br.jopeb.autonosapp";
  public static final String METHOD_SHOW_MAPS_ACTIVITY = "show_maps_activity";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    GeneratedPluginRegistrant.registerWith( this );

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {

              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method){
                  case METHOD_SHOW_MAPS_ACTIVITY:
                    ArrayList< HashMap<String,Object> > dataList = methodCall.argument("dataList");
                    Double latitude = methodCall.argument("localLat");
                    Double longitude = methodCall.argument("localLong");

                    Intent it = new Intent(MainActivity.this, NativeMapActivity.class);
                    it.putExtra(NativeMapActivity.KEY_DATA_LIST, dataList );
                    it.putExtra(NativeMapActivity.KEY_LATITUDE, latitude);
                    it.putExtra(NativeMapActivity.KEY_LONGITUDE, longitude);
                    startActivity(it);
                    result.success(true);
                    break;

                    default:
                      break;
                }
              }
            }
    );
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
  }

}



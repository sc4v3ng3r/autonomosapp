package autonomos.com.br.jopeb.autonosapp;
import android.content.Intent;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;


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
                    Double lat = methodCall.argument(NativeMapActivity.KEY_LATITUDE);
                    Double _long = methodCall.argument(NativeMapActivity.KEY_LONGITUDE);

                    Intent it = new Intent(MainActivity.this, NativeMapActivity.class);
                    it.putExtra(NativeMapActivity.KEY_LATITUDE, lat);
                    it.putExtra(NativeMapActivity.KEY_LONGITUDE, _long);

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



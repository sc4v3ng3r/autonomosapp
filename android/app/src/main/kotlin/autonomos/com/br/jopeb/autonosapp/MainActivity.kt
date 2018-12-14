package autonomos.com.br.jopeb.autonosapp

import android.os.Bundle
import android.content.Intent
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
//import autonomos.com.br.jopeb.autonosapp.R

class MainActivity(): FlutterActivity() {
    companion object {
        const val CHANNEL = "autonomos.com.br.jopeb.autonosapp";
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "show") {
                val intent = Intent(this, NativeMapScreen::class.java)
                startActivity(intent)
                result.success(true)
            }

            else {
                result.notImplemented()
            }
        }
    }
}

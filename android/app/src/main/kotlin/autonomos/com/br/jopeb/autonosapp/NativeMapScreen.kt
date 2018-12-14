package autonomos.com.br.jopeb.autonosapp

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import autonomos.com.br.jopeb.autonosapp.MainActivity
import autonomos.com.br.jopeb.autonosapp.R
import android.util.Log

class NativeMapScreen : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        println("NAtiveMapSreen created!")
        val channel = MethodChannel(flutterView, MainActivity.CHANNEL)
        setContentView( R.layout.native_view_layout )
    }
}
package autonomos.com.br.jopeb.autonosapp;
import io.flutter.plugin.common.MethodChannel;

public class MethodChannelHolder {
    private static MethodChannelHolder _instance;
    private MethodChannel _channel;

    public static synchronized MethodChannelHolder getInstance(){
        if (_instance == null)
            _instance = new MethodChannelHolder();
        return _instance;
    }

    private MethodChannelHolder(){}

    public void setChannel(final MethodChannel channel){
        this._channel = channel;
    }

    public MethodChannel getChannel(){
        return this._channel;
    }

}
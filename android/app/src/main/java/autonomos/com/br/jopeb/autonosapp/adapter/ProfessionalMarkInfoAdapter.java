package autonomos.com.br.jopeb.autonosapp.adapter;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.Marker;

import java.util.HashMap;

import autonomos.com.br.jopeb.autonosapp.NativeMapActivity;
import autonomos.com.br.jopeb.autonosapp.R;

public class ProfessionalMarkInfoAdapter implements GoogleMap.InfoWindowAdapter {

    private Context m_ctx;
    private HashMap<String, Object> m_data;

    public ProfessionalMarkInfoAdapter(Context context){
        m_ctx = context;
    }

    @Override
    public View getInfoWindow(Marker marker) {
        return null;
    }

    @Override
    public View getInfoContents(Marker marker) {
        m_data = (HashMap<String, Object>) marker.getTag();

        View layout = ((Activity)m_ctx).getLayoutInflater()
                .inflate(R.layout.mark_info_layout, null);

        ((TextView)layout.findViewById(R.id.MarkInfoProfessionalName))
                .setText( (String) m_data.get(NativeMapActivity.KEY_NOME ));

        ((TextView)layout.findViewById(R.id.MarkInfoProfessionalPhone))
                .setText((String) m_data.get(NativeMapActivity.KEY_TELEFONE));

        return layout;
    }
}

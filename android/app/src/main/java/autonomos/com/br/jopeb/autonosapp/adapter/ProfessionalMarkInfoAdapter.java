package autonomos.com.br.jopeb.autonosapp.adapter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.Marker;
import java.util.HashMap;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Callback;
import autonomos.com.br.jopeb.autonosapp.NativeMapActivity;
import autonomos.com.br.jopeb.autonosapp.R;

public class ProfessionalMarkInfoAdapter implements GoogleMap.InfoWindowAdapter {

   // private Context m_ctx;
    private HashMap<String, Object> m_professionalJsonData;
    private View m_contentView;

    public ProfessionalMarkInfoAdapter(Context context){
        m_contentView = ((Activity)context).getLayoutInflater()
                .inflate(R.layout.mark_info_layout, null);
    }

    @Override
    public View getInfoWindow(Marker marker) {
        return null;
    }

    @Override
    public View getInfoContents(Marker marker) {
        m_professionalJsonData = (HashMap<String, Object>) marker.getTag();
        String url = (String) m_professionalJsonData.get(NativeMapActivity.KEY_PHOTO_URL);
        ImageView pictureView = m_contentView.findViewById(R.id.MarkInfoProfessionalPicture);

        if ( (url!=null) && (!url.isEmpty())) {
            Picasso.get().load(url).placeholder(R.drawable.app_icon)
                    .into( pictureView, new MarkerCallback(marker));
        }


        Log.i("DBG", "URL " + url);

        ((TextView)m_contentView.findViewById(R.id.MarkInfoProfessionalName))
                .setText( (String) m_professionalJsonData.get(NativeMapActivity.KEY_NOME ));
        ((TextView)m_contentView.findViewById(R.id.MarkInfoProfessionalPhone))
                .setText((String) m_professionalJsonData.get(NativeMapActivity.KEY_TELEFONE));

        return m_contentView;
    }

    // Callback is an interface from Picasso:
    static class MarkerCallback implements Callback {
        Marker marker = null;

        MarkerCallback(Marker marker)
        {
            this.marker = marker;
        }

        @Override
        public void onError(Exception e) {
            e.printStackTrace();
        }

        @Override
        public void onSuccess()
        {
            if (marker == null)
            {
                return;
            }

            if (!marker.isInfoWindowShown())
            {
                return;
            }

            // If Info Window is showing, then refresh it's contents:

            marker.hideInfoWindow(); // Calling only showInfoWindow() throws an error
            marker.showInfoWindow();
        }
    }

}
import 'package:rxdart/rxdart.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/firebase/FirebaseStateCityHelper.dart';
class CitiesBloc {
  //stream controller
  PublishSubject< List<Cidade> > _cityFetcher = new PublishSubject();

  // stream
  Observable<List<Cidade> > get allCities => _cityFetcher.stream;

  getCity(String key){
    FirebaseStateCityHelper.getCitiesFrom(key, _onData);
  }

  void _onData(List<Cidade> list){
    _cityFetcher.sink.add( list );
  }

  dispose(){
    _cityFetcher.close();
  }
}
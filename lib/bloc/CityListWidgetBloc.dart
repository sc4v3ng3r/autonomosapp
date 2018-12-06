import 'package:rxdart/rxdart.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/firebase/FirebaseStateCityHelper.dart';
class CityListWidgetBloc {


  //stream controller
  // stream
  final _cityInput = PublishSubject< List<Cidade> >();
  Observable< List<Cidade> > get allCities => _cityInput.stream;


  PublishSubject<String> _searchInput;
  //List<Cidade> _searchList = new List();
  //List<Cidade> _mainList;
  String _lastKey;

  /*
  CityListWidgetBloc(){

    _searchInput = new PublishSubject();

    _searchInput.stream.listen( (searchPattern) {
      if (searchPattern.isEmpty){
        getCity(_lastKey); // refaz uma consulta baseada na ultima key
        //_onData( _mainList ); // reenvia a lista local
      }

      else {
        _searchList.clear();
        _mainList.forEach( (city){
          if (city.nome.contains( searchPattern, 0) ){
            _searchList.add( city );
          }
        } );

        _cityInput.sink.add( _searchList );
      }

    });

  }*/


  getCity(String key){
    FirebaseStateCityHelper.getCitiesFrom(key, _onData);
    _lastKey = key;
  }

  searchFor(String pattern) {
    _searchInput.sink.add( pattern );

  }

  void _onData(List<Cidade> list){
    //_mainList = list;
    list.forEach( (cidade) {
      print(cidade);
    });

    _cityInput.sink.add( list );
    print("Block on data size ${list.length}");
  }

  dispose(){
    _cityInput.close();
    _searchInput.close();
  }
}
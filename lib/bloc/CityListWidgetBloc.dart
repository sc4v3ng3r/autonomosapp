import 'package:autonomosapp/utility/Constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:autonomosapp/model/Cidade.dart';
import 'package:autonomosapp/firebase/FirebaseStateCityHelper.dart';
import 'package:flutter/material.dart';

class CityListWidgetBloc {
  final _cityInput = ReplaySubject<List<Cidade>>(maxSize: 1);
  final _searchInput = new PublishSubject<String>();
  final _selectedItemsInput = new PublishSubject<List<Cidade>>();

  Observable<List<Cidade>> get allCities => _cityInput.stream;
  Observable<List<Cidade>> get selectedItems => _selectedItemsInput.stream;

  List<Cidade> _searchList = new List();
  List<Cidade> _selectedItems = new List();
  List<Cidade> _mainDataList;

  CityListWidgetBloc() {
    _searchInput.stream.listen((searchPattern) {
      if (searchPattern.isEmpty) {
        _onData(_mainDataList); // reenvia a lista local
      } else {

        if(_mainDataList != null){
          _searchList.clear();
          _mainDataList.forEach((city) {
            if (city.nome.toLowerCase().contains(searchPattern.toLowerCase())) {
              _searchList.add(city);
            }
          });
          _cityInput.sink.add(_searchList);
        }
      }
    });
  }

  void getCity( {@required String key}) {
      FirebaseStateCityHelper.getCitiesFrom(key)
          .then(
              (dataSnapshot) {
                print("then() $dataSnapshot");
                if (dataSnapshot != null){
                  _onData( _parseData(dataSnapshot) );
                }  else _onData(null);
              })
          .timeout( Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS), onTimeout: (){
            print("CityListWidgetBloc::getCity Timeout exception");
            _onData(null);
          });
    //_lastKey = key;
  }

  List<Cidade> _parseData (DataSnapshot dataSnapshot) {
    Map<String, dynamic> citiesMap = Map.from( dataSnapshot.value);
    List<Cidade> cityList = new List();

    citiesMap.forEach( (key, value) {
      Cidade city = Cidade.fromJson(Map.from(value));
      city.id = key; // id da cidade eh o nó raiz da cidade
      city.uf = dataSnapshot.key.toString();// a sigla do estado eh  Nó raiz do snapshot
      cityList.add(city);
    } );

    return cityList;
  }

  searchFor(String pattern) {
    _searchInput.sink.add(pattern);
  }

  void _onData(List<Cidade> list) {
    print("CityListWIdgetBloc List is: $list");
    _mainDataList = list;
    list?.sort((a, b) => (a.nome.compareTo(b.nome)));

    _cityInput.sink.add(list);
  }

  bool isSelected(Cidade item) {
    //print("isSelected ITEMS TOTAL: ${_selectedItems.length}");
    return _selectedItems.contains(item);
  }

  void selectItem(Cidade item) {
    _selectedItems.add(item);
    //print("SELECTED ITEMS TOTAL: ${_selectedItems.length}");
    _selectedItemsInput.sink.add(_selectedItems);
  }

  void selectItems(List<Cidade> items){
    _selectedItems.addAll( items);
    _selectedItemsInput.sink.add( _selectedItems );
  }

  void removeItem(Cidade item) {
    _selectedItems.remove(item);
    //print("REMOVE ITEMS TOTAL: ${_selectedItems.length}");
    _selectedItemsInput.sink.add(_selectedItems);
  }

  dispose() {
    print("CityListWidgetBloc dispose()");
    _cityInput?.close();
    _searchInput?.close();
    _selectedItemsInput?.close();
  }
}

class CityListWidgetBlocProvider extends InheritedWidget {
  final _bloc = CityListWidgetBloc();

  CityListWidgetBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CityListWidgetBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CityListWidgetBlocProvider)
            as CityListWidgetBlocProvider)
        ._bloc;
  }
}

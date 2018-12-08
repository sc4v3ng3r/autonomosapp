import 'package:rxdart/rxdart.dart';
import 'package:autonos_app/model/Cidade.dart';
import 'package:autonos_app/firebase/FirebaseStateCityHelper.dart';
import 'package:flutter/material.dart';

class CityListWidgetBloc {
  final _cityInput = PublishSubject<List<Cidade>>();
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
        _searchList.clear();
        _mainDataList.forEach((city) {
          if (city.nome.toLowerCase().contains(searchPattern.toLowerCase())) {
            _searchList.add(city);
          }
        });

        _cityInput.sink.add(_searchList);
      }
    });
  }

  getCity( {@required String key}) {
    FirebaseStateCityHelper.getCitiesFrom(key, _onData);
    //_lastKey = key;
  }

  searchFor(String pattern) {
    _searchInput.sink.add(pattern);
  }

  void _onData(List<Cidade> list) {
    _mainDataList = list;
    list.sort((a, b) => (a.nome.compareTo(b.nome)));
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
    print("CityListWidget dispose()");
    _cityInput.close();
    _searchInput.close();
    _selectedItemsInput.close();
  }
}

class CityListWidgetBlocProvider extends InheritedWidget {
  final bloc = CityListWidgetBloc();

  CityListWidgetBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CityListWidgetBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CityListWidgetBlocProvider)
            as CityListWidgetBlocProvider)
        .bloc;
  }
}

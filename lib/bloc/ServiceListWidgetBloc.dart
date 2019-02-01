import 'package:rxdart/rxdart.dart';
import 'package:autonomosapp/model/Service.dart';
import 'package:autonomosapp/firebase/FirebaseServicesHelper.dart';
import 'package:flutter/material.dart';

class ServiceListWidgetBloc {
  final _servicesInput = PublishSubject<List<Service>>();
  final _searchInput = new PublishSubject<String>();
  final _selectedItemsInput = new PublishSubject<List<Service>>();

  Observable<List<Service>> get getAllServices => _servicesInput.stream;
  Observable<List<Service>> get selectedItems => _selectedItemsInput.stream;

  List<Service> _searchList = new List();
  List<Service> _selectedItems = new List();
  List<Service> _mainDataList;

  ServiceListWidgetBloc() {
    _searchInput.stream.listen( (searchPattern) {
      if (searchPattern.isEmpty) {
        print("search pattern is empty");
        _onData(_mainDataList); // reenvia a lista local
      }
      else {
        _searchList.clear();
        _mainDataList.forEach((service) {
          if (service.name.toLowerCase().contains(searchPattern.toLowerCase())) {
            _searchList.add(service);
          }
        });

        _servicesInput.sink.add(_searchList);
      }
    });
  }

  loadServicesFromWeb() {
    if (_mainDataList == null)
      FirebaseServicesHelper.getAllServices( _onData );
    else
      _onData(_mainDataList);
    //_lastKey = key;
  }

  searchFor(String pattern) {
    _searchInput.sink.add(pattern);
  }

  void _onData(List<Service> list) {
    _mainDataList = list;
    list.sort((a, b) => (a.name.compareTo(b.name)));
    _servicesInput.sink.add(list);
  }

  bool isSelected(Service item) {
    //print("isSelected ITEMS TOTAL: ${_selectedItems.length}");
    return _selectedItems.contains(item);
  }

  void selectItem(Service item) {
    _selectedItems.add(item);
    //print("SELECTED ITEMS TOTAL: ${_selectedItems.length}");
    _selectedItemsInput.sink.add(_selectedItems);
  }

  void selectItems(List<Service> items){
    _selectedItems.addAll( items);
    _selectedItemsInput.sink.add( _selectedItems );
  }

  void removeItem(Service item) {
    _selectedItems.remove(item);
    //print("REMOVE ITEMS TOTAL: ${_selectedItems.length}");
    _selectedItemsInput.sink.add(_selectedItems);
  }

  dispose() {
    print("ServiceListWidgetBloc dispose()");
    _servicesInput.close();
    _searchInput.close();
    _selectedItemsInput.close();
  }
}

class ServiceListWidgetBlocProvider extends InheritedWidget {
  final bloc = ServiceListWidgetBloc();

  ServiceListWidgetBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ServiceListWidgetBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ServiceListWidgetBlocProvider)
    as ServiceListWidgetBlocProvider)
        .bloc;
  }
}

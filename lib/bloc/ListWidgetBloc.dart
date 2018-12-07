import 'package:rxdart/rxdart.dart';

/**
 * Esse é o bloc generico para ser usando em conjunto com um ListWidget,
 * Por exemllo um CityListWidget ou um, ServiceListWidget. Nesse componente
 * está a lógica de negocios de um LisView, ou seja, a logica da seleção & clicks.
 *
 *  Nesse caso a regra de negócio implementada aqui é aseleção mutipla de itens
 *  do ListView.
 */

//TODO a ideia eh fazer deste modelo de classe, uma interface generica programavel
// para melhorar a reutilização de código.

class ListWidgetBloc<T extends Comparable<T>> {

  final _selectedItemsInput = PublishSubject< List<T> > ();
  Observable< List<T> > get selectedItems => _selectedItemsInput.stream;
  List<T> _selectedItems = new List();


  void select(T item){
    if (!_selectedItems.contains(item))
      _addItem(item);
  }

  void _addItem(T item){
    _selectedItems.add(item);
    _selectedItemsInput.sink.add(_selectedItems );
  }

  void unselect(T item){
    if (contains(item)){
      _selectedItems.remove(item);
      _selectedItemsInput.sink.add( _selectedItems );
    }
  }

  bool contains(T item) => _selectedItems.contains(item);

  dispose(){
    _selectedItemsInput.close();
  }
}
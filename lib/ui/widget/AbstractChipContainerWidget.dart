import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/ChipContainerController.dart';
export 'package:autonomosapp/ui/widget/ChipContainerController.dart';

abstract class AbstractChipContainerWidget<T> extends StatefulWidget {

  final Function _deletedCallback;
  final Color _chipBackgroundColor;
  final Function _controllerCallback;

  AbstractChipContainerWidget({
    @required Function onDelete(T item),
    @required Function controllerCallback(ChipContainerController controller),
    Color chipBackgroundColor: Colors.red}) :
        _controllerCallback = controllerCallback,
        _chipBackgroundColor = chipBackgroundColor,
        _deletedCallback = onDelete;

  @override
  State createState() => _AbstractChipContainerWidgetState();

  Widget chipLabel(T element);

}

class _AbstractChipContainerWidgetState<T> extends State<AbstractChipContainerWidget> {
  List<T> _localDataList = new List();
  ChipContainerController controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController(){
    controller = ChipContainerController();
    controller.addAll = this.addAll;
    controller.clear = this.clear;
    controller.replaceAll = this.replaceAll;
    controller.remove = this.delete;
    controller.insert = this.addItem;
    widget._controllerCallback(controller);
  }

  @override
  Widget build(BuildContext context) {
    //print("AbstractChipContainerWidget build()");
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 2.0,
        runSpacing: 2.0,
        children: _getChipList(),
      ),
    );
  }

  List<Widget> _getChipList(){
    //print("AbstractChipContainerWidget getChipList()");
    List<Chip> chipList = new List();
    if (widget._deletedCallback == null){

      for (int i=0; i < _localDataList.length; i++){
        T data = _localDataList[i];
        print("adding chip!");
        Chip chip = Chip(
          label: widget.chipLabel( data ),
          backgroundColor: widget._chipBackgroundColor,
          onDeleted: null,
        );

        chipList.add( chip );
      }
    }

    else {
      for (int i=0; i < _localDataList.length; i++){
        T data = _localDataList[i];
        print("adding chip!");
        Chip chip = Chip(
          label: widget.chipLabel( data ),
          backgroundColor: widget._chipBackgroundColor,
          onDeleted: (){
            delete(data);
          },
        );
        chipList.add( chip );
      }
    }
    return chipList;
  }

  delete(T item){
    _localDataList.remove( item );
    setState(() {});

    widget._deletedCallback( item );
  }

  addItem( T item ){
    print("_addItem");
    _localDataList.add( item );
    setState(() {});
  }

  clear(){
    print("_clear");
    _localDataList.clear();
    setState(() {});
  }

  addAll(List<T> dataList){
    print("_addAll");
    _localDataList.addAll(dataList);
    setState(() {});
  }

  replaceAll(List<T> dataList){
    print("replaceAll");
    _localDataList.clear();
    _localDataList.addAll(dataList);
    setState(() {});
  }

}
import 'package:autonos_app/model/Cidade.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/ui/widget/AbstractListFragmentWidget.dart';

class CitiesListFragment extends AbstractListFragmentWidget<Cidade> {
  CitiesListFragment(List itemList,  )
      : super(itemList: itemList);

  @override
  Widget onCreateWidget(data, int index) {
    List<Cidade> _selectedItens = List();

    Text cityText = Text(data.nome, style: TextStyle(fontSize: 20.0));

    return Card(
      elevation: 5.0,
      child: ListTile(
        title: cityText,
        onTap: () {},

      ),
    );
  }
}

class CityListItem {
  Cidade cidade;
  Color corItem;

  CityListItem(Cidade cidade, var corItem)
      : this.cidade = cidade,
        this.corItem = corItem;
}
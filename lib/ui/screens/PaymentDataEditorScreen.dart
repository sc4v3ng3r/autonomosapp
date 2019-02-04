import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/ui/widget/NiftyRowDivisorWidget.dart';

class PaymentDataEditorScreen extends StatefulWidget {
  final List<String> _paymentAlreadySelected;
  final bool _emissorData;
  final _activeColor = Colors.green[200];
  final _NOT_VALUE = 0;
  final _YES_VALUE = 1;

  final List<String> _PAYMENT_OPTIONS = <String>[
    "Cartão de Crédito", "Cartão de Débito",
    "Cheque", "Dinheiro", "Paypal", "Pickpay"
  ];

  PaymentDataEditorScreen({@required List<String> payments, @required bool emissorData})
    : _paymentAlreadySelected = payments,
      _emissorData = emissorData;

  @override
  _PaymentDataEditorScreenState createState() => _PaymentDataEditorScreenState();
}

class _PaymentDataEditorScreenState extends State<PaymentDataEditorScreen> {

  List<String> _selectedData;
  int _radioGroupValue;

  @override
  void initState() {
    super.initState();
    _radioGroupValue = (widget._emissorData) ? widget._YES_VALUE : widget._NOT_VALUE;
    _selectedData =  List.from(widget._paymentAlreadySelected);
  }

  @override
  Widget build(BuildContext context) {
    var chipList = _getChipList();

    //TODO esse grupo pode ser uma outra widget
    final radioGroup = Row(
        children: <Widget>[
          Text('Emite ',style: TextStyle(color: Colors.black),),
          Text('Nota fiscal: ', style: TextStyle(
              color:Colors.black,
              fontWeight: FontWeight.bold),
          ),

          new Radio(
            value: widget._NOT_VALUE,
            groupValue: _radioGroupValue,
            onChanged: _onRadioClicked,
            activeColor: widget._activeColor,

          ), Text('Não'),

          new Radio(
            value: widget._YES_VALUE,
            groupValue: _radioGroupValue,
            onChanged: _onRadioClicked,
            activeColor: widget._activeColor,
          ), Text('Sim')
        ],
      );

    var body = Material(
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
        child: Column(
          children: <Widget>[
            NiftyRowDivisorWidget(title: "Opções de pagamento"),
            SizedBox(height: 8.0,),
            Wrap(
              children: chipList,
              spacing: 2.0,
            ),
            SizedBox(height: 8.0,),
            NiftyRowDivisorWidget(title: "Nota Fiscal"),
            radioGroup,

          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Opções de Pagamento"),
      ),

      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.done, color: Colors.white,),
          onPressed: () {
            _saveData();
            print("PAYMENT OPTIONS: ");
            print("NOTA FISCAL: $_radioGroupValue");
            for(String str in _selectedData)
              print(str);
            Navigator.pop(this.context);
          }),

      body: body,
    );

  }
  
  /// Método que reliza a criação da lista de chips
  List<Widget> _getChipList(){
    var chipList = List<Widget>();
    for(String paymentOption in widget._PAYMENT_OPTIONS){
      chipList.add(
          FilterChip(
            label: Text(paymentOption),
            selected: (_selectedData.contains( paymentOption ) ),
            selectedColor: Colors.green[200],
            onSelected: (selected){
              (selected) ? _selectedData.add( paymentOption ) :
              _selectedData.removeWhere( (option) => (option == paymentOption) );
              setState((){});

            },
          )
      );
    } // end for loop
    return chipList;
  }

  void _saveData(){
    User user = UserRepository().currentUser;
    user.professionalData.emissorNotaFiscal = (_radioGroupValue == 1);
    user.professionalData.formasPagamento = _selectedData;
    FirebaseUserHelper.setUserProfessionalData(
      uid: user.uid,
      data: user.professionalData
    );
  }

  void _onRadioClicked(int radioValue){
    setState(() => _radioGroupValue = radioValue );
  }
}

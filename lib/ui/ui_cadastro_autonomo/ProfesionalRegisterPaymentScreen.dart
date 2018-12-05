import 'package:autonos_app/ui/widget/NextButton.dart';
import 'package:flutter/material.dart';

class ProfesionalRegisterPaymentScreen extends StatefulWidget {
  @override
  ProfesionalRegisterPaymentScreenState createState() => ProfesionalRegisterPaymentScreenState();
}

class ProfesionalRegisterPaymentScreenState extends State<ProfesionalRegisterPaymentScreen> {

  List<String> _formasDePagamento = <String>[
    "Cartão de Crédito",
    "Cartão de Débito",
    "Cheque",
    "Dinheiro",
    "Paypal",
    "Pickpay"
  ];

  int _radioValue = 0;
  bool _emiteNota = false;
  Color _colorChip = Colors.blueGrey[200];
  List<String> _formasDePagamentoChipSelecionado = <String>[];

  //TODO WHAAATTTTTT ?????????????????????
  Iterable<Widget> get _transformaFormasDePagamentoEmChip sync* {
    for (String nomePagamento in _formasDePagamento) {
      yield Padding(
        padding: EdgeInsets.all(4.0),
        child: FilterChip(
            label: Text(nomePagamento),
            selected: _formasDePagamentoChipSelecionado.contains(nomePagamento),
            backgroundColor: _colorChip,
            disabledColor: _colorChip,
            selectedColor: Colors.green[200],
            onSelected: (bool selecionado) {
              setState(() {
                if (selecionado == true) {
                  _formasDePagamentoChipSelecionado.add(nomePagamento);
                } else {
                  _formasDePagamentoChipSelecionado.removeWhere((String nome) {
                    return nome == nomePagamento;
                  });
                }
              });
            }),
      );
    }
  }

  void _emiteNotaChange(int i){
    _radioValue = i;
    //setState(() {
      if(i == 0)
        _emiteNota = false;
      else
        _emiteNota = true;
    //});
  }

  List<Widget> _buildForm() {

    final formasDePagamentoLabel = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
      child: Text(
        'Formas de pagamento que você trabalha:',
        style: TextStyle(color: Colors.grey),
      ),
    );

    final chipList = Padding(
      padding: EdgeInsets.fromLTRB(16.0, .0, 16.0, 16.0),
      child: Wrap(
        children: _transformaFormasDePagamentoEmChip.toList(),
      ),
    );

    final notaFiscalLabel = Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Text('Emite ',style: TextStyle(color: Colors.grey),),
          Text('Nota fiscal: ',style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),),
          new Radio(
              value: 0,
              groupValue:_radioValue,
              onChanged: _emiteNotaChange,
              activeColor: Colors.red[300],

          ),
          Text('Não'),
          new Radio(
            value: 1,
            groupValue: _radioValue,
            onChanged: _emiteNotaChange,
            activeColor: Colors.red[300],
          ),
          Text('Sim')
        ],
      ),
    );

    final nextButton = NextButton(
      text: '[3/3] Finalizar Cadastro',
      textColor: Colors.white,
      buttonColor: Colors.green[300],
      callback: () {
        print("Finalizar cadastro!");
      },
    );

    final form = Form(
      child: ListView(
        children: <Widget>[
          formasDePagamentoLabel,
          chipList,
          Divider(),
          notaFiscalLabel,
          Divider(),
          nextButton
        ],
      ),
    );
    var list = new List<Widget>();
    list.add(form);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Formas de Pagamento',
          style: TextStyle(color: Colors.blueGrey),
        ),
        iconTheme: IconThemeData(color: Colors.red[300]),
      ),
      body: new Stack(
        children: _buildForm(),
      ),
    );
  }
}
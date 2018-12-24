import 'package:autonos_app/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonos_app/ui/screens/MainScreen.dart';
import 'package:autonos_app/ui/widget/NextButton.dart';
import 'package:autonos_app/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonos_app/firebase/FirebaseUserHelper.dart';
import 'package:autonos_app/ui/widget/ModalRoundedProgressBar.dart';

class ProfessionalRegisterPaymentScreen extends StatefulWidget {

  final ProfessionalRegisterFlowBloc _bloc;
  ProfessionalRegisterPaymentScreen({@required ProfessionalRegisterFlowBloc bloc}) :
        _bloc = bloc;

  @override
  ProfessionalRegisterPaymentScreenState createState() =>
      ProfessionalRegisterPaymentScreenState();
}

class ProfessionalRegisterPaymentScreenState extends State<ProfessionalRegisterPaymentScreen> {

  List<String> _formasDePagamento = <String>[
    "Cartão de Crédito",
    "Cartão de Débito",
    "Cheque",
    "Dinheiro",
    "Paypal",
    "Pickpay"
  ];

  ProgressBarHandler _handler;
  int _radioValue = 0;
  bool _emiteNota = false;
  Color _colorChip = Colors.blueGrey[200];
  List<String> _formasDePagamentoChipSelecionado = <String>[];

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
    setState(() {
      if(i == 0)
        _emiteNota = false;
      else
        _emiteNota = true;
    });
  }

  Widget _buildForm() {

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

        widget._bloc.currentData.emissorNotaFiscal = _emiteNota;
        widget._bloc.currentData.formasPagamento = _formasDePagamentoChipSelecionado;
        _finishRegister();
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

    return form;
  }


  Future<void> _finishRegister() async {
    _handler.show();
    FirebaseUserHelper.registerUserProfessionalData(widget._bloc.currentData)
        .then( (_) {
          _handler.dismiss();
          UserRepository().currentUser.professionalData = widget._bloc.currentData;
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      MainScreen() ),
                  (Route<dynamic> route)  => false);

    } ).catchError((error) {
        _handler.dismiss();
        print("registerUserProfessionalData $error");
    });
  }

  @override
  Widget build(BuildContext context) {

    var modal = ModalRoundedProgressBar(
        handleCallback: (handler){ _handler = handler; },
        message: "Registrando...",);

    var scaffold = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text( 'Formas de Pagamento',
          style: TextStyle(color: Colors.blueGrey),
        ),
        iconTheme: IconThemeData(color: Colors.red[300]), ),

        body: _buildForm(),
      );

      return Stack(
        children: <Widget>[
          scaffold,
          modal
        ],
      );

  }

  @override
  void initState() {
    widget._bloc.currentData.uid = UserRepository().currentUser.uid;
    super.initState();

  }
}

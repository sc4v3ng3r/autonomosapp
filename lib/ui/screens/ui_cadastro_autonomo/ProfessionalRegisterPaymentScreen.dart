import 'package:autonomosapp/bloc/ProfessionalRegisterFlowBloc.dart';
import 'package:autonomosapp/ui/screens/MainScreen.dart';
import 'package:autonomosapp/ui/widget/NextButton.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/ui/widget/ModalRoundedProgressBar.dart';

class ProfessionalRegisterPaymentScreen extends StatefulWidget {

  final ProfessionalRegisterFlowBloc _bloc;

  ProfessionalRegisterPaymentScreen( { @required ProfessionalRegisterFlowBloc bloc } ) :
        _bloc = bloc;

  @override
  ProfessionalRegisterPaymentScreenState createState() =>
      ProfessionalRegisterPaymentScreenState();
}

class ProfessionalRegisterPaymentScreenState extends State<ProfessionalRegisterPaymentScreen> {

  List<String> _formasDePagamento = <String>[
    "Cartão de Crédito", "Cartão de Débito",
    "Cheque", "Dinheiro", "Paypal", "Pickpay"
  ];

  ProgressBarHandler _handler;
  int _radioValue = 0;
  bool _emiteNota = false;
  List<String> _formasDePagamentoChipSelecionado = <String>[];
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey();

  Iterable<Widget> get _transformaFormasDePagamentoEmChip sync* {
    for (String nomePagamento in _formasDePagamento) {
      yield Padding(
        padding: EdgeInsets.all(4.0),
        child: FilterChip(
            label: Text(nomePagamento,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            selected: _formasDePagamentoChipSelecionado.contains(nomePagamento),
            backgroundColor: Theme.of(context).primaryColor,
            selectedColor: Colors.green,
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

  Widget _buildLayout() {

    final formasDePagamentoLabel = Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
        child: Text(
          'Formas de pagamento que você trabalha:',
          style: TextStyle(color: Theme.of(context).accentColor ),
        ),
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
          Text('Emite ',style: TextStyle(color: Theme.of(context).accentColor ),),
          Text('Nota fiscal: ',style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold),
          ),

          new Radio(
            value: 0,
            groupValue:_radioValue,
            onChanged: _emiteNotaChange,
            activeColor: Theme.of(context).primaryColor,
          ),

          Text('Não'),

          new Radio(
            value: 1,
            groupValue: _radioValue,
            onChanged: _emiteNotaChange,
            activeColor: Theme.of(context).primaryColor,
          ),

          Text('Sim'),
        ],
      ),
    );

    final nextButton = NextButton(
      text: '[4/4] Finalizar Cadastro',
      textColor: Colors.white,
      buttonColor: Colors.green,
      callback: () {

        if (_validade() ){
          widget._bloc.currentData.emissorNotaFiscal = _emiteNota;
          widget._bloc.currentData.formasPagamento = _formasDePagamentoChipSelecionado;

          _finishRegister();
        }

      },
    );

    final form = Form(
      child: Column(
        mainAxisSize: MainAxisSize.max,
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

    return SingleChildScrollView(
      child: form,
    );
  }

  bool _validade(){
    final bool flag = false;
    if (_formasDePagamentoChipSelecionado.isEmpty){
      _showSnackBarWarning("Selecione pelo menos uma forma de pagamento");
      return flag;
    }
    return !flag;
  }

  void _showSnackBarWarning(String msg){
    _scaffoldKey.currentState
        .showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            duration: Duration(milliseconds: 1900),
            content: Text(msg, style: TextStyle(
                color: Colors.white),
            ),
          ),
    );
  }

  Future<void> _finishRegister() async {

    _handler.show(message: "Registrando...");
    String uid = UserRepository.instance.currentUser.uid;

    if ( widget._bloc.hasDocuments() ){
      widget._bloc.insertEstadoValidacao(Constants.ESTADO_AVALIACAO);
      widget._bloc.uploadDocuments(uid);
    }
    else  widget._bloc.insertEstadoValidacao(Constants.ESTADO_INDEFINIDO);

    FirebaseUserHelper.setUserProfessionalData(
        data: widget._bloc.currentData,
        uid: UserRepository().currentUser.uid ).then( (_) {
          _handler.dismiss();
          UserRepository.instance.currentUser.professionalData
            = widget._bloc.currentData;

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

    final modal = ModalRoundedProgressBar(
        handleCallback: (handler){ _handler = handler; },);

    final scaffold = Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text( 'Formas de Pagamento'),
        brightness: Brightness.dark,
      ),
        body: _buildLayout(),
      );

      return Stack(
        children: <Widget>[
          scaffold,
          modal,
        ],
      );

  }

}

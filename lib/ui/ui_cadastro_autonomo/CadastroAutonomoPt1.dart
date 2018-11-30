import 'package:autonos_app/ui/ui_cadastro_autonomo/Atuacao.dart';
import 'package:autonos_app/ui/ui_cadastro_autonomo/PerfilDetalhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CadastroAutonomoPt1 extends StatefulWidget {
  @override
  CadastroAutonomoPt1State createState() => CadastroAutonomoPt1State();
}

class CadastroAutonomoPt1State extends State<CadastroAutonomoPt1> {
  int _radioValue = 0;
  String _tipoPessoa = '';

  var typeCpf;
  var typeCnpj;
  var typeTelefone;

  FocusNode _tipoPessoaFocus;
  FocusNode _descricaoFocus;
  FocusNode _telefoneFocus;

  static const SizedBox _VERTICAL_SEPARATOR = SizedBox(
    height: 16.0,
  );

  void _handleRadioValueChange(int i) {
    _radioValue = i;
    setState(() {
      switch (_radioValue) {
        case 0:
          _tipoPessoa = 'CPF';
          break;
        case 1:
          _tipoPessoa = 'CNPJ';
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _handleRadioValueChange(0);

    typeCpf = new MaskedTextController(mask: '000.000.000-00', text: 'CPF');
    typeCnpj = new MaskedTextController(mask: '00.000.000/0000-00');
    typeTelefone = new MaskedTextController(mask: '(00) 00000-0000');

    _tipoPessoaFocus = new FocusNode();
    _descricaoFocus = new FocusNode();
    _telefoneFocus = new FocusNode();
  }

  @override
  void dispose() {
    _tipoPessoaFocus.dispose();
    _descricaoFocus.dispose();
    _telefoneFocus.dispose();
  }

  MaskedTextController _typeCpfOrCnpj() {
    if (_tipoPessoa == 'CPF')
      return typeCpf;
    else
      return typeCnpj;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Informações Básicas',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red[400]),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/usuario_drawer.png"),
                        backgroundColor: Colors.black87,
                        maxRadius: 48.0,
                      ),
                    ],
                  ),
                  _VERTICAL_SEPARATOR,
                  Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                          activeColor: Colors.red[400],
                        ),
                        new Text('Pessoa Física'),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                          activeColor: Colors.red[400],
                        ),
                        new Text('Pessoa Jurídica')
                      ],
                    ),

                   TextFormField(
                      focusNode: _tipoPessoaFocus,
                      autofocus: false,
                      controller: _typeCpfOrCnpj(),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (dataType) {
                        setState(() {
                          _tipoPessoaFocus.unfocus();
                          FocusScope.of(context).requestFocus(_telefoneFocus);
                        });
                      },
                      decoration: InputDecoration(
                          labelText: _tipoPessoa,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red[400],
                              ),
                              borderRadius: BorderRadius.circular(22.0))),
                    ),
                  ]),
                  _VERTICAL_SEPARATOR,
                  TextFormField(
                    focusNode: _telefoneFocus,
                    controller: typeTelefone,
                    autofocus: false,
                    keyboardType: TextInputType.number,

                    onFieldSubmitted: (dataType) {
                      setState(() {
                        _telefoneFocus.unfocus();
                        FocusScope.of(context).requestFocus(_descricaoFocus);
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red[400],
                            ),
                            borderRadius: BorderRadius.circular(22.0))),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: .0, vertical: 16.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
                        onPressed: initState,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.fingerprint,color: Colors.red[400],),
                            ),
                            Expanded(
                              child: Text(
                                'Insira seus documentos',
                                style: TextStyle(color: Colors.red[400]),),
                            ),
                          ],
                        ),
                        color: Colors.white,
                      )),
                  _VERTICAL_SEPARATOR,
                  TextFormField(
                    focusNode: _descricaoFocus,
                    maxLength: 48,
                    maxLines: 4,
                    onFieldSubmitted: (dataTyped) {
                      setState(() {
                        _descricaoFocus.unfocus();
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Fale um pouco de você',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: .0, vertical: 16.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder:
                                (BuildContext context) => Atuacao())
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '[1/3]   Próximo Passo',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.directions_run,color: Colors.white,),
                            ),
                          ],
                        ),
                        color: Colors.red[400],
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}

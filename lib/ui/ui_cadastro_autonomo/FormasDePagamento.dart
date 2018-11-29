import 'package:flutter/material.dart';

class FormaDePagamento extends StatefulWidget{
  @override
  FormaDePagamentoState createState() => FormaDePagamentoState();
}

class FormaDePagamentoState extends State<FormaDePagamento>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          title: Text('Formas de Pagamento', style: TextStyle(color: Colors.black87),),
        iconTheme: IconThemeData(color: Colors.red[400]),
      ),
    );
  }

}
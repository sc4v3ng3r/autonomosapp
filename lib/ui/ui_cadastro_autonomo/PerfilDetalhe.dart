import 'package:autonos_app/ui/ui_cadastro_autonomo/ProfesionalRegisterPaymentScreen.dart';
import 'package:flutter/material.dart';

class PerfilDetalhe extends StatefulWidget {
  @override
  PerfilDetalheState createState() => PerfilDetalheState();
}

class PerfilDetalheState extends State<PerfilDetalhe> {
  static final SizedBox _verticalSeparator = new SizedBox(
    height: 16.0,
  );

  List _estados = [
    "Amapá",
    "Amazonas",
    "Bahia",
    "Brasilia",
    "Ceará",
    "Curitiba",
    "Espirito Santo",
    "Goiás",
    "Macapa",
    "Manaus",
    "Mato Grosso do Sul",
    "Minas Gerais",
    "Paraná",
    "Pernambuco",
    "Pará",
    "Rio Grande Do Norte",
    "Rio Grande Do Sul",
    "Rio de Janeiro",
    "São Pauro",
    "Santa Catarina",
    "Sergipe",
  ];

  List _cidadesBa = [
    "Amelia Rodrigues",
    "Baixios",
    "Conde",
    "Conceição do Jacuípe",
    "Conceição de Coité",
    "Feira de Santana",
  ];

  List _cidadesAc = [
    "Parque dos Dinssauros",
    "Jurassic Park",
    "Dino Town",
    "Cretaciolandia",
  ];
  
  List _servicos = [
	"Alarmes",
	"Aulas de violão",
	"Aulas de matematica",
	"Aulas de portugues",
	"Diarista",
	"Mecanico"
  ];

  List _cidadesSelcionadas = new List();
  List _servicosSelecionados = new List();

  List _cidades;
  List<Chip> _chipList = [];
  List<Chip> _chipListServicos = [];
  List<DropdownMenuItem<String>> _dropDownMenuItem;
  List<DropdownMenuItem<String>> _dropDownMenuItemCidades;
  List<DropdownMenuItem<String>> _dropDownMenuItemServicos;
  String _estadoAtual;
  String _cidadeAtual;
  String _servicoAtual;

  @override
  void initState() {
    _cidades = _cidadesAc;
    _dropDownMenuItem = getDropDownMenuItem();
    _dropDownMenuItemCidades = getDropDownMenuItemCidades();
    _dropDownMenuItemServicos = getDropDownMenuItemServicos();
	_estadoAtual = _dropDownMenuItem[0].value;
    _cidadeAtual = _dropDownMenuItemCidades[0].value;
	_servicoAtual = _dropDownMenuItemServicos[0].value;

    super.initState();
  }
  
  List<DropdownMenuItem<String>> getDropDownMenuItemServicos() {
	  List<DropdownMenuItem<String>> itens = new List();
	  for (String servico in _servicos) {
      itens.add(new DropdownMenuItem(value: servico, child: new Text(servico)));
    }
    return itens;
  }
  
  List<DropdownMenuItem<String>> getDropDownMenuItem() {
    List<DropdownMenuItem<String>> itens =  new List();

    for (String estado in _estados) {
      itens.add(new DropdownMenuItem(
          value: estado,
          child: new Text(estado))
      );
    }

    return itens;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemCidades() {
    List<DropdownMenuItem<String>> itens = new List();
    setState(() {
      for (String cidade in _cidades) {
        itens.add(new DropdownMenuItem(value: cidade, child: new Text(cidade)));
      }
    });
    return itens;
  }

  void changeDropDownItens(String estadoSelecionado) {

    print("$estadoSelecionado selecionado");
    setState(() {
      if (estadoSelecionado == "Bahia") {
        _cidades = _cidadesBa;
        _cidadeAtual = _cidades[0];
      } else {
        _cidades = _cidadesAc;
        _cidadeAtual = _cidades[0];
      }
      _estadoAtual = estadoSelecionado;
    });
  }

  void removeChip(String nomeChip) {
    _cidadesSelcionadas.remove(nomeChip);
    _trasnformaListaSelecionadoEmChip();
  }
  void removeChipServico(String nomeChipServico){
	  _servicosSelecionados.remove(nomeChipServico);
	  _trasnformaListaServicoSelecionadoEmChip();
  }

  void _trasnformaListaSelecionadoEmChip() {
    _chipList.clear();
    for (String nomeCidade in _cidadesSelcionadas) {
      Chip chip = Chip(
        onDeleted: () {
          setState(() {
            removeChip(nomeCidade);
          });
        },
        backgroundColor: Colors.red[400],
        label: Text(
          nomeCidade,
          style: TextStyle(color: Colors.white),
        ),
      );
      setState(() {
        _chipList.add(chip);
      });
    }
  }
  
  void _trasnformaListaServicoSelecionadoEmChip() {
    _chipListServicos.clear();
    for (String nomeServico in _servicosSelecionados) {
      Chip chip = Chip(
        onDeleted: () {
          setState(() {
            removeChipServico(nomeServico);
          });
        },
        deleteIconColor: Colors.white,
        backgroundColor: Colors.black87,
        label: Text(
          nomeServico,
          style: TextStyle(color: Colors.white),
        ),
      );
      setState(() {
        _chipListServicos.add(chip);
      });
    }
  }

  void _changeDropDownItensCidades(String cidadeSelecionada) {
    print("$cidadeSelecionada selecionado");
    setState(() {
      _cidadeAtual = cidadeSelecionada;
      if(!_cidadesSelcionadas.contains(_cidadeAtual))
      _cidadesSelcionadas.add(cidadeSelecionada);
      
      _trasnformaListaSelecionadoEmChip();
    });
  }
    void _changeDropDownItensServicos(String servicoSelecionado) {
    print("$servicoSelecionado selecionado");
    setState(() {
      _servicoAtual = servicoSelecionado;
      if(!_servicosSelecionados.contains(_servicoAtual))
      _servicosSelecionados.add(servicoSelecionado);
      
      _trasnformaListaServicoSelecionadoEmChip();
    });
  }

  List<Widget> _buildForm() {
    final estadoLabel = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
      child: Text(
        'Selecione seu estado:',
        style: TextStyle(color: Colors.grey),
      ),
    );
//  Text('Insira o estado que você mora:');

    final estados = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          new DropdownButton(
              value: _estadoAtual,
              items: getDropDownMenuItem(),
              onChanged: changeDropDownItens),

        ],
      ),
//    ,new DropdownButton(
//          value: _estadoAtual,
//          items: getDropDownMenuItem(),
//          onChanged: changeDropDownItens),
    );

    final cidadeLabel = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, .0),
      child: Text(
        'Cidades que você atua:',
        style: TextStyle(color: Colors.grey),
      ),
    );

    final cidades = Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        child: Row(children: <Widget>[
          new DropdownButton(
              value: _cidadeAtual,
              items: getDropDownMenuItemCidades(),
              onChanged: _changeDropDownItensCidades),
        ]));
	final servicos = Padding(
	    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        child: Row(children: <Widget>[
          new DropdownButton(
              value: _servicoAtual,
              items: getDropDownMenuItemServicos(),
              onChanged: _changeDropDownItensServicos),
        ])
	);
    final listChip = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(children: _chipList));

    final areasDeAtuacaoLabel = Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Text(
        'Areas de atuação:',
        style: TextStyle(color: Colors.grey),
      ),
    );
	
	final listChipServico =Padding(
		padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(children: _chipListServicos)
	);

	final buttonNext = Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: RaisedButton(
        padding: EdgeInsets.fromLTRB(.0, 8.0, .0, 8.0),
        onPressed: (){
          Navigator.of(context).push(
           MaterialPageRoute(builder: (BuildContext context) => ProfesionalRegisterPaymentScreen())
          );
        },
      color: Colors.red[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '[2/3] Próximo Passo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.directions_run, color: Colors.white,),
            ),
          ],
        ),
    ),
  );
//	final proximaTela
    final form = Form(
        child: ListView(
      children: <Widget>[
        estadoLabel,
        estados,
        Divider(),
        cidadeLabel,
        cidades,
        listChip,
        Divider(),
        areasDeAtuacaoLabel,
		    servicos,
		    listChipServico,
        Divider(),
        buttonNext,
      ],
    ));
    var list = new List<Widget>();
    list.add(form);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Atuação',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red[400]),
        ),
        body: new Stack(
//          alignment: AlignmentDirectional(16.0, 16.0),
          children: _buildForm(),
        ));
  }
}

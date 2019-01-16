import 'package:autonos_app/model/Service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:autonos_app/firebase/FirebaseServicesHelper.dart';

/// Apesar do nome essa classe é utilizada como bloc para o CHipPanelWidget
/// para efeturar a cargados serviços pretados pelo usuário & auxiliar
/// na renderização do PerfilDetailsScreen.
class PerfilDetailsScreenBloc {
  final _servicesFetcher = PublishSubject< List<Service> >();

  ///obtem a stream com a lista de servicos do usuario
  Observable< List<Service> > get userServices => _servicesFetcher.stream;
  List<Service> currentList;

  PerfilDetailsScreenBloc(List<String> servicesId){
    var localList = List<Service>();

    for(String id in servicesId){
      FirebaseServicesHelper.getServiceById(id).listen((event){
        localList.add(Service.fromSnapshot( event.snapshot));
        _addToSink( localList );
      });

    }
  }

  void dispose(){ _servicesFetcher.close(); }

  void _addToSink(List<Service> list){
    //print("Bloc::_addToSink  ${s.name}");
    _servicesFetcher.sink.add(list);
    currentList = list;
  }
}
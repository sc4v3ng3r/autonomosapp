import 'package:rxdart/rxdart.dart';
import 'package:autonos_app/firebase/FirebaseServicesHelper.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';

class ServiceBlock {

  final _servicesFetcher = PublishSubject< List<String> >();

  Observable<List<String>> get allServices => _servicesFetcher.stream;

  getServices() {
    FirebaseServicesHelper.getServicesByArea(
        FirebaseReferences.REFERENCE_GERAL, _addDataToSink);
  }

  dispose(){
    _servicesFetcher.close();
  }

  _addDataToSink(List<String> data){
    _servicesFetcher.sink.add( data);
  }
}

//final bloc = ServiceBlock();
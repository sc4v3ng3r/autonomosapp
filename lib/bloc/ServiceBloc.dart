import 'package:rxdart/rxdart.dart';
import 'package:autonos_app/firebase/FirebaseServicesHelper.dart';
import 'package:autonos_app/firebase/FirebaseReferences.dart';

class ServiceBlock {
  //final _repository = FirebaseServicesHelper();
  final _servicesFetcher = PublishSubject< List<String> >();

  Observable<List<String>> get allServices => _servicesFetcher.stream;

  getServices() async {
    List<String> data = await FirebaseServicesHelper.getServicesByArea(FirebaseReferences.REFERENCE_GERAL);

    _servicesFetcher.sink.add(data);
  }

  dispose(){
    _servicesFetcher.close();
  }

}

//final bloc = ServiceBlock();
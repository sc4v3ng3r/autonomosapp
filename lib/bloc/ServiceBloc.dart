import 'package:autonos_app/model/Service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:autonos_app/firebase/FirebaseServicesHelper.dart';

class ServiceBlock {
  // input Stream "StreamController and his Sink"
  final _servicesFetcher = PublishSubject< List<Service> > ();

  Observable<List<Service> > get allServices => _servicesFetcher.stream;

  getServices() {
    FirebaseServicesHelper.getAllServices(_addDataToSink);
  }

  dispose(){
    _servicesFetcher.close();
  }

  _addDataToSink(List<Service> data){
    data.sort((a, b) =>  (a.name.compareTo( b.name))  );
    _servicesFetcher.sink.add( data);
  }

}

//final bloc = ServiceBlock();
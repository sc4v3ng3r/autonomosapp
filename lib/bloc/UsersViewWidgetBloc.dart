import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserViewsHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:rxdart/rxdart.dart';

class UsersViewWidgetBloc {

  PublishSubject<UserView> _networkUserViewInput = PublishSubject();
  Observable<UserView> get _networkUserViewStream => _networkUserViewInput.stream;

  ReplaySubject< List< Map<UserView, User> > > _dataUiPublish = ReplaySubject(maxSize: 50);
  Observable< List<Map<UserView, User>> > get dataUiStream => _dataUiPublish.stream;

  final String _currentUid = UserRepository.instance.currentUser.uid;
  List<Map<UserView, User>> _dataList = List();

  UsersViewWidgetBloc(){

    // escutamos a chegada de Views
    _networkUserViewStream.listen( _onUserViewData );

    FirebaseUserViewsHelper.getUserVisualizations(uid: _currentUid)
        .then( (dataSnapshot){
      print("${dataSnapshot.value}");

      if (dataSnapshot.value != null){
        // ha views ńeste usuário
        Map<dynamic, dynamic> viewsMap = Map.from( dataSnapshot.value);
        viewsMap.forEach(  (key, value) {

          Map<String,dynamic> viewJson = Map.from(  value );
          UserView userView = UserView.fromJson( viewJson );
          userView.id = key;
          _addUserViewsToSink( userView );

        } );
      }

      else {
        //nao ha views para o usuario, forçamos o envio de uma lista vazia para UI.
        _addUiDataToSink(null);
      }


    } ).catchError( (error){
        print("UsersViewWidgetBloc::Constructor $error");
        _addUiDataToSink(null);
    } );
  }

  void _onUserViewData( UserView view ){
    if (view != null){
      FirebaseUserHelper.readUserNode(uid: view.userVisitorId)
          .then( (userSnapshot){

        //caso usuario ainda exista no DB
        if (userSnapshot.value != null){
          User user = User.fromDataSnapshot( userSnapshot );
          var data = Map<UserView, User>();
          data.putIfAbsent( view, () => user);
          _addUiDataToSink( data );
        }

        else {
          // caso nao exista mais, mostramos usuario inexistente e removemos
          // tal registro de visualização
          var data = Map<UserView, User>();
          data.putIfAbsent( view, () => null);
          _addUiDataToSink( data );

          FirebaseUserViewsHelper.removeUserView(
              uid: UserRepository.instance.currentUser.uid,
              viewId: view.id);
        }

      });
    }
  }

  void _addUiDataToSink( Map<UserView, User> data){
    if (data != null)
      _dataList.add(data);

    _dataUiPublish.sink.add( _dataList );
  }

  void _addUserViewsToSink( UserView view ){
    _networkUserViewInput.sink.add( view );
  }

  void dispose(){
    _dataUiPublish?.close();
    _networkUserViewInput?.close();
  }
}
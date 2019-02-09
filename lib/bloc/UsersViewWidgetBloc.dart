import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserViewsHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/model/UserView.dart';
import 'package:autonomosapp/utility/Constants.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:rxdart/rxdart.dart';

class UsersViewWidgetBloc {

  PublishSubject<UserView> _networkUserViewInput = PublishSubject();
  Observable<UserView> get _networkUserViewStream => _networkUserViewInput.stream;

  ReplaySubject< List< Map<UserView, User> > > _dataUiPublish = ReplaySubject(maxSize: 50);
  Observable< List<Map<UserView, User>> > get dataUiStream => _dataUiPublish.stream;

  final String _currentUid = UserRepository.instance.currentUser.uid;
  List<Map<UserView, User>> _dataList = List();


  ///
  /// OBJETIVOS DESSE BLOC
  /// 1) Entregar uma lista com pelo menos 1 item caso existam views
  /// 2) entregar uma lista vazia caso não existamviews
  /// 3) entregar null em erros ou timeouts exceptions

  UsersViewWidgetBloc(){

    /// escutamos a chegada de Views
    _networkUserViewStream.listen( _onUserViewData );

    FirebaseUserViewsHelper.getUserVisualizations(uid: _currentUid)
        .then(
            (dataSnapshot){
              print("${dataSnapshot.value}");

              if (dataSnapshot.value == null)
                _repeatDataList();

              else {
                // ha views neste usuário
                Map<dynamic, dynamic> viewsMap = Map.from( dataSnapshot.value);
                viewsMap.forEach(  (key, value) {
                  Map<String,dynamic> viewJson = Map.from(  value );
                  UserView userView = UserView.fromJson( viewJson );
                  userView.id = key;
                  _addUserViewsToSink( userView );
                });
              }
            }
        ).timeout(Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS),
            onTimeout: (){ _dataUiPublish.sink.add(null); } );
  }

  /// listener de networkUserView stream
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
          /// caso nao exista mais, mostramos usuário inexistente uma única vez e removemos
          /// tais registros de visualização
          var data = Map<UserView, User>();
          data.putIfAbsent( view, () => null);
          _addUiDataToSink( data );

          FirebaseUserViewsHelper.removeUserView(
              uid: UserRepository.instance.currentUser.uid,
              viewId: view.id);
        }

      });
    } else _repeatDataList();
  }

  void _addUiDataToSink( Map<UserView, User> data){
    if (data != null)
      _dataList.add(data);

    _dataUiPublish.sink.add( _dataList );
  }

  void _addUserViewsToSink( UserView view ){
    if (view == null){ //eh pq não ha views
      _dataUiPublish.sink.add( _dataList );// adicionamos uma lista vazia

    } else _networkUserViewInput.sink.add( view );
  }

  void _repeatDataList() => _dataUiPublish.sink.add( _dataList );

  void dispose(){
    _dataUiPublish?.close();
    _networkUserViewInput?.close();
  }
}
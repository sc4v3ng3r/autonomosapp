

import 'package:autonomosapp/firebase/FirebaseFavoritesHelper.dart';
import 'package:autonomosapp/firebase/FirebaseUserHelper.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/utility/UserRepository.dart';
import 'package:rxdart/rxdart.dart';

class FavouritesWidgetBloc {
  final BehaviorSubject< List<User> > _userListSubject = BehaviorSubject();
  Observable<List<User>> get favorites => _userListSubject.stream;

  UserRepository _repository = UserRepository.instance;
  List<User> _favouritesDataList = List();

  FavouritesWidgetBloc(){
    Iterable<String> iterable = _repository.favorites.keys;

    if (iterable.isEmpty)
      _addFavoriteListToSink(_favouritesDataList);

    else {
      for( String uid in  iterable ){
        FirebaseUserHelper.readUserNode(uid: uid)
            .then( (userSnapshot){

          if (userSnapshot.value == null){
            _repository.favorites.remove( uid );
          }

          var user = User.fromDataSnapshot( userSnapshot );
          _addFavouriteUserToList(user);

        }).catchError( (error){
          print("FavouritesWidgetBloc ${error.toString()}");
          _addFavoriteListToSink(null);
        } );

      }
    }
  }

  void _addFavouriteUserToList(User user){
    _favouritesDataList.add(user);
    _addFavoriteListToSink( _favouritesDataList );
  }

  void _addFavoriteListToSink(List<User> favoriteList){
    _userListSubject.sink.add( favoriteList );
  }

  void removeFavouriteUser(String uid, User favouriteUser){
    FirebaseFavouritesHelper.removeFavoriteUser(
        uid: uid,
        favouriteUid: favouriteUser.uid
    );
    _repository.favorites.remove(favouriteUser.uid);
    _favouritesDataList.remove(favouriteUser);
    _addFavoriteListToSink(_favouritesDataList);
  }

  void dispose(){
    _userListSubject?.close();
  }

}
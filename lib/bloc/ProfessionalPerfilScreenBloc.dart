import 'package:autonomosapp/firebase/FirebaseProfessionalRatingHelper.dart';
import 'package:autonomosapp/model/ProfessionalRating.dart';
import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/firebase/FirebaseFavoritesHelper.dart';
import 'package:autonomosapp/utility/UserRepository.dart';


class ProfessionalPerfilScreenBloc {
  Map<String, String> _userFavorites = UserRepository.instance.favorites;

  void addToFavorite(String uid, User professional){
    FirebaseFavouritesHelper.favoriteProfessional(uid: uid,
        professionalUid: professional.uid);
    _userFavorites.putIfAbsent(professional.uid, ()=> professional.uid);
  }

  void removeFromFavorites(String uid, User professional){
    FirebaseFavouritesHelper.unFavouriteProfessional(
        uid: uid, professionalUid: professional.uid);
    _userFavorites.remove(professional.uid);
  }

  bool isFavorite(User professional){
    return _userFavorites.containsKey(professional.uid);
  }

  void rateProfessional(final ProfessionalRating rating) =>
    FirebaseProfessionalRatingHelper.ratingProfessional(proRating: rating);

}

import 'package:shop/model/favoritesModel/FavoritesModel.dart';
import 'package:shop/model/favoritesModel/Favorites_Model.dart';
import 'package:shop/model/shopAppModel/LoginModel.dart';
import 'package:shop/model/shopAppModel/UpdateModel.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopShowState extends ShopStates{}

class ShopLoadingHomeModelState extends ShopStates {}

class ShopSuccessHomeModelState extends ShopStates {}

class ShopErrorHomeModelState extends ShopStates {

  final String? error;
  ShopErrorHomeModelState(this.error);

}

class ShopSuccessCategoriesModelState extends ShopStates {}

class ShopErrorCategoriesModelState extends ShopStates {

  final String? error;
  ShopErrorCategoriesModelState(this.error);

}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessFavoritesModelState extends ShopStates {
  FavoritesModel? favorite;
  ShopSuccessFavoritesModelState(this.favorite);
}

class ShopErrorFavoritesModelState extends ShopStates {

  final String? error;
  ShopErrorFavoritesModelState(this.error);

}

class ShopLoadingGetFavoritesModelState extends ShopStates {}

class ShopSuccessGetFavoritesModelState extends ShopStates {
  Favorites_Model? favor;
  ShopSuccessGetFavoritesModelState(this.favor);
}

class ShopErrorGetFavoritesModelState extends ShopStates {

  final String? error;
  ShopErrorGetFavoritesModelState(this.error);

}


class ShopProfileLoadingState extends ShopStates {}

class ShopProfileSuccessState extends ShopStates {
  final LoginModel login;
  ShopProfileSuccessState(this.login);
}

class ShopProfileErrorState extends ShopStates {
  final String error;
  ShopProfileErrorState(this.error);
}

class ShopUpdateLoadingState extends ShopStates {}

class ShopUpdateSuccessState extends ShopStates {
  final UpdateModel update;
  ShopUpdateSuccessState(this.update);
}

class ShopUpdateErrorState extends ShopStates {
  final String error;
  ShopUpdateErrorState(this.error);
}

class ConnectionCheckState extends ShopStates {}






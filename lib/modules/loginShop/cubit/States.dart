import 'package:shop/model/shopAppModel/LoginModel.dart';

abstract class ShopLoginState {}

class ShopLoginInitialState extends ShopLoginState {}

class ShopLoginLoadingState extends ShopLoginState {}

class ShopLoginSuccessState extends ShopLoginState {

  final LoginModel? lModel;
  ShopLoginSuccessState(this.lModel);

}

class ShopLoginErrorState extends ShopLoginState {
  final String? error;

  ShopLoginErrorState(this.error);
}

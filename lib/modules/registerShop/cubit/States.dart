import 'package:shop/model/shopAppModel/LoginModel.dart';

abstract class ShopRegisterState {}

class ShopRegisterInitialState extends ShopRegisterState {}

class ShopRegisterLoadingState extends ShopRegisterState {}

class ShopRegisterSuccessState extends ShopRegisterState {

  final LoginModel? lModel;
  ShopRegisterSuccessState(this.lModel);

}

class ShopRegisterErrorState extends ShopRegisterState {
  final String? error;

  ShopRegisterErrorState(this.error);
}

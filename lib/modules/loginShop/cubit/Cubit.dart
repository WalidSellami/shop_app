import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/model/shopAppModel/LoginModel.dart';
import 'package:shop/modules/loginShop/cubit/States.dart';
import 'package:shop/shared/network/EndPoint.dart';
import 'package:shop/shared/network/remot/DioHelper.dart';

class ShopLoginCubit extends Cubit<ShopLoginState>{

  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  LoginModel? login;

  void userLogin({
    required String email,
    required String password,
}){
    emit(ShopLoginLoadingState());
    DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password': password,
        },
    ).then((value){
      if (kDebugMode) {
        print(value?.data);
      }
      login = LoginModel.fromJson(value?.data);
      emit(ShopLoginSuccessState(login));
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopLoginErrorState(error));
    });
  }

}
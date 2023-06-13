import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/model/shopAppModel/LoginModel.dart';
import 'package:shop/modules/registerShop/cubit/States.dart';
import 'package:shop/shared/network/EndPoint.dart';
import 'package:shop/shared/network/remot/DioHelper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterState>{

  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? register;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }){
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'name' : name,
        'email': email,
        'password': password,
        'phone' : phone,
      },
    ).then((value){
      if (kDebugMode) {
        print(value?.data);
      }
      register = LoginModel.fromJson(value?.data);
      emit(ShopRegisterSuccessState(register));
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopRegisterErrorState(error));
    });
  }

}
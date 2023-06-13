import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/splashScreen/cubit/States.dart';
class SplashCubit extends Cubit<SplashStates>{

  SplashCubit() : super(InitialSplashState());

  static SplashCubit get(context) => BlocProvider.of(context);

  // bool hasInternet = false;
  // void checkConnection(){
  //   InternetConnectionChecker().onStatusChange.listen((status) {
  //     hasInternet = status == InternetConnectionStatus.connected;
  //     hasInternet = hasInternet;
  //   });
  //   emit(SplashCheckConnectionState());
  // }

  void navigate(context , Widget screen){
    // if(hasInternet){
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => screen),
                (route) => false);
      });
    // }else{
    //   showToast(message: 'No Internet Connection', state: ToastStates.error);
    //   Future.delayed(const Duration(seconds: 3)).then((value) {
    //     SystemNavigator.pop();
    //   });
    // }
    emit(SplashNavigateState());
  }


}
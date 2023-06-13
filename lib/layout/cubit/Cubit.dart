import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shop/layout/cubit/States.dart';

class CheckCubit extends Cubit<CheckStates>{

  CheckCubit() : super(InitialCheckState());

  static CheckCubit get(context) => BlocProvider.of(context);

  bool hasInternet = false;

  void checkConnection(){
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      this.hasInternet = hasInternet;
      hasInternet ? showSimpleNotification(
        const Text(
          'You are connected with internet',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
        background: Colors.teal,
      ) : showSimpleNotification(
        const Text(
          'You are not connected with internet',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
        background: Colors.red,
      );
      emit(CheckConnectionState());
    });
  }

}
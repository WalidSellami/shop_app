import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/States.dart';
import 'package:shop/shared/network/local/CacheHelper.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeMode({bool? fromShared}){
    if(fromShared != null){
      isDark = fromShared;
    }else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark)?.then((value) {
        emit(ChangeModeAppState());
      });
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/layout/shopAppLayout/ShopLayout.dart';
import 'package:shop/layout/shopAppLayout/cubit/Cubit.dart';
import 'package:shop/modules/LoginShop/LoginScreen.dart';
import 'package:shop/modules/pageViewShop/PageView.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/States.dart';
import 'package:shop/modules/splashScreen/SplashScreen.dart';
import 'package:shop/shared/components/Constants.dart';
import 'package:shop/shared/network/local/CacheHelper.dart';
import 'package:shop/shared/network/remot/DioHelper.dart';
import 'package:shop/shared/styles/Styles.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key:'onBoarding');
  Widget? widget;
  token = CacheHelper.getData(key: 'token');

  if(onBoarding != null){
    if(token != null) {
      widget = const ShopLayout();
    }else{
      widget = LoginScreen();
    }
  }else{
    widget = PageViewScreen();
  }


  runApp(MyApp(startWidget: widget, isDark: isDark,));
}

class MyApp extends StatelessWidget {

  final Widget? startWidget;
  final bool? isDark;
  const MyApp({super.key, this.startWidget , this.isDark});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavorite()..getProfile()),
        BlocProvider(create: (BuildContext context) => CheckCubit()..checkConnection()),
        BlocProvider(create: (BuildContext context) => AppCubit()..changeMode(fromShared: isDark ?? false)),
      ],
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context , state){},
        builder: (context , state) {
          return OverlaySupport.global(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter App',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
              home: SplashScreen(startWidget),
            ),
          );
        },
      ),
    );
  }
}

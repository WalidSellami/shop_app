import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/modules/splashScreen/cubit/Cubit.dart';
import 'package:shop/modules/splashScreen/cubit/States.dart';

class SplashScreen extends StatefulWidget {

  final Widget? widget;
  const SplashScreen(this.widget, {super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this , duration: const Duration(milliseconds: 500));
    animationController.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SplashCubit()..navigate(context, widget.widget!),
      child: BlocConsumer<SplashCubit , SplashStates>(
        listener: (context , state){},
        builder: (context , state){
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppCubit.get(context).isDark ? Colors.grey.shade900.withOpacity(.5) : Colors.white,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context , widget) => Transform.scale(
                        scale: animationController.value,
                        child: Opacity(
                          opacity: animationController.value,
                          child: Image.asset('images/cart.png',
                            width: 150.0,
                            height: 150.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SpinKitThreeBounce(
                  color: Colors.blue.shade700,
                  size: 35.0,
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          );

        },
      ),
    );
  }
}

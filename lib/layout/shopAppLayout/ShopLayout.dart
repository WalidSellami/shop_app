import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/layout/shopAppLayout/cubit/Cubit.dart';
import 'package:shop/layout/shopAppLayout/cubit/States.dart';
import 'package:shop/modules/searchShop/SearchScreen.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/States.dart';

class ShopLayout extends StatelessWidget {


  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state){},
      builder: (context , state){
        return BlocConsumer<ShopCubit , ShopStates>(
          listener: (context , state) {},
          builder: (context , state){
            var cubit = ShopCubit.get(context);
            return WillPopScope(
              onWillPop: () async {

                final difference = DateTime.now().difference(timeBackPressed);
                final isExitWarning = difference >= const Duration(seconds: 1);
                timeBackPressed = DateTime.now();

                if(isExitWarning){

                  const message = 'Press back again to exit';
                  Fluttertoast.showToast(
                    msg: message ,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.grey.shade200,
                    textColor: Colors.grey.shade900,
                    fontSize: 17.0,
                  );
                  return false;

                }else{

                  Fluttertoast.cancel();
                  SystemNavigator.pop();
                  return true;
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppCubit.get(context).isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                          },
                          icon: const Icon(
                            Icons.search,
                            // color: Colors.black,
                            size: 28.0,
                          ),
                          tooltip: 'Search',
                        ),
                      ),
                    ),
                  ],
                ),
                body: cubit.screens[cubit.currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  items: cubit.item,
                  currentIndex: cubit.currentIndex,
                  onTap: (index){
                    cubit.changeBottom(index);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

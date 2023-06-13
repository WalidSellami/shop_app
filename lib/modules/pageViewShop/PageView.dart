import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/model/pageModel/PageModel.dart';
import 'package:shop/modules/LoginShop/LoginScreen.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/States.dart';
import 'package:shop/shared/components/Components.dart';
import 'package:shop/shared/network/local/CacheHelper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewScreen extends StatefulWidget {
  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  List<PageModel> list = [
    PageModel(
      image: 'images/image1.jpg',
      title: 'Easy To Use',
      semiTitle: 'SemiTitle Screen 1',
    ),
    PageModel(
      image: 'images/image2.png',
      title: 'Best Offers',
      semiTitle: 'SemiTitle Screen 2',
    ),
    PageModel(
      image: 'images/image3.png',
      title: 'Dark Mode',
      semiTitle: 'SemiTitle Screen 3',
    ),
  ];

  var controller = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true)?.then((value) {
      if (value ?? true) {
        navigatorToNotBack(context: context, screen: LoginScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state){},
      builder: (context , state){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppCubit.get(context).isDark ? Colors.grey.shade900.withOpacity(.5) : Colors.white,
            elevation: 0,
            actions: [
              defaultTextButton(
                function: () {
                  submit();
                },
                text: 'skip',
                context: context,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (index) {
                      if (index == list.length - 1) {
                        setState(() {
                          isLast = true;
                        });
                      } else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                    itemBuilder: (context, index) => buildPageItem(list[index]),
                    itemCount: list.length,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    SmoothPageIndicator(
                        controller: controller,
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: AppCubit.get(context).isDark ? HexColor('35c2c2') : Colors.blue.shade700,
                          dotWidth: 10,
                          spacing: 5.0,
                          expansionFactor: 4.0,
                          dotHeight: 10,
                        ),
                        count: list.length),
                    const Spacer(),
                    FloatingActionButton(
                      onPressed: () {
                        if (isLast) {
                          submit();
                        } else {
                          controller.nextPage(
                              duration: const Duration(
                                milliseconds: 800,
                              ),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );

      },
    );
  }
}

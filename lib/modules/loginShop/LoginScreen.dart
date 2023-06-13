import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/layout/cubit/States.dart';
import 'package:shop/layout/shopAppLayout/ShopLayout.dart';
import 'package:shop/modules/loginShop/cubit/Cubit.dart';
import 'package:shop/modules/loginShop/cubit/States.dart';
import 'package:shop/modules/registerShop/RegisterScreen.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/shared/components/Components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:shop/shared/components/Constants.dart';
import 'package:shop/shared/network/local/CacheHelper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state){},
      builder: (context , state){
        return BlocProvider(
          create: (BuildContext context) => ShopLoginCubit(),
          child: BlocConsumer<ShopLoginCubit, ShopLoginState>(
            listener: (context, state) {
              if(state is ShopLoginSuccessState){
                if((state.lModel?.status) == true){

                  showToast(message: '${state.lModel?.message}', state: ToastStates.success);
                  // navigatorTo(context: context, screen: ShopLayout());
                  CacheHelper.saveData(key: 'token', value: state.lModel?.data?.token)?.then((value){

                    token = state.lModel?.data?.token;
                    navigatorToNotBack(context: context, screen: ShopLayout());
                  });

                }else{

                  showToast(message: '${state.lModel?.message}', state: ToastStates.error);
                }
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppCubit.get(context).isDark ? Colors.grey.shade900.withOpacity(.5) : Colors.white,
                  elevation: 0,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'login'.toUpperCase(),
                              style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                fontSize: 38.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 18.0,
                            ),
                            const Text(
                              'Login now to browse our hot offers',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 19.5,
                              ),
                            ),
                            const SizedBox(
                              height: 35.0,
                            ),
                            defaultTextFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                text: 'Email Address',
                                prefix: Icons.email_outlined,
                                validate: (String? value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'Email Address must not be empty';
                                  } else {
                                    return null;
                                  }
                                }),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultTextFormField(
                                controller: passwordController,
                                text: 'Password',
                                type: TextInputType.visiblePassword,
                                isPassword: isPassword,
                                prefix: Icons.lock_outline,
                                suffix: isPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                suffixPress: () {
                                  setState(() {
                                    isPassword = !isPassword;
                                  });
                                },
                                onSubmit: (value){
                                  if (formKey.currentState!.validate()) {
                                     ShopLoginCubit.get(context).userLogin(
                                     email: emailController.text,
                                     password: passwordController.text);

                                    }
                                  return null;
                                },
                                validate: (String? value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'Password must not be empty';
                                  } else {
                                    return null;
                                  }
                                }),
                            const SizedBox(
                              height: 25.0,
                            ),
                            ConditionalBuilder(
                              condition: state is! ShopLoginLoadingState,
                              builder: (context) => defaultButton(
                                context: context,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    if (CheckCubit.get(context).hasInternet) {
                                    ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);

                                    }else{
                                      showToast(message: 'No Internet Connection', state: ToastStates.error);
                                    }
                                  }
                                },
                                text: 'Login',
                                colorText: Colors.white,
                              ),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator(color: AppCubit.get(context).isDark? HexColor('198989') : Colors.blue.shade700,)),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                defaultTextButton(function: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                                }, text: 'register', context: context),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );

      },
    );
  }
}

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/layout/cubit/States.dart';
import 'package:shop/layout/shopAppLayout/ShopLayout.dart';
import 'package:shop/modules/registerShop/cubit/Cubit.dart';
import 'package:shop/modules/registerShop/cubit/States.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/shared/components/Components.dart';
import 'package:shop/shared/network/local/CacheHelper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();


  var formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state){},
      builder: (context , state){
        return BlocProvider(
          create: (BuildContext context) => ShopRegisterCubit(),
          child: BlocConsumer<ShopRegisterCubit, ShopRegisterState>(
            listener: (context, state) {
              if(state is ShopRegisterSuccessState){
                if((state.lModel?.status) == true){

                  CacheHelper.saveData(key: 'token', value: state.lModel?.data?.token)?.then((value){
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
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                    ),
                    tooltip: 'Back',
                  ),
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
                              'register'.toUpperCase(),
                              style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 37.0,
                                color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 18.0,
                            ),
                            const Text(
                              'Register now to browse our hot offers',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 19.5,
                              ),
                            ),
                            const SizedBox(
                              height: 35.0,
                            ),
                            defaultTextFormField(
                                controller: nameController,
                                type: TextInputType.name,
                                text: 'User Name',
                                prefix: Icons.person,
                                validate: (String? value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'User Name must not be empty';
                                  } else {
                                    return null;
                                  }
                                }),
                            const SizedBox(
                              height: 15.0,
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
                                     ShopRegisterCubit.get(context).userRegister(
                                       name: nameController.text,
                                       email: emailController.text,
                                       password: passwordController.text,
                                       phone: phoneController.text,
                                     );
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
                              height: 20.0,
                            ),
                            defaultTextFormField(
                                controller: phoneController,
                                type: TextInputType.emailAddress,
                                text: 'Phone Number',
                                prefix: Icons.phone,
                                validate: (String? value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'Phone number must not be empty';
                                  } else {
                                    return null;
                                  }
                                }),
                            const SizedBox(
                              height: 25.0,
                            ),
                            ConditionalBuilder(
                              condition: state is! ShopRegisterLoadingState,
                              builder: (context) => defaultButton(
                                context: context,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    if (CheckCubit.get(context).hasInternet) {
                                      ShopRegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text,
                                      );

                                    }else{
                                      showToast(message: 'No Internet Connection', state: ToastStates.error);
                                    }
                                  }
                                },
                                text: 'register',
                                colorText: Colors.white,
                              ),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator(color: AppCubit.get(context).isDark? HexColor('198989') : Colors.blue.shade700,)),

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

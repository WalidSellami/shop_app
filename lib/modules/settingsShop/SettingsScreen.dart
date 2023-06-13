import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/layout/cubit/States.dart';
import 'package:shop/layout/shopAppLayout/cubit/Cubit.dart';
import 'package:shop/layout/shopAppLayout/cubit/States.dart';
import 'package:shop/modules/editProfile/EditProfile.dart';
import 'package:shop/modules/loginShop/LoginScreen.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/States.dart';
import 'package:shop/shared/components/Components.dart';
import 'package:shop/shared/network/local/CacheHelper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state){},
      builder: (context , state){
        return BlocConsumer<CheckCubit , CheckStates>(
          listener: (context , state){},
          builder: (context , state){
            return BlocConsumer<ShopCubit, ShopStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return CheckCubit.get(context).hasInternet ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(70.0),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              '${ShopCubit.get(context).userData?.data?.image}',
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 14.0,
                      ),
                      Text(
                        '${ShopCubit.get(context).userData?.data?.name}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 14.0,
                      ),
                      Text(
                        '${ShopCubit.get(context).userData?.data?.email}',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Expanded(
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 19.0,
                                backgroundColor: AppCubit.get(context).isDark
                                    ? HexColor('198989')
                                    : Colors.blue.shade700,
                                child: const Icon(
                                  Icons.dark_mode,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.black,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(25.5),
                                ),
                                child: CircleAvatar(
                                  radius: 23.5,
                                  backgroundColor: AppCubit.get(context).isDark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade200,
                                  child: IconButton(
                                    onPressed: () {
                                      AppCubit.get(context).changeMode();
                                    },
                                    icon: AppCubit.get(context).isDark
                                        ? Icon(
                                      Icons.light_mode,
                                      color: AppCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                        : Icon(
                                      Icons.dark_mode,
                                      color: AppCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    tooltip: 'Change Mode',
                                  ),
                                ),
                              ),
                              onTap: (){
                                AppCubit.get(context).changeMode();
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 19.0,
                                backgroundColor: AppCubit.get(context).isDark
                                    ? HexColor('198989')
                                    : Colors.blue.shade700,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: AppCubit.get(context).isDark ? Colors.grey.shade200 : Colors.grey.shade700,
                                size: 20.0,
                              ),
                              onTap: () {
                                navigatorTo(context: context, screen: EditProfile());
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 19.0,
                                backgroundColor: AppCubit.get(context).isDark
                                    ? HexColor('198989')
                                    : Colors.blue.shade700,
                                child: const Icon(
                                  Icons.logout_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                'Log out',
                                style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppCubit.get(context).isDark
                                      ? HexColor('35c2c2')
                                      : Colors.blue.shade700,
                                ),
                              ),
                              onTap: () {
                                CacheHelper.removeData(key: 'token')?.then((value) {
                                  if (value == true) {
                                    navigatorToNotBack(
                                        context: context, screen: LoginScreen());
                                  }
                                });
                                ShopCubit.get(context).currentIndex = 0;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :  const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Internet',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.signal_wifi_connected_no_internet_4_outlined)
                    ],
                  ),
                );
                //   ConditionalBuilder(
                //   condition: ShopCubit.get(context).userData != null,
                //   builder: (context) => Padding(
                //     padding: const EdgeInsets.all(12.0),
                //     child: SingleChildScrollView(
                //       child: Form(
                //         key: formKey,
                //         child: Column(
                //           children: [
                //             if (state is ShopUpdateLoadingState)
                //                LinearProgressIndicator(color: Colors.blue.shade700,),
                //             const SizedBox(
                //               height: 20.0,
                //             ),
                //             defaultTextFormField(
                //                 controller: nameController,
                //                 type: TextInputType.name,
                //                 text: 'User Name',
                //                 prefix: Icons.person,
                //                 validate: (String? value) {
                //                   if ((value ?? '').isEmpty) {
                //                     return 'User Name must not be empty';
                //                   } else {
                //                     return null;
                //                   }
                //                 }),
                //             const SizedBox(
                //               height: 15.0,
                //             ),
                //             defaultTextFormField(
                //                 controller: emailController,
                //                 type: TextInputType.emailAddress,
                //                 text: 'Email Address',
                //                 prefix: Icons.email_outlined,
                //                 validate: (String? value) {
                //                   if ((value ?? '').isEmpty) {
                //                     return 'Email Address must not be empty';
                //                   } else {
                //                     return null;
                //                   }
                //                 }),
                //             const SizedBox(
                //               height: 15.0,
                //             ),
                //             defaultTextFormField(
                //                 controller: phoneController,
                //                 type: TextInputType.emailAddress,
                //                 text: 'Phone Number',
                //                 prefix: Icons.phone,
                //                 validate: (String? value) {
                //                   if ((value ?? '').isEmpty) {
                //                     return 'Phone number must not be empty';
                //                   } else {
                //                     return null;
                //                   }
                //                 }),
                //             const SizedBox(
                //               height: 20.0,
                //             ),
                //             defaultButton(
                //               function: () {
                //                 if (formKey.currentState!.validate()) {
                //                   ShopCubit.get(context).updateProfile(
                //                       name: nameController.text,
                //                       email: emailController.text,
                //                       phone: phoneController.text);
                //                 }
                //               },
                //               text: 'Update',
                //               colorText: Colors.white,
                //             ),
                //             const SizedBox(
                //               height: 15.0,
                //             ),
                //             defaultButton(
                //               function: () {
                //                 CacheHelper.removeData(key: 'token')?.then((value) {
                //                   if (value ?? true) {
                //                     navigatorToNotBack(
                //                         context: context, screen: LoginScreen());
                //                   }
                //                 });
                //                 ShopCubit.get(context).currentIndex = 0;
                //               },
                //               text: 'Log out',
                //               colorText: Colors.white,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                //   fallback: (context) =>
                //        Center(child: CircularProgressIndicator(color: Colors.blue.shade700,)),
                // );
              },
            );
          },
        );
      },
    );
  }
}

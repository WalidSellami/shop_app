import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/layout/shopAppLayout/cubit/Cubit.dart';
import 'package:shop/layout/shopAppLayout/cubit/States.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/shared/components/Components.dart';


class EditProfile extends StatefulWidget {

  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var emailController = TextEditingController();

  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
      if (state is ShopUpdateSuccessState) {
        if (state.update.status == true) {
          ShopCubit.get(context).getProfile();
          showToast(
              message: (state.update.message).toString(),
              state: ToastStates.success);
        } else {
          showToast(
              message: (state.update.message).toString(),
              state: ToastStates.error);
        }
      }
    }, builder: (context, state) {
      nameController.text =
          (ShopCubit.get(context).userData?.data?.name).toString();
      emailController.text =
          (ShopCubit.get(context).userData?.data?.email).toString();
      phoneController.text =
          (ShopCubit.get(context).userData?.data?.phone).toString();

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                    ),
                    tooltip: 'Back',
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ConditionalBuilder(
                condition: ShopCubit.get(context).userData != null,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          if (state is ShopUpdateLoadingState)
                            LinearProgressIndicator(
                              color: AppCubit.get(context).isDark ? HexColor('198989') :  Colors.blue.shade700,
                            ),
                          const SizedBox(
                            height: 20.0,
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
                            height: 25.0,
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
                            height: 25.0,
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
                          defaultButton(
                            context: context,
                            function: () {
                              if (formKey.currentState!.validate()) {
                                ShopCubit.get(context).updateProfile(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text);
                              }
                            },
                            text: 'Update',
                            colorText: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                fallback: (context) => Center(
                    child: CircularProgressIndicator(
                  color: AppCubit.get(context).isDark ? HexColor('198989') : Colors.blue.shade700,
                )),
              ),
            ],
          ),
        ),
      );
    });
  }
}

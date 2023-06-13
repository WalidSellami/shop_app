import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/model/pageModel/PageModel.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';

Widget buildPageItem(PageModel model) => Column(
      children: [
        Expanded(
            flex: 3,
            child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0,),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset('${model.image}')))),
        const SizedBox(
          height: 30.0,
        ),
        Expanded(
          child: Text(
            '${model.title}',
            style: const TextStyle(
              fontSize: 27.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // const SizedBox(
        //   height: 20.0,
        // ),
        // Text(
        //   '${model.semiTitle}',
        //   style: TextStyle(
        //     fontSize: 18.0,
        //     color: Colors.grey.shade700,
        //   ),
        // ),
      ],
    );

Future navigatorTo({required BuildContext context, required Widget screen}) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

Future navigatorToNotBack(
        {required BuildContext context, required Widget screen}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );

Widget defaultTextButton({
  required Function function,
  required String text,
  required BuildContext context,
}) =>
    TextButton(
      onPressed: () {
        function();
      },
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.5,
          color: AppCubit.get(context).isDark
              ? HexColor('35c2c2')
              : Colors.blue.shade700,
        ),
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required String text,
  required TextInputType? type,
  required IconData prefix,
  String? Function(String?)? onSubmit,
  IconData? suffix,
  bool isPassword = false,
  required String? Function(String?)? validate,
  Function? suffixPress,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      onFieldSubmitted: (value) {
        onSubmit!(value);
      },
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? ((controller.text.isNotEmpty)
                ? IconButton(
                    onPressed: () {
                      suffixPress!();
                    },
                    icon: Icon(suffix))
                : null)
            : null,
      ),
      validator: validate,
    );

Widget defaultButton({
  double width = double.infinity,
  double height = 48.0,
  required Function function,
  required String text,
  Color? colorText,
  required BuildContext context,
}) =>
    SizedBox(
      width: width,
      child: MaterialButton(
        height: height,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {
          function();
        },
        color:
            AppCubit.get(context).isDark ? HexColor('198989') : Colors.blue.shade700,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
              color: colorText, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

void showToast({
  required String message,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(s: state),
      textColor: Colors.white,
      fontSize: 17.0,
    );

enum ToastStates { success, error, warning }

Color chooseToastColor({
  required ToastStates s,
}) {
  Color? color;
  switch (s) {
    case ToastStates.success:
      color = Colors.teal;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

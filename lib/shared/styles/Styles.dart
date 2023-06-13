
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme =  ThemeData(
  fontFamily: 'VarelaRound',
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.blue.shade700,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontFamily: 'VarelaRound',
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 25.0,
    backgroundColor: Colors.white,
    selectedItemColor: Colors.blue.shade700,
    unselectedItemColor: Colors.grey.shade500,
    selectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14.0,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue.shade700,
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'VarelaRound',
  scaffoldBackgroundColor: Colors.grey.shade800.withOpacity(.5),
  primarySwatch: Colors.teal,
  colorScheme: ColorScheme.dark(
    primary: HexColor('35c2c2'),
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontFamily: 'VarelaRound',
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: HexColor('141414'),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.grey.shade900.withOpacity(.3),
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 25.0,
    backgroundColor: HexColor('161717'),
    selectedItemColor: HexColor('35c2c2'),
    selectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14.0,
    ),
    unselectedItemColor: Colors.grey,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: HexColor('35c2c2'),
  ),
);
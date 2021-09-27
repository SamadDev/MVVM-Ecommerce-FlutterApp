import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xffdcdede),
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(width: 4, color: SecondaryColorDark),
    gapPadding: 10,
  );

  OutlineInputBorder outlineInputErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(width: 4, color: Color(0xFFFB5354)),
    gapPadding: 10,
  );
  return InputDecorationTheme(
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      // if we are define our floatingLabelBehavior in our theme then it's not applayed
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
      errorStyle: TextStyle(height: 0),
      errorBorder: outlineInputErrorBorder);
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: SecondaryColorDark),
    bodyText2: TextStyle(color: SecondaryColorDark),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ),
  );
}

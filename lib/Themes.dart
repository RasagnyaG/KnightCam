import 'package:flutter/material.dart';

class Themes {
  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(224, 224, 224, 1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 90,
      iconTheme: IconThemeData(color: Colors.black, size: 40),
      titleTextStyle:
          TextStyle(fontFamily: "Lora", fontSize: 30, color: Colors.black),
    ),
    iconTheme: const IconThemeData(size: 30),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontFamily: "Lora", fontSize: 50, fontWeight: FontWeight.w400),
      titleMedium: TextStyle(
          fontFamily: "Lora", fontSize: 40, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(
          fontFamily: "Lora", fontSize: 36, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(
          fontFamily: "Lora", fontSize: 30, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontFamily: "Lora", fontSize: 24, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontFamily: "Lora",
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black),
    ),
  );
}

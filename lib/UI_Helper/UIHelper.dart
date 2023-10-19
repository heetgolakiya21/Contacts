import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyColors {
  static Color greenAccent = const Color(0xFFCCE9E7);
  static Color green = const Color(0xFF006A68);
}

ThemeData themes() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    shadowColor: MyColors.green,
    hoverColor: Colors.deepPurple[300],
    splashFactory: InkRipple.splashFactory,
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
          color: MyColors.green, borderRadius: BorderRadius.circular(20.0)),
      showDuration: const Duration(seconds: 1),
      triggerMode: TooltipTriggerMode.longPress,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: MyColors.greenAccent,
      foregroundColor: Colors.black,
      shadowColor: MyColors.green,
      elevation: 2.0,
      toolbarHeight: 60.0,
      centerTitle: false,
      titleSpacing: 5.0,
      titleTextStyle: const TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        fontFamily: "Manrope",
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.green,
        foregroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        fixedSize: const Size(90.0, 50.0),
        textStyle: const TextStyle(fontSize: 17.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      position: PopupMenuPosition.over,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      shadowColor: MyColors.green,
      elevation: 10.0,
      textStyle:
          const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 25.0,
    ),
    textTheme: const TextTheme(
      titleSmall: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
      ),
    ),
    dividerTheme: const DividerThemeData(
        color: Colors.black, thickness: 0.3, indent: 10.0, endIndent: 10.0),
  );
}

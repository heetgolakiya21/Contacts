import 'package:contact/UI_Helper/UIHelper.dart';
import 'package:contact/Pages/frm_page.dart';
import 'package:contact/Pages/home_page.dart';
import 'package:contact/Pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Contacts",
      debugShowCheckedModeBanner: false,
      theme: themes(),
      themeMode: ThemeMode.light,
      debugShowMaterialGrid: false,
      showPerformanceOverlay: false,
      // home: const SplashPage(),
      initialRoute: "splash_page",
      routes: {
        "splash_page": (context) => const SplashPage(),
        "home_page": (context) => const HomePage(),
        "form_page": (context) => const FormPage(),
      },
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Only use for Android.
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      // Only use for IOS
      statusBarBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setApplicationSwitcherDescription(
    const ApplicationSwitcherDescription(
      label: "Contacts App",
      primaryColor: 1,
    ),
  );
}

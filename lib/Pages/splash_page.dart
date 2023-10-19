import 'package:contact/DB_Helper/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getStoragePermission();
  }

  Future<void> _getStoragePermission() async {
    if ((await Permission.storage.request().isGranted &&
        await Permission.camera.request().isGranted)) {
      DBHelper().getDBDirectory().then(
        (value) async {
          await Navigator.pushReplacementNamed(context, "home_page");
        },
      );
    } else {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("img/logo.jpg", height: 120, width: 120)),
    );
  }
}

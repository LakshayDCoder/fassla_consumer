import 'package:fassla_consumer/screens/bottom_tabs/bottom_tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = "/splash-Screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    checkLoggedIn().then((value) {
      // if(value){
      //   // Logged In
      //   Navigator.popAndPushNamed(context, "");
      // }else{
      //   // Not Logged In
      //   Navigator.popAndPushNamed(context, "");
      // }
      print("Splash Login Value: $value");

      Navigator.popAndPushNamed(context, BottomTabsScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.asset("assets/images/splash_image.jpeg"),
      ),
    );
  }

  Future<bool> checkLoggedIn() async {
    await Future.delayed(Duration(seconds: 2));

    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  }
}

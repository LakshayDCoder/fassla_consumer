import 'package:fassla_consumer/PhoneAuthTry.dart';
import 'package:fassla_consumer/routes.dart';
import 'package:fassla_consumer/screens/splash_screen/splash_screen.dart';
import 'package:fassla_consumer/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fassla',
      theme: theme(),
      // initialRoute: SplashScreen.routeName,
      initialRoute: PhoneAuthForm.routeName,
      routes: routes,
    );
  }
}

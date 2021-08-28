import 'package:fassla_consumer/PhoneAuthTry.dart';
import 'package:fassla_consumer/screens/home_screen/home_screen.dart';
import 'package:fassla_consumer/screens/sign_in/sign_in_screen.dart';
import 'package:fassla_consumer/screens/sign_up/sign_up_screen.dart';
import 'package:fassla_consumer/screens/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (ctx) => SplashScreen(),
  HomeScreen.routeName: (ctx) => HomeScreen(),
  SignInScreen.routeName: (ctx) => SignInScreen(),
  SignUpScreen.routeName: (ctx) => SignUpScreen(),
  PhoneAuthForm.routeName: (ctx) => PhoneAuthForm(),
};

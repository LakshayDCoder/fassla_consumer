import 'package:fassla_consumer/screens/about/about_bet.dart';
import 'package:fassla_consumer/screens/about/about_dev.dart';
import 'package:fassla_consumer/screens/all_products_screen/all_products_screen.dart';
import 'package:fassla_consumer/screens/bottom_tabs/bottom_tabs.dart';
import 'package:fassla_consumer/screens/cart/cart_screen.dart';
import 'package:fassla_consumer/screens/my_orders/my_orders.dart';
import 'package:fassla_consumer/screens/my_profile/my_profile.dart';
import 'package:fassla_consumer/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:fassla_consumer/screens/otp/otp_screen.dart';
import 'package:fassla_consumer/screens/sign_in/sign_in_screen.dart';
import 'package:fassla_consumer/screens/sign_up/sign_up_screen.dart';
import 'package:fassla_consumer/screens/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (ctx) => SplashScreen(),
  OnBoardingScreen.routeName: (ctx) => OnBoardingScreen(),
  BottomTabsScreen.routeName: (ctx) => BottomTabsScreen(),
  AllProductsScreen.routeName: (ctx) => AllProductsScreen(),
  CartScreen.routeName: (ctx) => CartScreen(),
  SignInScreen.routeName: (ctx) => SignInScreen(),
  SignUpScreen.routeName: (ctx) => SignUpScreen(),
  OtpScreen.routeName: (ctx) => OtpScreen(),
  MyProfileScreen.routeName: (ctx) => MyProfileScreen(),
  MyOrders.routeName: (ctx) => MyOrders(),
  AboutBET.routeName: (ctx) => AboutBET(),
  AboutDev.routeName: (ctx) => AboutDev(),
};

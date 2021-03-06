import 'package:fassla_consumer/routes.dart';
import 'package:fassla_consumer/screens/splash_screen/splash_screen.dart';
import 'package:fassla_consumer/states/CartRepository.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:fassla_consumer/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
        ChangeNotifierProvider(create: (_) => CartRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fassla',
        theme: theme(),
        routes: routes,
        initialRoute: SplashScreen.routeName,
        // initialRoute: AboutDev.routeName,
        // initialRoute: MyProfileScreen.routeName,
      ),
    );
  }
}

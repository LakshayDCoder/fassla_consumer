import 'package:fassla_consumer/components/log_out_tile.dart';
import 'package:fassla_consumer/screens/my_profile/my_profile.dart';
import 'package:fassla_consumer/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:fassla_consumer/states/SharedPrefsRepo.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about_bet.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(
      builder: (context, user, child) {
        bool isLoggedIn = false;
        if (user.status == Status.Authenticated) {
          isLoggedIn = true;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...(isLoggedIn ? loggedInTiles(context) : loggedOutTiles(context)),
            ...commonTiles(context),
            Spacer(),
            if (isLoggedIn) LogOutTile(),
          ],
        );
      },
    );
  }

  Widget createTile(String title, IconData icon, Function myOnTap) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () => myOnTap(),
    );
  }

  List<Widget> commonTiles(BuildContext context) => [
        createTile("About Fassla", Icons.info, () {}),
        createTile("About BET", Icons.phone, () {
          Navigator.pushNamed(context, AboutBET.routeName);
        }),
        // createTile("Contact Us", Icons.phone, () {}),
      ];

  List<Widget> loggedInTiles(BuildContext context) => [
        FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              var prefs = snapshot.data!;

              bool isLoggedIn = false;
              if (prefs.getString(sUid) != null) {
                isLoggedIn = true;
              }

              print("Is logged in drawer uid: ${prefs.getString(sUid)}");

              return isLoggedIn
                  ? DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Hello"),
                          Text(prefs.getString(sName) ?? ""),
                          Text(prefs.getString(sEmail) ?? ""),
                          Text(prefs.getString(sMobile) ?? ""),
                        ],
                      ),
                    )
                  : Text("Error");
            }),
        createTile("My Profile", Icons.person, () {
          Navigator.pushNamed(context, MyProfileScreen.routeName);
        }),
        createTile("My Orders", Icons.shopping_basket, () {}),
      ];

  List<Widget> loggedOutTiles(BuildContext context) => [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      OnBoardingScreen.routeName,
                      (Route<dynamic> route) => false);
                },
                child: Text("Login / Sign Up"),
              ),
            ],
          ),
        ),
      ];
}

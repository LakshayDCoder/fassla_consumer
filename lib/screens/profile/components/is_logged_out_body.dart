import 'package:fassla_consumer/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:flutter/material.dart';

class IsLoggedOutBody extends StatelessWidget {
  const IsLoggedOutBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context,
                  OnBoardingScreen.routeName, (Route<dynamic> route) => false);
            },
            child: Text("Login"),
          )
        ],
      ),
    );
  }
}

import 'package:fassla_consumer/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class HaveAccountText extends StatelessWidget {
  const HaveAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        TextButton(
          child: Text(
            "Sign In",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: kPrimaryColor,
            ),
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, SignInScreen.routeName);
          },
        ),
      ],
    );
  }
}

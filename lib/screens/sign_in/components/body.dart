import 'package:fassla_consumer/components/no_account_text.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'sign_in_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(width: double.infinity),
              SizedBox(height: SizeConfig.screenHeight! * 0.2),
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Sign in with mobile number",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.06),
              SignForm(),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              NoAccountText(),
            ],
          ),
        ),
      ),
    );
  }
}

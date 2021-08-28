import 'package:fassla_consumer/components/have_account_text.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'sign_up_form.dart';

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
              SizedBox(height: SizeConfig.screenHeight! * 0.04),
              Text(
                "Register",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Sign up with your email and mobile number.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.08),
              SignForm(),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              HaveAccountText(),
            ],
          ),
        ),
      ),
    );
  }
}

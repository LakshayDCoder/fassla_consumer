import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'otp_form.dart';

class Body extends StatelessWidget {
  final String phoneNumber;

  Body({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight! * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              Text("We sent your code to $phoneNumber"),
              OtpForm(phone: phoneNumber),
            ],
          ),
        ),
      ),
    );
  }
}

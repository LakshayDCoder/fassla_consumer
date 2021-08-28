import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF446940);
const kPrimaryLightColor = Color(0xFF98e890);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF98e890), Color(0xFF446940)],
);
const kSecondaryColor = Color(0xFF000000);
const kTextColor = Color(0xFF000000);

const kAnimationDuration = Duration(milliseconds: 200);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kInvalidPhoneNumberError = "Please Enter a valid phone number";
const String kAddressNullError = "Please Enter your address";

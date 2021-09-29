import 'package:fassla_consumer/screens/bottom_tabs/bottom_tabs.dart';
import 'package:fassla_consumer/screens/sign_up/sign_up_screen.dart';
import 'package:fassla_consumer/size_config.dart';
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

const kErrorColor = Color(0xffa83832);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

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
const String kOtpSendError =
    "Some error occurred while sending OTP. Please check your phone number.";

// Firebase Collection Names
const kProductCollection = "Products";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    // borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

showLoadingDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: CircularProgressIndicator.adaptive(),
    content: Text(
      "Loading. Please wait",
      textAlign: TextAlign.center,
    ),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

closeLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

enum SnackbarTypes { Normal, Success, Fail }

showMySnackbar({
  required BuildContext ctx,
  required String text,
  SnackbarTypes type = SnackbarTypes.Normal,
  Duration duration = const Duration(seconds: 5),
}) {
  SnackBar mySnack = SnackBar(
    duration: duration,
    content: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.7,
      ),
    ),
  );

  if (type == SnackbarTypes.Success) {
    mySnack = SnackBar(
      duration: duration,
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }

  if (type == SnackbarTypes.Fail) {
    mySnack = SnackBar(
      duration: duration,
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
        ),
      ),
      backgroundColor: kErrorColor,
    );
  }

  ScaffoldMessenger.of(ctx).showSnackBar(mySnack);
}

userAuthThenCheckIfUserExists(
    {required bool userExist,
    required BuildContext context,
    required String phone}) {
  if (userExist) {
    // Go to Home Page
    closeLoadingDialog(context);
    showMySnackbar(
      ctx: context,
      text: "User Logged in Successfully",
      type: SnackbarTypes.Success,
    );
    Navigator.pushReplacementNamed(context, BottomTabsScreen.routeName);
  } else {
    // If not go to register
    closeLoadingDialog(context);
    Navigator.pushReplacementNamed(context, SignUpScreen.routeName,
        arguments: phone);
  }
}

ImageProvider customNetworkImage(String imgUrl) {
  return Image.network(
    imgUrl,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator.adaptive(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return Text('Error');
    },
  ).image;
}

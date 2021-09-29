import 'package:fassla_consumer/components/default_button.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OtpForm extends StatefulWidget {
  final String phone;

  const OtpForm({Key? key, required this.phone}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  late FocusNode pin5FocusNode;
  late FocusNode pin6FocusNode;

  TextEditingController _textEditingController1 = new TextEditingController();
  TextEditingController _textEditingController2 = new TextEditingController();
  TextEditingController _textEditingController3 = new TextEditingController();
  TextEditingController _textEditingController4 = new TextEditingController();
  TextEditingController _textEditingController5 = new TextEditingController();
  TextEditingController _textEditingController6 = new TextEditingController();

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentState = Provider.of<UserRepository>(context).status;
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight! * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: _textEditingController1,
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: _textEditingController2,
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin3FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: _textEditingController3,
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin4FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: _textEditingController4,
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin5FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: _textEditingController5,
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin6FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: _textEditingController6,
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin6FocusNode.unfocus();
                      // Check if the code is correct or not
                      var char1 = _textEditingController1.text;
                      var char2 = _textEditingController2.text;
                      var char3 = _textEditingController3.text;
                      var char4 = _textEditingController4.text;
                      var char5 = _textEditingController5.text;
                      var char6 = _textEditingController6.text;

                      var myOTP = char1 + char2 + char3 + char4 + char5 + char6;

                      print("Otp entered: $myOTP");
                      otpSubmitLogic(myOTP, context, currentState);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.15),
          DefaultButton(
            text: "Continue",
            press: () {},
          ),
          Text("Current State: $currentState"),
        ],
      ),
    );
  }

  otpSubmitLogic(String otp, BuildContext context, Status currentState) async {
    final userRepo = Provider.of<UserRepository>(context, listen: false);

    showLoadingDialog(context);

    // userRepo.addListener(() async {
    print("Current State in otp form: \n$currentState");

    if (currentState == Status.Authenticated) {
      print("User Automatically logged in(from otp_logic)");

      // Check if user exists
      bool userExist = await userRepo.doesUserExist(uid: userRepo.user.uid);

      closeLoadingDialog(context);

      userAuthThenCheckIfUserExists(
        context: context,
        phone: widget.phone,
        userExist: userExist,
      );
    }
    // else if (currentState == Status.OtpSent) {
    //   // Go to otp screen to verify
    //   closeLoadingDialog(context);
    //   await userRepo.verifyOTP(otp);
    // } else if (currentState == Status.Unauthenticated) {
    //   // Authentication failed (verificationFailed method called)
    //   closeLoadingDialog(context);
    //   showMySnackbar(
    //     ctx: context,
    //     text: kOtpSendError,
    //     type: SnackbarTypes.Fail,
    //     duration: Duration(seconds: 20),
    //   );
    // }
    else {
      closeLoadingDialog(context);
      showMySnackbar(
        ctx: context,
        text: "Invalid request. Please try again later...",
        type: SnackbarTypes.Normal,
        duration: Duration(seconds: 20),
      );
    }

    // });
  }
}

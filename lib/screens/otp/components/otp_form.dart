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
  late FocusNode pin1FocusNode;
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
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();

    pin1FocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FocusNode.dispose();
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

  Widget charBox(FocusNode focusNode, TextEditingController controller,
      Function onChangedFunc) {
    return SizedBox(
      width: getProportionateScreenWidth(40),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: true,
        style: TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: otpInputDecoration,
        onChanged: (v) => onChangedFunc(v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentState = context.read<UserRepository>().status;
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight! * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              charBox(
                pin1FocusNode,
                _textEditingController1,
                (value) => nextField(value, pin2FocusNode),
              ),
              charBox(
                pin2FocusNode,
                _textEditingController2,
                (value) => nextField(value, pin3FocusNode),
              ),
              charBox(
                pin3FocusNode,
                _textEditingController3,
                (value) => nextField(value, pin4FocusNode),
              ),
              charBox(
                pin4FocusNode,
                _textEditingController4,
                (value) => nextField(value, pin5FocusNode),
              ),
              charBox(
                pin5FocusNode,
                _textEditingController5,
                (value) => nextField(value, pin6FocusNode),
              ),
              charBox(
                pin6FocusNode,
                _textEditingController6,
                (value) => otpSubmitLogic(context),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.15),
          DefaultButton(
            text: "Continue",
            press: () {},
          ),
          //TODO: Remove this line
          // Text("Current State: $currentState"),
        ],
      ),
    );
  }

  otpSubmitLogic(BuildContext context) async {
    final userRepo = context.read<UserRepository>();
    showLoadingDialog(context);

    pin6FocusNode.unfocus();
    var char1 = _textEditingController1.text;
    var char2 = _textEditingController2.text;
    var char3 = _textEditingController3.text;
    var char4 = _textEditingController4.text;
    var char5 = _textEditingController5.text;
    var char6 = _textEditingController6.text;

    var myOTP = char1 + char2 + char3 + char4 + char5 + char6;

    print("Otp entered: $myOTP");

    // userRepo.addListener(() async {
    print("Current State in otp form: ${userRepo.status}");

    if (userRepo.status == Status.Authenticated) {
      print("User Automatically logged in(from otp_logic)");

      // Check if user exists
      bool userExist = await userRepo.doesUserExist(uid: userRepo.user.uid);

      closeLoadingDialog(context);

      userAuthThenCheckIfUserExists(
        context: context,
        phone: widget.phone,
        userExist: userExist,
      );
    } else if (userRepo.status == Status.OtpSent) {
      var res = await userRepo.verifyOTP(myOTP);

      if (res) {
        // Otp verified
        bool userExist = await userRepo.doesUserExist(uid: userRepo.user.uid);
        closeLoadingDialog(context);

        userAuthThenCheckIfUserExists(
          context: context,
          phone: widget.phone,
          userExist: userExist,
        );
      } else {
        // Otp not verified
        closeLoadingDialog(context);
        showMySnackbar(
          ctx: context,
          text: "Wrong OTP",
          type: SnackbarTypes.Normal,
          duration: Duration(seconds: 20),
        );

        _textEditingController1.clear();
        _textEditingController2.clear();
        _textEditingController3.clear();
        _textEditingController4.clear();
        _textEditingController5.clear();
        _textEditingController6.clear();
      }
    } else {
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

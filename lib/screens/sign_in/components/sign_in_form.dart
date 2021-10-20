import 'package:fassla_consumer/components/CustomIcon.dart';
import 'package:fassla_consumer/components/default_button.dart';
import 'package:fassla_consumer/screens/otp/otp_screen.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String mobNum;
  Status _currentState = Status.Unauthenticated;
  @override
  Widget build(BuildContext context) {
    _currentState = context.read<UserRepository>().status;
    // statusChecks("+91 1234567890");
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Column(
            children: [
              buildMobileNumFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              DefaultButton(
                  text: "Continue",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      var phone = "+91 $mobNum";
                      print("Mobile Num: $phone");
                      signInFormLogic(phone, context, _currentState);
                    }
                  }),
              //TODO: Remove this line
              // Text("Current State: $_currentState"),
            ],
          ),
        ],
      ),
    );
  }

  buildMobileNumFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 10,
      decoration: InputDecoration(
        hintText: "Enter your Mobile Number",
        labelText: "Mobile Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.phone),
        prefixText: "+91 ",
      ),
      onChanged: (val) {
        mobNum = val;
      },
      onSaved: (val) {
        mobNum = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return kPhoneNumberNullError;
        } else if (val.length != 10) {
          return kInvalidPhoneNumberError;
        }
        return null;
      },
    );
  }

  signInFormLogic(
      String phone, BuildContext context, Status currentState) async {
    var userRepo = context.read<UserRepository>();

    showLoadingDialog(context);

    var res = await userRepo.sendOTP(phone);

    closeLoadingDialog(context);

    if (res) {
      Navigator.popAndPushNamed(context, OtpScreen.routeName,
          arguments: {"phone": phone});
    } else {
      print("Error running send otp function");
      showMySnackbar(
        ctx: context,
        text: kOtpSendError,
        type: SnackbarTypes.Fail,
        duration: Duration(seconds: 20),
      );
    }
  }
}

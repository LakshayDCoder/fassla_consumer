import 'package:fassla_consumer/components/CustomIcon.dart';
import 'package:fassla_consumer/components/default_button.dart';
import 'package:fassla_consumer/screens/bottom_tabs/bottom_tabs.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  final String phoneNum;
  const SignForm({Key? key, required this.phoneNum}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String email, mobileNumber, name;
  // bool maleBool = false, femaleBool = false;
  bool _phoneEnabled = true;

  @override
  void initState() {
    super.initState();
    mobileNumber = widget.phoneNum;
    if (widget.phoneNum.isEmpty) {
      _phoneEnabled = true;
    } else {
      _phoneEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildMobileNumFormField(),
          // SizedBox(height: getProportionateScreenHeight(30)),
          // buildGenderForm(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
              text: "Continue",
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  submitForm();
                } else {
                  print("Form invalid");
                }
              }),
        ],
      ),
    );
  }

  buildNameFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter your Name",
        labelText: "Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.person),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        name = val;
      },
      onSaved: (val) {
        name = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return kNameNullError;
        }
        return null;
      },
    );
  }

  buildMobileNumFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: mobileNumber,
      enabled: _phoneEnabled,
      decoration: InputDecoration(
        hintText: "Enter your Mobile Number",
        labelText: "Mobile Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.phone),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        mobileNumber = val;
      },
      onSaved: (val) {
        mobileNumber = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return kPhoneNumberNullError;
        }
        return null;
      },
    );
  }

  buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.mail_outline),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        email = val;
      },
      onSaved: (val) {
        email = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(val)) {
          return kInvalidEmailError;
        }
        return null;
      },
    );
  }

  // buildGenderForm() {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       SizedBox(
  //         width: SizeConfig.screenWidth! * 0.4,
  //         child: CheckboxListTile(
  //           title: Text("Male"),
  //           value: maleBool,
  //           onChanged: (myBool) {
  //             maleBool = myBool!;
  //             setState(() {
  //               if (maleBool) {
  //                 femaleBool = false;
  //                 gender = "Male";
  //               }
  //             });
  //           },
  //         ),
  //       ),
  //       SizedBox(
  //         width: SizeConfig.screenWidth! * 0.4,
  //         child: CheckboxListTile(
  //           title: Text("Female"),
  //           value: femaleBool,
  //           onChanged: (myBool) {
  //             femaleBool = myBool!;
  //             setState(() {
  //               if (femaleBool) {
  //                 maleBool = false;
  //                 gender = "Female";
  //               }
  //             });
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  submitForm() async {
    print("Email: $email, Name: $name, MobileNum: $mobileNumber");

    var userRepo = context.read<UserRepository>();

    var docId = userRepo.user.uid;

    var res = await userRepo.addOrUpdateUser(
      name: name,
      email: email,
      phone: mobileNumber,
      docId: docId,
      address: "",
    );

    if (res) {
      showMySnackbar(
        ctx: context,
        text: "User Registered Successfully",
        type: SnackbarTypes.Success,
      );
      Navigator.pushNamedAndRemoveUntil(
          context, BottomTabsScreen.routeName, (route) => false);
    } else {
      showMySnackbar(ctx: context, text: "Error", type: SnackbarTypes.Fail);
    }
  }
}

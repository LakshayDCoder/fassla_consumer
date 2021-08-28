import 'package:fassla_consumer/components/CustomIcon.dart';
import 'package:fassla_consumer/components/default_button.dart';
import 'package:fassla_consumer/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String email, mobileNumber, gender, name;
  bool maleBool = false, femaleBool = false;

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
          SizedBox(height: getProportionateScreenHeight(30)),
          buildGenderForm(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
              text: "Continue",
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print("Email: $email, Name: $name, MobileNum: $mobileNumber");
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (route) => false);
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
      decoration: InputDecoration(
        hintText: "Enter your Mobile Number",
        labelText: "Mobile Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.phone),
        prefixText: "+91 ",
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
        } else if (val.length != 10) {
          return kInvalidPhoneNumberError;
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

  buildGenderForm() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: SizeConfig.screenWidth! * 0.4,
          child: CheckboxListTile(
            title: Text("Male"),
            value: maleBool,
            onChanged: (myBool) {
              maleBool = myBool!;
              setState(() {
                if (maleBool) {
                  femaleBool = false;
                  gender = "Male";
                }
              });
            },
          ),
        ),
        SizedBox(
          width: SizeConfig.screenWidth! * 0.4,
          child: CheckboxListTile(
            title: Text("Female"),
            value: femaleBool,
            onChanged: (myBool) {
              femaleBool = myBool!;
              setState(() {
                if (femaleBool) {
                  maleBool = false;
                  gender = "Female";
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

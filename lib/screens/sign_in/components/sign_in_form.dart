import 'package:fassla_consumer/components/CustomIcon.dart';
import 'package:fassla_consumer/components/default_button.dart';
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
  late String mobNum;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildMobileNumFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
              text: "Continue",
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print("Mobile Num: $mobNum");
                }
              }),
        ],
      ),
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
}

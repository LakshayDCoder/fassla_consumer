import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/components/CustomIcon.dart';
import 'package:fassla_consumer/components/default_button.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../size_config.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  static const routeName = "/my-profile";

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String email, mobileNumber, name, address;
  bool _isEditable = false;
  late DocumentSnapshot userSnap;

  getCurrentUser() async {
    var repo = Provider.of<UserRepository>(context, listen: false);

    userSnap = await repo.getCurrentUserData();

    email = userSnap["email"];
    name = userSnap["name"];
    mobileNumber = userSnap["phone"] ?? "";
    address = userSnap["address"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: FutureBuilder(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return myForm();
          }

          return myLoader();
        },
      ),
      floatingActionButton: myFAB(),
    );
  }

  toggleEditable() {
    setState(() {
      _isEditable = !_isEditable;
    });
  }

  Widget myFAB() => FloatingActionButton(
        onPressed: () {
          toggleEditable();
        },
        child: _isEditable ? Icon(Icons.clear) : Icon(Icons.edit),
      );

  Widget myLoader() => Center(
        child: CircularProgressIndicator.adaptive(),
      );

  Widget myForm() => Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(30)),
              buildNameFormField(),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildMobileNumFormField(),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildAddressFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              if (_isEditable) submitFormButton(),
            ],
          ),
        ),
      );

  submitFormButton() => DefaultButton(
      text: "Update User",
      press: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          updateUserProfile();
        } else {
          print("Form invalid");
        }
      });

  buildNameFormField() {
    return TextFormField(
      initialValue: name,
      enabled: _isEditable,
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
      enabled: false,
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
      initialValue: email,
      enabled: _isEditable,
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

  buildAddressFormField() {
    return TextFormField(
      initialValue: address,
      enabled: _isEditable,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Eg. 123 Block A \nXYZ Road\nCity\nState\nPin Code",
        labelText: "Address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.location_city_rounded),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        address = val;
      },
      onSaved: (val) {
        address = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return kAddressNullError;
        }
        return null;
      },
    );
  }

  updateUserProfile() async {
    var repo = Provider.of<UserRepository>(context, listen: false);
    var res = await repo.addOrUpdateUser(
      name: name,
      email: email,
      phone: mobileNumber,
      docId: userSnap.id,
      address: address,
    );

    if (res) {
      showMySnackbar(ctx: context, text: "Successfully updated user");
    } else {
      showMySnackbar(ctx: context, text: "Some Error occurred");
    }
    toggleEditable();
  }
}

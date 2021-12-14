import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/components/CustomIcon.dart';
import 'package:fassla_consumer/components/default_button.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
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
  String email = "",
      mobileNumber = "",
      name = "",
      address1 = "",
      address2 = "",
      city = "",
      state = "",
      pin = "";

  bool _isEditable = false;
  late DocumentSnapshot userSnap;
  var _isLoading = true;

  Future getCurrentUser() async {
    setState(() {
      _isLoading = true;
    });

    print("Getting user data");
    var repo = Provider.of<UserRepository>(context, listen: false);

    userSnap = await repo.getCurrentUserData();
    var userData = userSnap.data()! as Map<String, dynamic>;

    print("User Data: $userData");

    String checkIfKeyExists(String key) {
      return userData.containsKey(key) ? userData[key] : "";
    }

    email = checkIfKeyExists("email");
    name = checkIfKeyExists("name");
    mobileNumber = checkIfKeyExists("phone");
    address1 = checkIfKeyExists("address1");
    address2 = checkIfKeyExists("address2");
    city = checkIfKeyExists("city");
    state = checkIfKeyExists("state");
    pin = checkIfKeyExists("pin");

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: _isLoading ? myLoader() : myForm(),
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

  Widget myForm() => SingleChildScrollView(
        child: Container(
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
                buildAddress1FormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildAddress2FormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildCityFormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildStateFormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildPinFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                if (_isEditable) submitFormButton(),
              ],
            ),
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

  buildAddress1FormField() {
    return TextFormField(
      initialValue: address1,
      enabled: _isEditable,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Eg. 123 Block A",
        labelText: "Address Line 1",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.location_city_rounded),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        address1 = val;
      },
      onSaved: (val) {
        address1 = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return kAddressNullError;
        }
        return null;
      },
    );
  }

  buildAddress2FormField() {
    return TextFormField(
      initialValue: address2,
      enabled: _isEditable,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Eg. XYZ Road",
        labelText: "Address Line 2",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.location_city_rounded),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        address2 = val;
      },
      onSaved: (val) {
        address2 = val!;
      },
    );
  }

  buildCityFormField() {
    return TextFormField(
      initialValue: city,
      enabled: _isEditable,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Eg. Ludhiana",
        labelText: "City",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.location_city_rounded),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        city = val;
      },
      onSaved: (val) {
        city = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter your city / town.";
        }
        return null;
      },
    );
  }

  buildStateFormField() {
    return TextFormField(
      initialValue: state,
      enabled: _isEditable,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Eg. Punjab",
        labelText: "State",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.location_city_rounded),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        state = val;
      },
      onSaved: (val) {
        state = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter your state.";
        }
        return null;
      },
    );
  }

  buildPinFormField() {
    return TextFormField(
      maxLength: 6,
      initialValue: pin,
      keyboardType: TextInputType.number,
      enabled: _isEditable,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Eg. 141001",
        labelText: "Pin",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomIcon(icon: Icons.location_city_rounded),
        errorStyle: TextStyle(color: kErrorColor),
      ),
      onChanged: (val) {
        pin = val;
      },
      onSaved: (val) {
        pin = val!;
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
      address1: address1,
      address2: address2,
      pin: pin,
      state: state,
      city: city,
    );

    if (res) {
      showMySnackbar(ctx: context, text: "Successfully updated user");
    } else {
      showMySnackbar(ctx: context, text: "Some Error occurred");
    }
    toggleEditable();
  }
}

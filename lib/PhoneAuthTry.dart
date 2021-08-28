import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthForm extends StatefulWidget {
  PhoneAuthForm({Key? key}) : super(key: key);
  static const routeName = "/phone-auth-try";

  @override
  _PhoneAuthFormState createState() => _PhoneAuthFormState();
}

class _PhoneAuthFormState extends State<PhoneAuthForm> {

  TextEditingController _otpController = new TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _verificationId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Auth Try"),),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              ElevatedButton(onPressed: signIn, child: Text("Send OTP")),
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: "OTP",
                  hintText: "Enter OTP"
                ),
              ),
              ElevatedButton(onPressed: verifyOTP, child: Text("Verify"))
            ],
          ),
        ),
      ),
    );
  }

  showSnackbar(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future signIn() async{
    var num = "+91 9878400227";

    // This whole function is for auto check for ANDROID ONLY!
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
          print("Automatic verification Completed");
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}");
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showSnackbar("The provided phone number is not valid.");
          }else{
            showSnackbar("Some Error occurred");
          }
      print('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, int? resendToken) async {
          print("Code Sent");
      showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackbar("verification code: " + verificationId);
      _verificationId = verificationId;
    };


    await _auth.verifyPhoneNumber(
        phoneNumber: num,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  verifyOTP() async {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _otpController.text,
        );

        final User? user = (await _auth.signInWithCredential(credential)).user;

        showSnackbar("Successfully signed in UID: ${user!.uid}");
      } catch (e) {
        showSnackbar("Failed to sign in: " + e.toString());
      }

  }




}

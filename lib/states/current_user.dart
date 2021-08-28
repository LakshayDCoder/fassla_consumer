import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentState extends ChangeNotifier {
  // String _uid, _mobile;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpUser(String _mobNum) async {
    bool retVal = false;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 $_mobNum',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  // Future<bool> signInUser(String _mobNum) async {}
}

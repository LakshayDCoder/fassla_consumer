import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

class SaveToUsers extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  late String _name, _phone, _email, _gender, _docId, _uid;

  late User _currentUser;
  AuthState _currentState = AuthState.invalid;
  var _verificationId = "";

  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future registerUser({
    required String name,
    required String email,
    required String phone,
    required String gender,
  }) async {
    await sendOTP(phone);

    // If not Automatically verified, verify otp
    await verifyOTP("otp");

    // if login and otp verified check if user exists
    await doesUserExist(uid: "uid");

    // If login user does not exists go to register screen
    // IF otp verified add or update the user and login
    await addOrUpdateUser(
      name: "name",
      email: 'email',
      phone: 'phone',
      gender: 'gender',
      docId: 'docId',
    );
  }

  //=============Firebase Auth Methods===========

  Future<AuthState> sendOTP(String phone) async {
    AuthState returnState = AuthState.invalid;

    _phone = phone;
    _uid = "";

    // This whole function is for auto check for ANDROID ONLY!
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      print("Automatic verification Completed (from auth state model)");

      UserCredential myUserCreds =
          await _auth.signInWithCredential(phoneAuthCredential);
      _currentUser = myUserCreds.user!;
      _uid = _currentUser.uid;
      _phone = _currentUser.phoneNumber!;

      returnState = AuthState.authenticated;
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        returnState = AuthState.failed;
      } else {
        returnState = AuthState.failed;
      }
      print('Verification failed (from auth state model)');
    };

    PhoneCodeSent codeSent = (String verificationId, int? resendToken) async {
      print("Code Sent (from auth state model)");
      returnState = AuthState.otpSent;
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      returnState = AuthState.otpSent;
      _verificationId = verificationId;
    };

    try {
      await _auth
          .verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      )
          .then((_) {
        print("Verify Phone Number Function complete ( from save to users )");
      });
    } catch (e) {
      print(e);
    }

    _currentState = returnState;
    return returnState;
  }

  Future<AuthState> verifyOTP(String otp) async {
    AuthState returnState = AuthState.otpSent;

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      UserCredential myUserCreds = await _auth.signInWithCredential(credential);
      _currentUser = myUserCreds.user!;
      _uid = _currentUser.uid;
      _phone = _currentUser.phoneNumber!;
      print("Otp Successfully verified (from auth state model)");

      returnState = AuthState.authenticated;
    } catch (e) {
      print("Otp not verified (from auth state model)");
      returnState = AuthState.failed;
    }

    _currentState = returnState;
    return returnState;
  }

  Future<AuthState> signOut() async {
    AuthState returnState = AuthState.invalid;

    await _auth.signOut();
    notifyListeners();

    _currentState = returnState;
    return returnState;
  }

  //==================Firebase Firestore methods==============

  Future<AuthState> addOrUpdateUser({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String docId,
  }) async {
    AuthState returnVal = AuthState.savingData;

    _users.doc(docId).set({
      'name': name,
      "phone": phone,
      "email": email,
      "gender": gender,
    }).then((value) {
      print("User Added (from Save To users)");
      returnVal = AuthState.readyForUser;
    }).catchError((error) {
      print("Failed to add user: $error, (from Save To users)");
      returnVal = AuthState.invalid;
    });

    _currentState = returnVal;
    return returnVal;
  }

  Future<AuthState> doesUserExist({required String uid}) async {
    AuthState returnVal = _currentState;

    _users.doc(uid).get().then((docSnap) {
      var docData = docSnap.data();
      if (docData == null) {
        print("User does not exist (from Save To users)");
        returnVal = AuthState.noUserExist;
      }
    });

    _currentState = returnVal;
    return returnVal;
  }
}

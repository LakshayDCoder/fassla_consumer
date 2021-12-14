import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/states/SharedPrefsRepo.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class UserRepository extends ChangeNotifier {
  FirebaseAuth _auth;
  late User _user;
  Status _status = Status.Uninitialized;

  String _verificationId = "";
  String _currentUserId = "";

  String get currentUID => _currentUserId;

  // Initialising my User repo and _auth variable while listening to state changes to auth
  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);

    if (FirebaseAuth.instance.currentUser != null) {
      _status = Status.Authenticated;
      _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      _currentUserId = "";
    }
  }

  Status get status => _status;
  User get user => _user;

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _currentUserId = firebaseUser.uid;
    }
    notifyListeners();
  }

  //============Firebase Auth Functions===========
  Future<bool> sendOTP(String phone) async {
    _currentUserId = "";
    try {
      _status = Status.Authenticating;

      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          print("Automatic verification Completed (from auth state model)");
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _status = Status.Unauthenticated;
          print('Verification failed (from auth state model): $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code Sent (from auth state model)");
          _verificationId = verificationId;
          _status = Status.OtpSent;
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      return true;
    } catch (e) {
      print("Error while sending otp(from User Repo)");
      _status = Status.Unauthenticated;
      return false;
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      print("Otp Successfully verified (from auth state model)");
      return true;
    } catch (e) {
      print("Otp not verified (from auth state model)");
      _status = Status.Unauthenticated;
      return false;
    }
  }

  Future signOut() async {
    await _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<String> getCurrentUserId() async {
    return _auth.currentUser!.uid.toString();
  }

  //==================Firebase Firestore methods==============

  CollectionReference _fireStore =
      FirebaseFirestore.instance.collection(kUserCollection);

  Future<bool> addOrUpdateUser({
    required String name,
    required String email,
    required String phone,
    required String docId,
    required String address1,
    required String address2,
    required String city,
    required String state,
    required String pin,
  }) async {
    try {
      await _fireStore.doc(docId).set({
        'name': name,
        "phone": phone,
        "email": email,
        "address1": address1,
        "address2": address2,
        "city": city,
        "state": state,
        "pin": pin,
      });

      print("User Added (from Save To users)");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sName, name);
      await prefs.setString(sEmail, email);
      await prefs.setString(sMobile, phone);
      await prefs.setString(sUid, docId);

      return true;
    } catch (e) {
      print("Failed to add user: $e, (from Save To users)");
      if (_status == Status.Authenticated) {
        signOut();
      }

      return false;
    }
  }

  Future<bool> doesUserExist({required String uid}) async {
    DocumentSnapshot docSnap = await _fireStore.doc(uid).get();
    var docData = docSnap.data();
    if (docData == null) {
      print("User does not exist (from Save To users)");
      return false;
    } else {
      print("User Found");

      print(
          "Name: ${docSnap["name"]}, Email: ${docSnap["email"]}, Phone: ${docSnap["phone"]}");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sName, docSnap["name"].toString());
      await prefs.setString(sEmail, docSnap["email"].toString());
      await prefs.setString(sMobile, docSnap["phone"].toString());
      await prefs.setString(sUid, docSnap.id);

      // var sharedPrefRepo = SharedPrefsRepo();
      // sharedPrefRepo.setMyString(sName, docSnap["name"].toString());
      // sharedPrefRepo.setMyString(sEmail, docSnap["email"].toString());
      // sharedPrefRepo.setMyString(sMobile, docSnap["phone"].toString());
      // sharedPrefRepo.setMyString(sUid, docSnap.id);

      return true;
    }
  }

  Future<DocumentSnapshot> getCurrentUserData() async {
    // print("Getting user data from user repo");
    var uid = await getCurrentUserId();
    return await _fireStore.doc(uid).get();
  }
}

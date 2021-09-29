import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreTry extends StatefulWidget {
  const FirestoreTry({Key? key}) : super(key: key);

  static const routeName = "/firestore-try";

  @override
  _FirestoreTryState createState() => _FirestoreTryState();
}

class _FirestoreTryState extends State<FirestoreTry> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  addUsers() async {
    _users
        .doc("test_doc_id")
        .set({
          'name': "Test2",
          "phone": "+91 1234567890",
          "email": "test@test.com",
          "gender": "male",
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  findUser() async {
    _users.doc("test_doc").get().then((docSnap) {
      var docData = docSnap.data();
      print(docData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Try"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("Add users"),
            onPressed: () {
              addUsers();
            },
          ),
          ElevatedButton(
            child: Text("Get users"),
            onPressed: () {
              findUser();
            },
          ),
        ],
      ),
    );
  }
}

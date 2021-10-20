import 'package:fassla_consumer/states/SharedPrefsRepo.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class LogOutTile extends StatelessWidget {
  const LogOutTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      title: Text(
        "Log Out",
        style: TextStyle(color: Colors.redAccent),
      ),
      trailing: Icon(
        Icons.logout,
        color: Colors.redAccent,
      ),
      onTap: () {
        context.read<UserRepository>().signOut();
        SharedPrefsRepo().clearAll();
      },
    );
  }
}

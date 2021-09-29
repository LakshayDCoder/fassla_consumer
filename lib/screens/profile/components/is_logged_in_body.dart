import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IsLoggedInBody extends StatelessWidget {
  const IsLoggedInBody({Key? key}) : super(key: key);

  // The user is logged in

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserRepository>(context);

    var logOutTile = ListTile(
      title: Text(
        "Log Out",
        style: TextStyle(color: Colors.redAccent),
      ),
      trailing: Icon(
        Icons.logout,
        color: Colors.redAccent,
      ),
      onTap: () {
        userRepo.signOut().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Logged Out Successfully"),
            backgroundColor: Colors.redAccent,
          ));
        });
      },
    );

    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Your Orders"),
          ),
          logOutTile,
        ],
      ),
    );
  }
}

import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/is_logged_in_body.dart';
import 'components/is_logged_out_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserRepository>(context);

    print("Is logged in: ${userRepo.status}");

    return Column(
      children: [
        userRepo.status == Status.Authenticated
            ? IsLoggedInBody()
            : IsLoggedOutBody()
      ],
    );
  }
}

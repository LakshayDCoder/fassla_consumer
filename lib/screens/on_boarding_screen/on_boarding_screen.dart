import 'package:fassla_consumer/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  static const routeName = "/on-boarding-screen";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(
      ),
    );
  }
}

/*Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://picsum.photos/1080/1920?blur=10"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlutterLogo(size: 200),
                Text(
                  "Splash Screen",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(32),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),*/

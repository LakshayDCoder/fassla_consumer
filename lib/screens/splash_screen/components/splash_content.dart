import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({Key? key, required this.text, required this.image})
      : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 1),
        Text(
          "Fassla",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
          ),
        ),
        Spacer(flex: 2),
        Image.network(
          image,
          height: getProportionateScreenHeight(256),
          width: getProportionateScreenWidth(256),
        ),
      ],
    );
  }
}

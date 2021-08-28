import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../size_config.dart';

class CustomSvgIcon extends StatelessWidget {
  const CustomSvgIcon({Key? key, required this.svgPath}) : super(key: key);
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: SvgPicture.asset(
        svgPath,
        height: getProportionateScreenHeight(16),
      ),
    );
  }
}

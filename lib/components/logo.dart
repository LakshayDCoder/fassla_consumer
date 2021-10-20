import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class FasslaLogo extends StatelessWidget {
  const FasslaLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Fassla",
        textAlign: TextAlign.center,
        style: GoogleFonts.getFont(
          "Lato",
          textStyle: TextStyle(
            fontSize: 50,
            fontStyle: FontStyle.italic,
            color: kPrimaryColor,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

import 'package:url_launcher/url_launcher_string.dart';

// redirecting to website
void redirectToBETWebsite() async {
  final String blackeyetechURL = "http://www.blackeyetech.in";
  if (await canLaunchUrlString(blackeyetechURL)) {
    await launchUrlString(blackeyetechURL);
  } else {
    throw 'Could not launch $blackeyetechURL';
  }
}

// redirecting to facebook
void redirectToBEtFacebook() async {
  final String blackeyetechURL = "https://www.facebook.com/BlackEyeTech/";
  if (await canLaunchUrlString(blackeyetechURL)) {
    await launchUrlString(blackeyetechURL);
  } else {
    throw 'Could not launch $blackeyetechURL';
  }
}

// redirecting to instagram
void redirectToBETInstagram() async {
  final String blackeyetechURL =
      "https://www.instagram.com/blackeyetech/?hl=en";
  if (await canLaunchUrlString(blackeyetechURL)) {
    await launchUrlString(blackeyetechURL);
  } else {
    throw 'Could not launch $blackeyetechURL';
  }
}

// redirecting to LinkedIn
void redirectToBETLinkedIn() async {
  final String blackeyetechURL =
      "https://in.linkedin.com/company/black-eye-technologies";
  if (await canLaunchUrlString(blackeyetechURL)) {
    await launchUrlString(blackeyetechURL);
  } else {
    throw 'Could not launch $blackeyetechURL';
  }
}

void contactUsBtn() {
  launchUrlString('tel://8872554895');
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutDev extends StatefulWidget {
  const AboutDev({Key? key}) : super(key: key);

  static const routeName = "/about-dev";

  @override
  _AboutDevState createState() => _AboutDevState();
}

class _AboutDevState extends State<AboutDev> {
  final _mailTo = "lakshaydcoder@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Dev"),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Hello there, I am ",
                style: TextStyle(
                    fontSize: 16, letterSpacing: 0.8, color: Colors.black),
                children: [
                  TextSpan(
                    text: "Lakshay. ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "This whole app is made using the "),
                  TextSpan(
                    text: "Flutter Framework ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          "developed by Google. This is a fully developed ecommerce app, with cart, orders and a payment gateway already installed. If you want the whole source code please feel free to contact me on my mail below."),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                _sendingMails();
              },
              icon: Icon(Icons.email),
              label: Text("lakshaydcoder@gmail.com"),
            ),
          ],
        ),
      ),
    );
  }

  _sendingMails() async {
    var url = 'mailto:$_mailTo?subject=Fassla App - Enquiry';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'package:fassla_consumer/components/default_button.dart';
import 'package:fassla_consumer/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'splash_content.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;

  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Fassla, Let’s shop!",
      "image": "https://picsum.photos/500/700?random=1",
    },
    {
      "text":
          "We help people conect with store \naround United State of America",
      "image": "https://picsum.photos/500/700?random=2",
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "https://picsum.photos/500/700?random=3",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                itemCount: splashData.length,
                itemBuilder: (ctx, index) => SplashContent(
                  text: splashData[index]["text"]!,
                  image: splashData[index]["image"]!,
                ),
                onPageChanged: (val) {
                  setState(() {
                    currentPage = val;
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index),
                      ),
                    ),
                    Spacer(),
                    DefaultButton(
                        text: "Continue",
                        press: () {
                          Navigator.pushNamed(context, SignInScreen.routeName);
                        }),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot(int index) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

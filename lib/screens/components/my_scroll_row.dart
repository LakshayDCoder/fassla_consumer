import 'package:flutter/material.dart';

class MyScrollRow extends StatelessWidget {
  final String heading;
  const MyScrollRow({Key? key, required this.heading}) : super(key: key);

  Widget myCard(int index) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage:
                NetworkImage("https://picsum.photos/100?random=$index"),
            radius: 30,
          ),
          Text("Product ${index + 1}")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text(heading),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20 + 1,
            itemBuilder: (_, index) {
              if (index == 20) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward),
                  ),
                );
              }
              return myCard(index);
            },
          ),
        ),
      ],
    );
  }
}

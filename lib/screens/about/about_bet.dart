import 'package:fassla_consumer/components/redirects.dart';
import 'package:flutter/material.dart';

class AboutBET extends StatefulWidget {
  static const routeName = "/about-bet";

  @override
  _AboutBETState createState() => _AboutBETState();
}

class _AboutBETState extends State<AboutBET> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Black Eye Technologies"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Black Eye Technologies",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.network(
                  "http://www.blackeyetech.in/img/logobet.png",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "Address: 1st floor, 968, Street Number 2, Parkash Puri, 6, Tagore Colony, Miller Ganj, Ludhiana, Punjab 141003",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "About us ",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "People says the technologies are ruining the nature and environment. So we have decided that now technologies will heal the nature.Our thinking is very simple Build a new India with the help of new technologies. ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    "We always know that by creating new technology we create a new way to develop the world and help the people. We believe in helping people and making their life easy with the help of new technology. We are using Internet of Things, Artificial Intelligence, Machine Learning and Programming skills of Hardware and Android to develop new gadgets and tools to help the society and save the nature.. ",
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      redirectToBEtFacebook();
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://1000logos.net/wp-content/uploads/2021/04/Facebook-logo.png"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      redirectToBETInstagram();
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://i.pinimg.com/originals/c8/95/2d/c8952d6e421a83d298a219edee783167.jpg"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      redirectToBETWebsite();
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://png.pngtree.com/png-vector/20190319/ourmid/pngtree-vector-web-search-icon-png-image_847735.jpg"),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    contactUsBtn();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Contact Us at : 8872554895",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

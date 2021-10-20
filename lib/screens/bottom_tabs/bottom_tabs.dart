import 'package:fassla_consumer/screens/HomeScreen/HomeScreen.dart';
import 'package:fassla_consumer/screens/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/my_app_bar.dart';
import '../../constants.dart';
import '../drawer/my_drawer.dart';

class BottomTabsScreen extends StatefulWidget {
  const BottomTabsScreen({Key? key}) : super(key: key);
  static const routeName = "/bottom-tab-screen";

  @override
  _BottomTabsScreenState createState() => _BottomTabsScreenState();
}

class _BottomTabsScreenState extends State<BottomTabsScreen> {
  int _selectedIndex = 0;

  List<Widget> screensList = [
    HomeScreen(),
    SearchScreen(),
    // CartScreen(),
    // ProfileScreen(),
    MyDrawer(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var myUid = SharedPrefsRepo().getMyString(sUid);

    // print("Shared Prefs UID: $myUid");

    var myBottomNavBar = BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          // backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.shopping_cart),
        //   label: 'Cart',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      currentIndex: _selectedIndex,
      backgroundColor: kPrimaryColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );

    return Scaffold(
      // drawer: Drawer(child: MyDrawer()),
      appBar: MyAppBar(title: "Home Screen"),
      body: screensList.elementAt(_selectedIndex),
      bottomNavigationBar: myBottomNavBar,
    );
  }
}

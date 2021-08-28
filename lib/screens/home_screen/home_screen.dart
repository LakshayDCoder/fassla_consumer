import 'package:fassla_consumer/constants.dart';
import 'package:fassla_consumer/screens/cart/cart_screen.dart';
import 'package:fassla_consumer/screens/home_screen/components/home_body.dart';
import 'package:fassla_consumer/screens/home_screen/components/my_app_bar.dart';
import 'package:fassla_consumer/screens/home_screen/components/my_drawer.dart';
import 'package:fassla_consumer/screens/profile/profile_screen.dart';
import 'package:fassla_consumer/screens/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> screensList = [
    HomeBody(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
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
      drawer: MyDrawer(),
      appBar: MyAppBar(),
      body: screensList.elementAt(_selectedIndex),
      bottomNavigationBar: myBottomNavBar,
    );
  }
}

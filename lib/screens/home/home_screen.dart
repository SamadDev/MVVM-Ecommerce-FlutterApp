import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/constants.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/body.dart';
import '../../../Services/Products_db.dart';
import '../../../size_config.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;
  List<Widget> pageList = [];
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  final product_dbServices p = new product_dbServices();

  @override
  void initState() {
    pageList.add(Body());
    pageList.add(SplashScreen());
    pageList.add(CartScreen());
    pageList.add(ProfileScreen());
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedPage,
        children: pageList,
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
        curve: Curves.easeInOutQuint,
        activeColor: PrimaryColor,
        reverse: true,
        items: [
          TitledNavigationBarItem(
              icon: Icons.home_outlined,
              title: Text("Home", style: TextStyle(fontFamily: "PantonBold"))),
          TitledNavigationBarItem(
              icon: Icons.favorite_border_outlined,
              title: Text("Favourites",
                  style: TextStyle(fontFamily: "PantonBold"))),
          TitledNavigationBarItem(
              icon: Icons.shopping_cart_outlined,
              title: Text("Cart", style: TextStyle(fontFamily: "PantonBold"))),
          TitledNavigationBarItem(
              icon: Icons.person_outline_rounded,
              title:
                  Text("ProfIle", style: TextStyle(fontFamily: "PantonBold"))),
        ],
        currentIndex: _selectedPage,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}

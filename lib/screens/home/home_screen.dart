import 'package:flutter/material.dart';
import 'package:shop_app/components/constants.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'components/body.dart';
import '../../components/size_config.dart';
import 'package:shop_app/screens/favourites/Favs_screen.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/Services/globalVars.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pageList = [];

  @override
  void initState() {
    pageList.add(HomeBody());
    pageList.add(FavScreen());
    pageList.add(CartScreen());
    pageList.add(ProfileScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<globalVars>(builder: (_, gv, __) {
      return Scaffold(
        body: IndexedStack(
          index: gv.selectedPage,
          children: pageList,
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitledBottomNavigationBar(
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
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(13), fontFamily: "PantonBold"))),
                TitledNavigationBarItem(
                    icon: Icons.shopping_cart_outlined,
                    title: Text("Cart", style: TextStyle(fontFamily: "PantonBold"))),
                TitledNavigationBarItem(
                    icon: Icons.person_outline_rounded,
                    title: Text("ProfIle", style: TextStyle(fontFamily: "PantonBold"))),
              ],
              currentIndex: gv.selectedPage,
              onTap: (index) => _onItemTapped(gv, index),
            ),
            Container(
              color: Colors.white,
              height: Theme.of(context).platform == TargetPlatform.iOS
                  ? getProportionateScreenWidth(16)
                  : 0,
            )
          ],
        ),
      );
    });
  }

  void _onItemTapped(globalVars gv, int index) {
    setState(() {
      gv.selectedPage = index;
    });
  }
}

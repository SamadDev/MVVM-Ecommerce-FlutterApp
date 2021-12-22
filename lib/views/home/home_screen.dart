import 'package:flutter/material.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'components/body.dart';
import 'package:ecommerce_app/utils/size_config.dart';
import 'package:ecommerce_app/views/favourites/Favs_screen.dart';
import 'package:ecommerce_app/views/cart/cart_screen.dart';
import 'package:ecommerce_app/views/profile/profile_screen.dart';
import 'package:ecommerce_app/view_models/globalVariables_viewModel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _pageList = [];

  @override
  void initState() {
    _pageList.add(HomeBody());
    _pageList.add(FavScreen());
    _pageList.add(CartScreen());
    _pageList.add(ProfileScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<globalVars>(builder: (_, gv, __) {
      return Scaffold(
        body: IndexedStack(
          index: gv.selectedPage,
          children: _pageList,
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
                    title: Text("Home",
                        style: TextStyle(fontFamily: "PantonBold"))),
                TitledNavigationBarItem(
                    icon: Icons.favorite_border_outlined,
                    title: Text("Favourites",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(13),
                            fontFamily: "PantonBold"))),
                TitledNavigationBarItem(
                    icon: Icons.shopping_cart_outlined,
                    title: Text("Cart",
                        style: TextStyle(fontFamily: "PantonBold"))),
                TitledNavigationBarItem(
                    icon: Icons.person_outline_rounded,
                    title: Text("ProfIle",
                        style: TextStyle(fontFamily: "PantonBold"))),
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

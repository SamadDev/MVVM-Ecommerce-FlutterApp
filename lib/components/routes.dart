import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/category/categoryScreen.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/sign_in/SignInScreen.dart';
import 'package:shop_app/screens/favourites/Favs_screen.dart';
import 'package:shop_app/screens/sign_up/SignUpScreen.dart';
import 'package:shop_app/screens/profile/components/orders/ordersScreen.dart';
import 'package:shop_app/screens/profile/components/userInfo/userInfo.dart';

final Map<String, WidgetBuilder> routes = {
  FavScreen.routeName: (context) => FavScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CategoryScreen.routeName: (context) => CategoryScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  UserInfoScreen.routeName: (context) => UserInfoScreen(),
};

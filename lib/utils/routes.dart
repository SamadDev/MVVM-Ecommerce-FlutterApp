import 'package:flutter/widgets.dart';
import 'package:ecommerce_app/views/cart/cart_screen.dart';
import 'package:ecommerce_app/views/category/categoryScreen.dart';
import 'package:ecommerce_app/views/prodDetails/details_screen.dart';
import 'package:ecommerce_app/views/home/home_screen.dart';
import 'package:ecommerce_app/views/home/components/searchScreen.dart';
import 'package:ecommerce_app/views/profile/profile_screen.dart';
import 'package:ecommerce_app/views/sign_in/SignInScreen.dart';
import 'package:ecommerce_app/views/favourites/Favs_screen.dart';
import 'package:ecommerce_app/views/sign_up/SignUpScreen.dart';
import 'package:ecommerce_app/views/profile/components/orders/ordersScreen.dart';
import 'package:ecommerce_app/views/profile/components/userInfo/userInfo.dart';

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
  SearchScreen.routeName: (context) => SearchScreen(),
};

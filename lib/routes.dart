import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/category/categoryScreen.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/favourites/Favs_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'package:shop_app/screens/profile/components/orders/ordersScreen.dart';
import 'package:shop_app/screens/profile/components/userInfo/userInfo.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  FavScreen.routeName: (context) => FavScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CategoryScreen.routeName: (context) => CategoryScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  UserInfoScreen.routeName: (context) => UserInfoScreen(),
};

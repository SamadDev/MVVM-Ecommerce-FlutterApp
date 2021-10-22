import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/profile/components/orders/ordersScreen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'profile_menu.dart';
import '../../../../size_config.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';
import '../../../globalVars.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User loggedInUser;

  @override
  void initState() {
    loggedInUser = Provider.of<AuthenticationService>(context, listen: false).CurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<globalVars>(builder: (_, gv, __) {
      return FutureBuilder(
          future: gv.getUserInfo(loggedInUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Flexible(
                      flex: 2,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: PrimaryColor,
                      )),
                  Flexible(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          ProfileMenu(
                            text: "My Account",
                            icon: "assets/icons/User Icon.svg",
                            press: () => {},
                          ),
                          ProfileMenu(
                            text: "My Orders",
                            icon: "assets/icons/Bell.svg",
                            press: () {
                              Navigator.pushNamed(
                                context,
                                OrdersScreen.routeName,
                                arguments: OrderArguments(ordersID: gv.UserInfo['orders']),
                              );
                            },
                          ),
                          ProfileMenu(
                            text: "Settings",
                            icon: "assets/icons/Settings.svg",
                            press: () async {
                              print(gv.UserInfo['orders']);
                              //await gv.getUserInfo(loggedInUser);
                            },
                          ),
                          ProfileMenu(
                            text: "Help Center",
                            icon: "assets/icons/Question mark.svg",
                            press: () {
                              print(gv.UserInfo['Full Name']);
                            },
                          ),
                          ProfileMenu(
                            text: "Log Out",
                            icon: "assets/icons/Log out.svg",
                            press: () async {
                              print("Sign-Out of ${loggedInUser.email}");
                              context.read<AuthenticationService>().signOut();
                              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                    height: getProportionateScreenWidth(40),
                    width: getProportionateScreenWidth(40),
                    child: CircularProgressIndicator(
                      color: SecondaryColorDark,
                    )),
              );
            }

            return Container();
          });
    });
  }
}

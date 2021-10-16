import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/profile/components/orders/ordersScreen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Consumer<globalVars>(builder: (_, gv, __) {
        return Column(
          children: [
            ProfilePic(),
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
                Navigator.pushNamed(context, OrdersScreen.routeName);
              },
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () async {
                await gv.getAllProds();
                print(gv.AllProds);
              },
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
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
        );
      }),
    );
  }
}

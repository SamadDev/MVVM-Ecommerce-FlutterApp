import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/profile/components/orders/ordersScreen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
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
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenHeight(32),
                            vertical: getProportionateScreenHeight(15)),
                        height: double.infinity,
                        width: double.infinity,
                        color: PrimaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'welcome,',
                                style: TextStyle(
                                    fontFamily: 'PantonBoldItalic',
                                    color: Colors.white,
                                    fontSize: getProportionateScreenWidth(23)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                gv.UserInfo['Full Name'],
                                style: TextStyle(
                                    fontFamily: 'PantonBoldItalic',
                                    color: Colors.white,
                                    fontSize: getProportionateScreenWidth(30)),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(32),
                          horizontal: getProportionateScreenWidth(25)),
                      decoration: BoxDecoration(
                        color: PrimaryLightColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        children: [
                          ProfButton("My Details", Icons.person_outline_rounded, () {}),
                          SizedBox(
                            height: getProportionateScreenHeight(25),
                          ),
                          ProfButton("My Orders", Icons.inventory_2_outlined, () {
                            Navigator.pushNamed(
                              context,
                              OrdersScreen.routeName,
                              arguments: OrderArguments(ordersID: gv.UserInfo['orders']),
                            );
                          }),
                          SizedBox(
                            height: getProportionateScreenHeight(25),
                          ),
                          ProfButton("Settings", Icons.settings_outlined, () {}),
                          SizedBox(
                            height: getProportionateScreenHeight(25),
                          ),
                          ProfButton("Log-Out", Icons.logout, () {
                            gv.selectedPage = 0;
                            print("Sign-Out of ${loggedInUser.email}");
                            context.read<AuthenticationService>().signOut();
                            Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                          }),
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

ElevatedButton ProfButton(String label, IconData icon, Function func) {
  return ElevatedButton.icon(
      onPressed: func,
      icon: Icon(
        icon,
        color: PrimaryColor,
        size: getProportionateScreenWidth(25),
      ),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "    $label",
            style: TextStyle(
                color: SecondaryColorDark,
                fontFamily: 'PantonBoldItalic',
                fontSize: getProportionateScreenWidth(15.5)),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: SecondaryColorDark,
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(21),
          primary: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/views/profile/components/orders/ordersScreen.dart';
import 'package:ecommerce_app/views/profile/components/userInfo/userInfo.dart';
import 'package:ecommerce_app/views/profile/components/profClone.dart';
import 'package:ecommerce_app/views/sign_in/SignInScreen.dart';
import '../../utils/size_config.dart';
import '../../view_models/auth_viewModel.dart';
import 'package:provider/provider.dart';
import '../../view_models/globalVariables_viewModel.dart';
import 'package:ecommerce_app/utils/SignInMessage.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User u;

  @override
  void initState() {
    u = Provider.of<auth_viewModel>(context, listen: false).CurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Consumer<globalVars>(builder: (_, gv, __) {
        return FutureBuilder(
            future: gv.getUserInfo(u),
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
                                  u.isAnonymous ? ' ' : 'Welcome',
                                  style: TextStyle(
                                      fontFamily: 'PantonBoldItalic',
                                      color: Colors.white,
                                      fontSize:
                                          getProportionateScreenWidth(20)),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  u.isAnonymous
                                      ? 'Welcome Back'
                                      : gv.UserInfo['Full Name'],
                                  maxLines: 3,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'PantonBoldItalic',
                                      color: Colors.white,
                                      fontSize:
                                          getProportionateScreenWidth(29)),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(30),
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
                            ProfButton(
                                "My Details", Icons.person_outline_rounded, () {
                              if (u.isAnonymous) {
                                return showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext bc) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: SignInMessage(),
                                      );
                                    });
                              } else {
                                Navigator.pushNamed(
                                        context, UserInfoScreen.routeName)
                                    .then((_) => setState(() {}));
                              }
                            }),
                            SizedBox(
                              height: getProportionateScreenHeight(25),
                            ),
                            ProfButton("My Orders", Icons.inventory_2_outlined,
                                () {
                              if (u.isAnonymous) {
                                return showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext bc) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: SignInMessage(),
                                      );
                                    });
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  OrdersScreen.routeName,
                                  arguments: OrderArguments(
                                      ordersID: gv.UserInfo['orders']),
                                );
                              }
                            }),
                            SizedBox(
                              height: getProportionateScreenHeight(25),
                            ),
                            ProfButton(u.isAnonymous ? "Sign-In" : "Log-Out",
                                u.isAnonymous ? Icons.login : Icons.logout, () {
                              if (u.isAnonymous) {
                                Navigator.pushNamed(
                                    context, SignInScreen.routeName);
                                Future.delayed(Duration(milliseconds: 700), () {
                                  gv.selectedPage = 0;
                                  gv.prodsBool(false);
                                });
                              } else {
                                print("Sign-Out of ${u.email}");
                                context.read<auth_viewModel>().signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                  (Route<dynamic> route) => false,
                                );

                                Future.delayed(Duration(milliseconds: 700), () {
                                  gv.selectedPage = 0;
                                  gv.prodsBool(false);
                                });
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return profClone(u: u);
              }

              return Container();
            });
      }),
    );
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
            "   $label",
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
}

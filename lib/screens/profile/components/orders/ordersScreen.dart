import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../globalVars.dart';
import 'package:provider/provider.dart';
import '../../../../Services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  User u;

  @override
  void initState() {
    u = Provider.of<AuthenticationService>(context, listen: false).CurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: PrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(
            color: SecondaryColor,
            fontSize: getProportionateScreenWidth(20),
            fontFamily: 'Panton',
          ),
        ),
        backgroundColor: SecondaryColorDark,
      ),
      body: Consumer<globalVars>(builder: (_, gv, __) {
        return FutureBuilder(
            future: gv.getUserOrders(u),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: CardBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 18,
                              color: Color(0xFFDADADA),
                            )
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Order ID: ${gv.OrdersID[1]}",
                            style: TextStyle(
                                color: SecondaryColorDark,
                                fontSize: 16,
                                fontFamily: 'PantonBoldItalic'),
                          ),
                          Text(DateFormat.yMMMd()
                              .add_jm()
                              .format(gv.Orders[1]["Date&Time"].toDate())
                              .toString()),
                          Divider(
                            thickness: 2,
                          ),
                          Text(gv.Orders[1]["Status"]),
                          Text(gv.Orders[1]["Total"].toString()),
                        ],
                      )),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(
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
      }),
    ));
  }
}

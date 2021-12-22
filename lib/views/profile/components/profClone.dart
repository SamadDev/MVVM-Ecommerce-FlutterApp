import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profClone extends StatelessWidget {
  final User u;
  const profClone({Key key, this.u}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          fontSize: getProportionateScreenWidth(20)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      u.isAnonymous ? 'Welcome Back' : ' ',
                      maxLines: 3,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'PantonBoldItalic',
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(29)),
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
                ProfButton("My Details", Icons.person_outline_rounded),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                ProfButton("My Orders", Icons.inventory_2_outlined),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                ProfButton(u.isAnonymous ? "Sign-In" : "Log-Out",
                    u.isAnonymous ? Icons.login : Icons.logout),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

ElevatedButton ProfButton(String label, IconData icon) {
  return ElevatedButton.icon(
      onPressed: () {},
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

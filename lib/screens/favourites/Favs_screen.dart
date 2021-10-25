import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import '../../../size_config.dart';

class FavScreen extends StatelessWidget {
  static String routeName = "/favs";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border_outlined,
              size: 90,
              color: PrimaryColor,
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              "No Favourite Items",
              style: TextStyle(
                  fontFamily: 'Panton', color: SecondaryColor, fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}

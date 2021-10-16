import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

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
            Text("No Favourite Items")
          ],
        ),
      ),
    );
  }
}

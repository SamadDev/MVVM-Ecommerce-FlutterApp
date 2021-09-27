import 'package:flutter/material.dart';
import 'checkOut.dart';

class checkOutScreen extends StatelessWidget {
  static String routeName = "/checkout";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: checkOut(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Check Out",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

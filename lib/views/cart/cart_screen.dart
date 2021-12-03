import 'package:flutter/material.dart';
import 'components/cartBody.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: cartBody(),
        bottomNavigationBar: CheckoutCard(),
      ),
    );
  }
}

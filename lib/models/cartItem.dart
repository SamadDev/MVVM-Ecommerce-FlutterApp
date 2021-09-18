import '../../../Services/Products_db.dart';
import 'package:flutter/material.dart';
import 'Product.dart';

class cartItem {
  final Product product;
  final int quantity;
  final String option1;
  final String uid;

  cartItem(
      {@required this.product,
      @required this.quantity,
      @required this.option1,
      @required this.uid});
}

import '../../../Services/Products_db.dart';
import 'package:flutter/material.dart';
import 'Product.dart';

class Cart {
  final Product product;
  final int numOfItem;
  final String option1;

  Cart(
      {@required this.product,
      @required this.numOfItem,
      @required this.option1});
}

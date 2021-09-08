import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final List<dynamic> images;
  final List<dynamic> colors;
  final int price;

  Product({
    @required this.id,
    @required this.images,
    @required this.colors,
    @required this.title,
    @required this.price,
  });
}

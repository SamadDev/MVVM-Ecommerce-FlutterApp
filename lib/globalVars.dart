import 'package:flutter/material.dart';
import 'package:shop_app/models/cartItem.dart';
import '../../../Services/Products_db.dart';
import '../../../Services/Users_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';

class globalVars with ChangeNotifier {
  globalVars._privateConstructor();

  static final globalVars _instance = globalVars._privateConstructor();

  factory globalVars() {
    return _instance;
  }

  final CollectionReference UsersInformation =
      FirebaseFirestore.instance.collection('UsersInfo');

  final product_dbServices _p = product_dbServices();
  var _CartProds;
  List<cartItem> _userCart = [];

  Future fillCartList(var CartProds) async {
    _userCart = [];
    await _p.getAllCategories();
    for (int i = 0; i < CartProds.length; i++) {
      await _p.getSpecificProd(CartProds[i]['id']);

      _userCart.add(cartItem(
          product: Product(
              id: _p.currentProd.id,
              images: _p.currentProd.images,
              colors: _p.currentProd.colors,
              title: _p.currentProd.title,
              price: _p.currentProd.price),
          quantity: CartProds[i]['quantity'],
          option1: CartProds[i]['option1'],
          uid: _p.currentProd.id + CartProds[i]['option1']));
    }
    print(_userCart);
  }

  Future getUserCart(User u) async {
    DocumentSnapshot documentSnapshot = await UsersInformation.doc(u.uid).get();
    _CartProds = documentSnapshot.get('cart');
    await fillCartList(_CartProds);
  }

  Future DeleteItemFromCart(User u, int index) async {
    DocumentReference docRef = UsersInformation.doc(u.uid);
    await docRef.update({
      'cart': FieldValue.arrayRemove([_CartProds[index]])
    });
  }

  void addToUserCart(Product p, int quantity, String option1) {
    _userCart.add(cartItem(
        product: p, quantity: quantity, option1: option1, uid: p.id + option1));
    notifyListeners();
  }

  void removeFromUserCart(int index) {
    _userCart.removeAt(index);
    notifyListeners();
  }

  product_dbServices get p => _p;

  List<cartItem> get userCart => _userCart;
}

import 'package:flutter/material.dart';
import 'package:shop_app/models/cartItem.dart';
import '../../../Services/Products_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int _total = 0;

  int _shippingPrice = 40;

  String _uName, _uPN, _uAddress, _uGovernorate;

  String _paymentMethod = "Select Method";

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
    TotalPrice();
  }

  Future getUserInfo(User u) async {
    DocumentSnapshot documentSnapshot = await UsersInformation.doc(u.uid).get();
    _uName = documentSnapshot.get('Full Name');
    _uPN = documentSnapshot.get('Phone Number');
    _uGovernorate = documentSnapshot.get('Governorate');
    _uAddress = documentSnapshot.get('Address');
    //notifyListeners();
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
    TotalPrice();
  }

  void removeFromUserCart(int index) {
    _userCart.removeAt(index);
    notifyListeners();
    TotalPrice();
  }

  void incrementQ(String uid) {
    for (int i = 0; i < _userCart.length; i++) {
      if (uid == _userCart[i].uid) {
        _userCart[i].quantity += 1;
      }
    }
    notifyListeners();
    TotalPrice();
  }

  void decrementQ(String uid) {
    for (int i = 0; i < _userCart.length; i++) {
      if (uid == _userCart[i].uid) {
        if (_userCart[i].quantity > 1) {
          _userCart[i].quantity -= 1;
        } else {
          _userCart[i].quantity = 1;
        }
      }
    }
    notifyListeners();
    TotalPrice();
  }

  void resetCart() {
    _userCart = [];
    notifyListeners();
  }

  void TotalPrice() {
    _total = _shippingPrice;
    for (int i = 0; i < _userCart.length; i++) {
      _total += (_userCart[i].product.price * _userCart[i].quantity);
    }
    notifyListeners();
  }

  Future addCartItems(User u, List<cartItem> c) async {
    for (int i = 0; i < c.length; i++) {
      Map map = new Map<String, dynamic>();
      return await UsersInformation.doc(u.uid).set({
        'cart': FieldValue.arrayUnion([
          map = {
            "id": c[i].product.id,
            "option1": c[i].option1,
            "quantity": c[i].quantity
          }
        ]),
      }, SetOptions(merge: true));
    }
  }

  void changePaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  product_dbServices get p => _p;

  int get total => _total;

  List<cartItem> get userCart => _userCart;

  get uGovernorate => _uGovernorate;

  get uAddress => _uAddress;

  get uPN => _uPN;

  get CartProds => _CartProds;

  int get shippingPrice => _shippingPrice;

  String get paymentMethod => _paymentMethod;

  String get uName => _uName;
}

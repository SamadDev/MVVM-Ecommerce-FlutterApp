import 'package:flutter/material.dart';
import 'package:shop_app/models/cartItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class globalVars with ChangeNotifier {
  globalVars._privateConstructor();

  static final globalVars _instance = globalVars._privateConstructor();

  factory globalVars() {
    return _instance;
  }

  final CollectionReference UsersInformation = FirebaseFirestore.instance.collection('UsersInfo');

  final CollectionReference OrdersRef = FirebaseFirestore.instance.collection('Orders');

  final DocumentReference ClothingInformation =
      FirebaseFirestore.instance.collection('Products').doc('Clothing');

  final CollectionReference ProductsInformation = FirebaseFirestore.instance.collection('Products');

  var _CartProds;

  List<dynamic> _OrdersID = [];

  List<Map<String, dynamic>> _Orders = [];

  List<String> _categories = [];

  Map<String, List<Product>> _AllProds = {'': []};

  List<cartItem> _userCart = [];

  int selectedPage = 0;

  int _total = 0;

  int _shippingPrice = 40;

  String _uName, _uPN, _uAddress, _uGovernorate;

  String _paymentMethod = "Select Method";

  Future getAllCategories() async {
    DocumentSnapshot doc = await ClothingInformation.get();
    _categories = List<String>.from(doc.get('Categories'));
    print(_categories);
  }

  Future getAllProds() async {
    _AllProds.clear();
    await getAllCategories();
    for (int i = 0; i < _categories.length; i++) {
      QuerySnapshot qSnapshot = await ClothingInformation.collection(_categories[i]).get();
      List<Product> catProds = [];
      for (int j = 0; j < qSnapshot.docs.length; j++) {
        catProds.add(Product(
            id: qSnapshot.docs[j].id,
            images: qSnapshot.docs[j]['images'],
            colors: qSnapshot.docs[j]['Colors'],
            title: qSnapshot.docs[j]['Title'],
            price: qSnapshot.docs[j]['Price']));
      }
      _AllProds[_categories[i]] = catProds;
    }
  }

  Product getSpecificProd(String id) {
    if (_AllProds.isNotEmpty) {
      for (int i = 0; i < _categories.length; i++) {
        for (int j = 0; j < _AllProds[_categories[i]].length; j++) {
          if (_AllProds[_categories[i]][j].id == id) {
            return _AllProds[_categories[i]][j];
          }
        }
      }
    } else {
      print("No Products");
    }
  }

  Future fillCartList(var CartProds) async {
    _userCart = [];
    await getAllProds();
    for (int i = 0; i < CartProds.length; i++) {
      Product tempProd = getSpecificProd(CartProds[i]['id']);
      print(tempProd);
      _userCart.add(cartItem(
          product: Product(
              id: tempProd.id,
              images: tempProd.images,
              colors: tempProd.colors,
              title: tempProd.title,
              price: tempProd.price),
          quantity: CartProds[i]['quantity'],
          option1: CartProds[i]['option1'],
          uid: tempProd.id + CartProds[i]['option1']));
    }
    print(_userCart);
  }

  Future getUserCart(User u) async {
    DocumentSnapshot documentSnapshot = await UsersInformation.doc(u.uid).get();
    _CartProds = documentSnapshot.get('cart');
    print(_CartProds);
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
    DocumentSnapshot documentSnapshot = await docRef.get();
    _CartProds = documentSnapshot.get('cart');
    await docRef.update({
      'cart': FieldValue.arrayRemove([_CartProds[index]])
    });
  }

  Future getUserOrders(User u) async {
    _OrdersID.clear();
    _Orders.clear();
    DocumentSnapshot uSnapshot = await UsersInformation.doc(u.uid).get();
    _OrdersID = await uSnapshot.get('orders');
    print(_OrdersID);

    if (_OrdersID.isNotEmpty) {
      for (int i = 0; i < _OrdersID.length; i++) {
        DocumentSnapshot oSnapshot = await OrdersRef.doc(_OrdersID[i]).get();
        Map<String, dynamic> temp = oSnapshot.data();
        temp["ID"] = oSnapshot.id;
        _Orders.add(temp);
      }
    } else {
      print("No Orders");
    }
    _Orders.sort((a, b) => b["Date&Time"].compareTo(a["Date&Time"]));
  }

  void addToUserCart(Product p, int quantity, String option1) {
    _userCart.add(cartItem(product: p, quantity: quantity, option1: option1, uid: p.id + option1));
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
    TotalPrice();
  }

  void TotalPrice() {
    if (_userCart.isEmpty) {
      _total = 0;
    } else {
      _total = _shippingPrice;
    }
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
          map = {"id": c[i].product.id, "option1": c[i].option1, "quantity": c[i].quantity}
        ]),
      }, SetOptions(merge: true));
    }
  }

  void changePaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  int get total => _total;

  List<cartItem> get userCart => _userCart;

  get uGovernorate => _uGovernorate;

  get uAddress => _uAddress;

  get uPN => _uPN;

  get CartProds => _CartProds;

  List<dynamic> get OrdersID => _OrdersID;

  List<Map<String, dynamic>> get Orders => _Orders;

  List<String> get categories => _categories;

  Map<String, List<Product>> get AllProds => _AllProds;

  int get shippingPrice => _shippingPrice;

  String get paymentMethod => _paymentMethod;

  String get uName => _uName;
}

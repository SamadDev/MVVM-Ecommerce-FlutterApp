import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Services/Products_db.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Product.dart';

class users_dbServices {
  final String uid;
  users_dbServices({this.uid});
  var CartProds;

  List<Cart> userCart = [];

  final product_dbServices p = new product_dbServices();

  final CollectionReference UsersInformation =
      FirebaseFirestore.instance.collection('UsersInfo');

  Future addUserData(String fullName, String phoneNumber, String governorate,
      String address) async {
    return await UsersInformation.doc(uid).set({
      'Full Name': fullName,
      'Phone Number': phoneNumber,
      'Governorate': governorate,
      'Address': address,
    }, SetOptions(merge: true));
  }

  Future addToCart(String id, String option1, int quantity) async {
    Map map = new Map<String, dynamic>();
    return await UsersInformation.doc(uid).set({
      'cart': FieldValue.arrayUnion([
        map = {"id": id, "option1": option1, "quantity": 1}
      ]),
    }, SetOptions(merge: true));
  }

  Future fillCartList(var CartProds) async {
    userCart = [];
    await p.getAllCategories();
    for (int i = 0; i < CartProds.length; i++) {
      await p.getSpecificProd(CartProds[i]['id']);
      userCart.add(Cart(
          product: Product(
              id: p.currentProd.id,
              images: p.currentProd.images,
              colors: p.currentProd.colors,
              title: p.currentProd.title,
              price: p.currentProd.price),
          numOfItem: CartProds[i]['quantity'],
          option1: CartProds[i]['option1']));
    }
    print(userCart);
  }

  Future getUserCart() async {
    DocumentSnapshot documentSnapshot = await UsersInformation.doc(uid).get();
    CartProds = documentSnapshot.get('cart');
    await fillCartList(CartProds);
  }
}

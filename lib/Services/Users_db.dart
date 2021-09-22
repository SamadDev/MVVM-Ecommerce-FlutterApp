import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Services/Products_db.dart';
import 'package:shop_app/models/cartItem.dart';

class users_dbServices {
  final String uid;
  users_dbServices({this.uid});

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
}

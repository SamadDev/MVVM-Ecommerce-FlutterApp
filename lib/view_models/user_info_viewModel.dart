import 'package:cloud_firestore/cloud_firestore.dart';

class user_info_viewModel {
  final String uid;
  user_info_viewModel({this.uid});

  final CollectionReference UsersInformation =
      FirebaseFirestore.instance.collection('UsersInfo');

  final CollectionReference Orders =
      FirebaseFirestore.instance.collection('Orders');

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

  Future DeleteAttribute(String attribute) async {
    DocumentReference docRef = UsersInformation.doc(uid);
    await docRef.update({attribute: FieldValue.delete()});
  }

  Future addToOrders(
      String orderID, List<dynamic> c, String paymentMethod, int total) async {
    return await Orders.doc(orderID).set({
      'userID': uid,
      'Status': "Ordered",
      'Payment method': paymentMethod,
      'Total': total,
      'cart': c,
      'Date&Time': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future addOrderToUser(String orderID) async {
    return await UsersInformation.doc(uid).set({
      'orders': FieldValue.arrayUnion([orderID])
    }, SetOptions(merge: true));
  }

  Future addToFavs(String prodID) async {
    return await UsersInformation.doc(uid).set({
      'Favorites': FieldValue.arrayUnion([prodID])
    }, SetOptions(merge: true));
  }

  Future removeFromFavs(String prodID) async {
    return await UsersInformation.doc(uid).set({
      'Favorites': FieldValue.arrayRemove([prodID])
    }, SetOptions(merge: true));
  }

  void addOrder(
      String orderID, List<dynamic> c, String paymentMethod, int total) {
    addToOrders(orderID, c, paymentMethod, total);
    addOrderToUser(orderID);
  }
}

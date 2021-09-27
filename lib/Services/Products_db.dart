import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/models/Product.dart';
import '../../../screens/cart/components/cartBody.dart';

class product_dbServices {
  final DocumentReference ClothingInformation =
      FirebaseFirestore.instance.collection('Products').doc('Clothing');

  Product currentProd;

  List<Product> CurrentCat = [];

  List<List<Product>> Categories = [];

  List<String> categories = [];

  Future getProdsOfCat(String category) async {
    QuerySnapshot querySnapshot =
        await ClothingInformation.collection(category).get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      CurrentCat.add(Product(
          id: a.id,
          images: a.get('images'),
          colors: a.get('Colors'),
          title: a.get('Title'),
          price: a.get('Price')));
    }
    print('Successfully Retrieved Products');
  }

  Future getSpecificProd(String id) async {
    for (int i = 0; i < categories.length; i++) {
      DocumentReference docRef =
          ClothingInformation.collection(categories[i]).doc(id);
      var d = await docRef.get();
      if (d.exists) {
        DocumentSnapshot doc = await docRef.get();
        currentProd = Product(
            id: id,
            images: doc.get('images'),
            colors: doc.get('Colors'),
            title: doc.get('Title'),
            price: doc.get('Price'));
        print(currentProd.title);
      } else {
        print('Wrong Category');
      }
    }
  }

  Future getAllCategories() async {
    DocumentSnapshot doc = await ClothingInformation.get();
    categories = List<String>.from(doc.get('Categories'));
    print(categories);
  }
}

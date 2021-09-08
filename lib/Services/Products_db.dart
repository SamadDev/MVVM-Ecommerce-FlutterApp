import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/Cart.dart';

class product_dbServices {
  final DocumentReference ClothingInformation =
      FirebaseFirestore.instance.collection('Products').doc('Clothing');

  Product currentProd;

  List<Product> CurrentCat = [];

  List<List<Product>> Categories = [];

  List<String> categories = [];

  List<Cart> userCart = [];

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

  /*
  Future getAllProds() async {
    for (int i = 0; i < categories.length; i++) {
      QuerySnapshot querySnapshot =
          await ClothingInformation.collection(categories[i]).get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        Categories[i].add(Product(
            id: a.id,
            images: a.get('images'),
            colors: a.get('Colors'),
            title: a.get('Title'),
            price: a.get('Price')));
      }
    }
    print(Categories.length);
  }
  */

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

  Future fillCartList(var CartProds) async {
    userCart = [];
    await getAllCategories();
    for (int i = 0; i < CartProds.length; i++) {
      await getSpecificProd(CartProds[i]['id']);
      userCart.add(Cart(
          product: Product(
              id: currentProd.id,
              images: currentProd.images,
              colors: currentProd.colors,
              title: currentProd.title,
              price: currentProd.price),
          numOfItem: CartProds[i]['quantity'],
          option1: CartProds[i]['option1']));
    }
    print(userCart);
  }
}

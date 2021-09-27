import 'package:flutter/material.dart';
import '../../../globalVars.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/size_config.dart';
import '../../../constants.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/Services/Users_db.dart';
import 'package:shop_app/Services/Products_db.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final Product product;
  const Body({Key key, @required this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> sizes = ['S', 'M', 'L', 'XL'];
  String size = 'S';
  User user;

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthenticationService>().CurrentUser();
    final product_dbServices p = context.read<globalVars>().p;
    final users_dbServices u = users_dbServices(uid: user.uid);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSizeOptions("S"),
                        buildSizeOptions("M"),
                        buildSizeOptions("L"),
                        buildSizeOptions("XL"),
                      ],
                    ),

                    //ColorDots(product: product),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenHeight(35),
                          top: getProportionateScreenHeight(12),
                        ),
                        child: Consumer<globalVars>(builder: (_, gv, __) {
                          return ElevatedButton(
                            onPressed: () async {
                              try {
                                await u.addToCart(widget.product.id, size, 1);
                                String temp = widget.product.id + size;
                                List<String> tempLsit = [];

                                for (int i = 0; i < gv.userCart.length; i++) {
                                  tempLsit.add(gv.userCart[i].uid);
                                }
                                if (!tempLsit.contains(temp)) {
                                  gv.addToUserCart(widget.product, 1, size);
                                } else {
                                  print("Already in Cart");
                                }
                              } catch (e) {
                                return e;
                              }
                            },
                            child: Text(
                              'Add To Cart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'PantonBoldItalic'),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(PrimaryColor),
                                fixedSize: MaterialStateProperty.all<Size>(Size(
                                    double.infinity,
                                    getProportionateScreenHeight(65))),
                                elevation: MaterialStateProperty.all<double>(0),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)))),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector buildSizeOptions(String s) {
    return GestureDetector(
      onTap: () {
        setState(() {
          size = s;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: AnimatedContainer(
          duration: defaultDuration,
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.all(8),
          height: getProportionateScreenWidth(48),
          width: getProportionateScreenWidth(48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: PrimaryColor.withOpacity(size == s ? 1 : 0)),
          ),
          child: Center(
            child: Text(
              s,
              style: TextStyle(
                  color: SecondaryColorDark,
                  fontSize: 15,
                  fontFamily: 'PantonBoldItalic'),
            ),
          ),
        ),
      ),
    );
  }
}

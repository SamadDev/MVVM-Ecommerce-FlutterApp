import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../size_config.dart';
import 'cart_card.dart';
import '../../../constants.dart';
import 'package:shop_app/Services/Users_db.dart';
import '../../../Services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/models/Cart.dart';
import '../../../Services/Products_db.dart';

class cartBody extends StatefulWidget {
  final _auth = FirebaseAuth.instance;
  User CurrentUser() {
    return _auth.currentUser;
  }

  @override
  _cartBodyState createState() => _cartBodyState();
}

class _cartBodyState extends State<cartBody> {
  users_dbServices u;
  Future builderr;

  @override
  void initState() {
    u = users_dbServices(uid: widget.CurrentUser().uid);
    builderr = guc();
    super.initState();
  }

  guc() async {
    return await u.getUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: FutureBuilder(
        future: builderr,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(u.userCart.length);
            return ListView.builder(
              itemCount: u.userCart.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      u.userCart.removeAt(index);
                    });
                  },
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset("assets/icons/Trash.svg"),
                      ],
                    ),
                  ),
                  child: CartCard(cart: u.userCart[index]),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Container(
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  child: CircularProgressIndicator(
                    color: SecondaryColorDark,
                  )),
            );

          return Container();
        },
      ),
    );
  }
}

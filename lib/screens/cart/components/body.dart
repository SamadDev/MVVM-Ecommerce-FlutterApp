import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../size_config.dart';
import 'cart_card.dart';
import '../../../constants.dart';
import 'package:shop_app/Services/Users_db.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';
import '../../../Services/Products_db.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    User user = context.read<AuthenticationService>().CurrentUser();
    final users_dbServices u = new users_dbServices(uid: user.uid);
    final product_dbServices p = new product_dbServices();

    user = context.read<AuthenticationService>().CurrentUser();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: FutureBuilder(
        future: u.getUserCart(),
        builder: (context, snapshot) {
          p.fillCartList(p.userCart);
          if (snapshot.connectionState == ConnectionState.done)
            return ListView.builder(
              itemCount: p.userCart.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                  key: Key(p.userCart[index].product.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      p.userCart.removeAt(index);
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
                  child: CartCard(cart: p.userCart[index]),
                ),
              ),
            );

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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../size_config.dart';
import 'cart_card.dart';
import '../../../constants.dart';
import '../../../Services/authentication.dart';
import '../../../globalVars.dart';

class cartBody extends StatefulWidget {
  @override
  cartBodyState createState() => cartBodyState();
}

class cartBodyState extends State<cartBody> {
  Future futureCart;
  User u;

  @override
  void initState() {
    u = Provider.of<AuthenticationService>(context, listen: false)
        .CurrentUser();
    Provider.of<globalVars>(context, listen: false).getUserInfo(u);
    futureCart = Provider.of<globalVars>(context, listen: false).getUserCart(u);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Consumer<globalVars>(builder: (_, gv, __) {
        return FutureBuilder(
          future: futureCart,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: gv.userCart.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        gv.removeFromUserCart(index);
                      });
                      gv.DeleteItemFromCart(u, index);
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
                    child: CartCard(cart: gv.userCart[index]),
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
        );
      }),
    );
  }
}

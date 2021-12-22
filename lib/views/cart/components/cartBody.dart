import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/size_config.dart';
import 'cart_card.dart';
import '../../../utils/constants.dart';
import '../../../view_models/auth_viewModel.dart';
import '../../../view_models/globalVariables_viewModel.dart';

class cartBody extends StatefulWidget {
  @override
  cartBodyState createState() => cartBodyState();
}

class cartBodyState extends State<cartBody> {
  Future futureCart;
  User u;

  @override
  void initState() {
    u = Provider.of<auth_viewModel>(context, listen: false).CurrentUser();
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
              if (gv.userCart.isNotEmpty) {
                return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(22)),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                      ),
                      SizedBox(height: getProportionateScreenHeight(15)),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/EmptyCart.svg",
                        color: PrimaryColor,
                        height: getProportionateScreenWidth(70),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Text(
                        "Your Cart is Empty",
                        style: TextStyle(
                            fontFamily: 'Panton',
                            color: SecondaryColor,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/EmptyCart.svg",
                      color: PrimaryColor,
                      height: getProportionateScreenWidth(70),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Text(
                      "Your Cart is Empty",
                      style: TextStyle(
                          fontFamily: 'Panton',
                          color: SecondaryColor,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              );

            return Container();
          },
        );
      }),
    );
  }
}

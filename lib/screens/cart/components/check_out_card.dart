import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/Services/Users_db.dart';
import 'package:shop_app/globalVars.dart';
import 'package:shop_app/screens/checkOut/checkOut_screen.dart';
import '../../checkOut/checkOut.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Services/Products_db.dart';
import '../../../globalVars.dart';
import 'package:shop_app/screens/checkOut/checkout_bottom_sheet.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product_dbServices p = new product_dbServices();
    User user = context.read<AuthenticationService>().CurrentUser();
    final users_dbServices u = new users_dbServices(uid: user.uid);
    globalVars g = globalVars();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(20),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.95),
          )
        ],
      ),
      child: Consumer<globalVars>(builder: (_, gv, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                text: "Total:\n",
                style: TextStyle(
                    color: SecondaryColorDark,
                    fontSize: 12,
                    fontFamily: 'PantonBoldItalic'),
                children: [
                  TextSpan(
                    text: "${gv.total} EGP",
                    style: TextStyle(
                        color: PrimaryColor,
                        fontSize: 20,
                        fontFamily: 'PantonBoldItalic'),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(190),
              child: DefaultButton(
                text: "Checkout",
                press: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext bc) {
                        return CheckoutBottomSheet();
                      });
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

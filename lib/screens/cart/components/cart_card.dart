import 'package:flutter/material.dart';
import 'package:shop_app/globalVars.dart';
import 'package:shop_app/models/cartItem.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../Services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final cartItem cart;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    User user = context.read<AuthenticationService>().CurrentUser();
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(widget.cart.product.images[0].toString()),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cart.product.title,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PantonItalic'),
              ),
              Text(
                widget.cart.option1,
                style: TextStyle(
                    color: SecondaryColorDark,
                    fontSize: 14,
                    fontFamily: 'PantonBoldItalic'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.cart.product.price} EGP",
                    style: TextStyle(
                        color: PrimaryColor,
                        fontSize: 16,
                        fontFamily: 'PantonBoldItalic'),
                  ),
                  Consumer<globalVars>(builder: (_, gv, __) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () => gv.decrementQ(widget.cart.uid),
                          icon: Icon(Icons.remove),
                          color: PrimaryColor,
                          enableFeedback: false,
                        ),
                        Text(
                          "${widget.cart.quantity}",
                          style: TextStyle(fontFamily: 'PantonBoldItalic'),
                        ),
                        IconButton(
                          onPressed: () => gv.incrementQ(widget.cart.uid),
                          icon: Icon(Icons.add),
                          color: PrimaryColor,
                          enableFeedback: false,
                        )
                      ],
                    );
                  }),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

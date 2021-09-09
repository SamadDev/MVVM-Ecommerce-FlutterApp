import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
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
              child: Image.network(cart.product.images[0].toString()),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.product.title,
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
                cart.option1,
                style: TextStyle(
                    color: SecondaryColorDark,
                    fontSize: 14,
                    fontFamily: 'PantonBoldItalic'),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "${cart.product.price} EGP",
                  style: TextStyle(
                      color: PrimaryColor,
                      fontSize: 16,
                      fontFamily: 'PantonBoldItalic'),
                  children: [
                    TextSpan(
                        text: " x${cart.numOfItem}",
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

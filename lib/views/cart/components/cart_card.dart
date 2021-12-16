import 'package:flutter/material.dart';
import 'package:ecommerce_app/view_models/globalVariables_viewModel.dart';
import 'package:ecommerce_app/models/cartItem.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: CardBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.cart.product.images[0].toString(),
                memCacheHeight: 500,
                memCacheWidth: 500,
                maxHeightDiskCache: 500,
                maxWidthDiskCache: 500,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SizedBox(
                  width: getProportionateScreenWidth(4),
                  height: getProportionateScreenWidth(4),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      strokeWidth: 4,
                      color: PrimaryLightColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
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

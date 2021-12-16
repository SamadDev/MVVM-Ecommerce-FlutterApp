import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/views/prodDetails/details_screen.dart';
import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.width = 140,
    this.aspectRetio = 1.02,
    @required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(width),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: ProductDetailsArguments(product: product),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                  color: CardBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Hero(
                  tag: UniqueKey(),
                  child: CachedNetworkImage(
                    imageUrl: product.images[0].toString(),
                    memCacheHeight: 800,
                    memCacheWidth: 800,
                    maxHeightDiskCache: 800,
                    maxWidthDiskCache: 800,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SizedBox(
                      width: getProportionateScreenWidth(6),
                      height: getProportionateScreenWidth(6),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          strokeWidth: 5,
                          color: PrimaryLightColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(6.5)),
            Text(product.title,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black)),
            Text(
              "${product.price} EGP",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                fontFamily: 'PantonBold',
                color: PrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

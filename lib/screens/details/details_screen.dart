import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import '../../models/Product.dart';
import 'components/detailsBody.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context).settings.arguments;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: PrimaryLightColor,
        //appBar: CustomAppBar(),
        body: Body(product: agrs.product),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 13),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/icons/Back ICon.svg",
              height: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  ProductDetailsArguments({@required this.product});
}

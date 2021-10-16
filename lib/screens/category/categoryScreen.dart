import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import '../../models/Product.dart';
import '../../../size_config.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:provider/provider.dart';
import '../../../globalVars.dart';

class CategoryScreen extends StatelessWidget {
  static String routeName = "/category";

  @override
  Widget build(BuildContext context) {
    final CategoryDetailsArguments args = ModalRoute.of(context).settings.arguments;
    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: PrimaryLightColor,
          appBar: AppBar(
            title: Text(
              args.category,
              style: TextStyle(
                color: SecondaryColor,
                fontSize: getProportionateScreenWidth(20),
                fontFamily: 'Panton',
              ),
            ),
            backgroundColor: SecondaryColorDark,
          ),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Consumer<globalVars>(builder: (_, gv, __) {
              return GridView.count(
                childAspectRatio:
                    MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.35),
                crossAxisSpacing: 25,
                crossAxisCount: 2,
                children: List.generate(
                  gv.AllProds[args.category].length,
                  (index) {
                    return ProductCard(product: gv.AllProds[args.category][index]);
                  },
                ),
              );
            }),
          ),
        ));
  }
}

class CategoryDetailsArguments {
  final String category;
  CategoryDetailsArguments({@required this.category});
}

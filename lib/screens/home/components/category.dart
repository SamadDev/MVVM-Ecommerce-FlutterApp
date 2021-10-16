import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/screens/category/categoryScreen.dart';
import '../../../size_config.dart';
import 'section_title.dart';
import '../../../constants.dart';
import 'package:provider/provider.dart';
import '../../../globalVars.dart';

class category extends StatelessWidget {
  final String cat;

  category({@required this.cat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: cat,
              press: () {
                Navigator.pushNamed(
                  context,
                  CategoryScreen.routeName,
                  arguments: CategoryDetailsArguments(category: cat),
                );
              }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Consumer<globalVars>(builder: (_, gv, __) {
            return Row(
              children: [
                ...List.generate(
                  gv.AllProds[cat].length < 5 ? gv.AllProds[cat].length : 5,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ProductCard(product: gv.AllProds[cat][index]),
                    );
                  },
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
              ],
            );
          }),
        )
      ],
    );
  }
}

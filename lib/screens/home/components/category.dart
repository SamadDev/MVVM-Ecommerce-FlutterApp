import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import '../../../Services/Products_db.dart';
import '../../../size_config.dart';
import 'section_title.dart';
import '../../../constants.dart';

class category extends StatelessWidget {
  final String cat;
  final product_dbServices p = new product_dbServices();

  category({@required this.cat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: cat, press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder(
            future: p.getProdsOfCat(cat),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Row(
                  children: [
                    ...List.generate(
                      p.CurrentCat.length,
                      (index) {
                        return ProductCard(product: p.CurrentCat[index]);
                      },
                    ),
                    SizedBox(width: getProportionateScreenWidth(20)),
                  ],
                );

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
          ),
        )
      ],
    );
  }
}

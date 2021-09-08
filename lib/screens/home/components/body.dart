import 'package:flutter/material.dart';
import '../../../Services/Products_db.dart';
import '../../../size_config.dart';
import 'categories.dart';
import '../../../constants.dart';
import 'home_header.dart';
import 'category.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  final product_dbServices p = new product_dbServices();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            //DiscountBanner(),
            Categories(),
            SpecialOffers(),
            SizedBox(height: getProportionateScreenWidth(30)),
            FutureBuilder(
              future: p.getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: List.generate(p.categories.length,
                        (index) => category(cat: p.categories[index])),
                  );
                }

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
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}

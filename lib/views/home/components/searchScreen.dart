import 'package:ecommerce_app/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/utils/size_config.dart';
import 'package:ecommerce_app/models/product_card.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/view_models/globalVariables_viewModel.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = "/search";

  @override
  Widget build(BuildContext context) {
    final SearchKeyword args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: PrimaryLightColor,
      appBar: AppBar(
        elevation: 5,
        shadowColor: SecondaryColorDark.withOpacity(0.2),
        iconTheme: IconThemeData(color: SecondaryColorDark),
        title: Text(
          args.keyword,
          style: TextStyle(
            color: SecondaryColorDark,
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.w900,
            fontFamily: 'Panton',
          ),
        ),
        backgroundColor: CardBackgroundColor,
      ),
      body: Consumer<globalVars>(builder: (_, gv, __) {
        List<Product> _searchList = [];

        gv.AllProds.forEach((key, value) {
          value.forEach((element) {
            if (element.title
                .toUpperCase()
                .contains(args.keyword.toUpperCase())) {
              _searchList.add(element);
            }
          });
        });

        return _searchList.isNotEmpty
            ? GridView.count(
                padding: EdgeInsets.all(getProportionateScreenWidth(25)),
                childAspectRatio:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.5)
                        : MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.35),
                crossAxisSpacing: getProportionateScreenWidth(25),
                crossAxisCount: 2,
                children: List.generate(
                  _searchList.length,
                  (index) {
                    return ProductCard(product: _searchList[index]);
                  },
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied_rounded,
                      size: 90,
                      color: PrimaryColor,
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      "No Products Found",
                      style: TextStyle(
                          fontFamily: 'Panton',
                          color: SecondaryColor,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              );
      }),
    );
  }
}

class SearchKeyword {
  final String keyword;
  SearchKeyword({@required this.keyword});
}

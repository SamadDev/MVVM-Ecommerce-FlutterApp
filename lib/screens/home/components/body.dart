import 'package:flutter/material.dart';
import '../../../Services/Products_db.dart';
import '../../../size_config.dart';
import 'categories.dart';
import '../../../constants.dart';
import 'home_header.dart';
import 'category.dart';
import 'special_offers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final product_dbServices p = new product_dbServices();

  bool connection;

  Future connection_checker() async {
    connection = await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: connection_checker(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (connection == true) {
                    return FutureBuilder(
                        future: p.getAllCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenHeight(20)),
                                HomeHeader(),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                Categories(),
                                SpecialOffers(),
                                SizedBox(
                                    height: getProportionateScreenWidth(30)),
                                Column(
                                  children: List.generate(
                                      p.categories.length,
                                      (index) =>
                                          category(cat: p.categories[index])),
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(30))
                              ],
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: Container(
                                  height: getProportionateScreenWidth(40),
                                  width: getProportionateScreenWidth(40),
                                  child: CircularProgressIndicator(
                                    color: SecondaryColorDark,
                                  )),
                            );
                          return Container();
                        });
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: SecondaryColor,
                                size: 23,
                              ),
                              Text(
                                '    No Internet Connection',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: SecondaryColor,
                                    fontFamily: 'PantonBoldItalic'),
                              ),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                          onPressed: () => setState(() {}),
                          icon: Icon(
                            Icons.replay_circle_filled,
                            color: PrimaryColor,
                          ),
                          iconSize: 53,
                        )
                      ],
                    );
                    print('No Internet');
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                        height: getProportionateScreenWidth(40),
                        width: getProportionateScreenWidth(40),
                        child: CircularProgressIndicator(
                          color: SecondaryColorDark,
                        )),
                  );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}

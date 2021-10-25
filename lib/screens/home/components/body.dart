import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'categories.dart';
import '../../../constants.dart';
import 'home_header.dart';
import 'category.dart';
import 'package:provider/provider.dart';
import '../../../globalVars.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeBody extends StatefulWidget {
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
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
                    return Consumer<globalVars>(builder: (_, gv, __) {
                      return FutureBuilder(
                          future: Future.wait([gv.getAllProds(), gv.getHomeImages()]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Column(
                                children: [
                                  SizedBox(height: getProportionateScreenHeight(20)),
                                  HomeHeader(),
                                  SizedBox(height: getProportionateScreenWidth(10)),
                                  Categories(),
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      viewportFraction: 0.9,
                                      autoPlay: true,
                                      aspectRatio: 1.7,
                                      enlargeCenterPage: true,
                                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                                    ),
                                    items: gv.imgList
                                        .map((item) => Container(
                                              child: Container(
                                                margin: EdgeInsets.all(7.5),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(
                                                      getProportionateScreenWidth(10))),
                                                  child: Image.network(item,
                                                      fit: BoxFit.cover, width: double.infinity),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  Column(
                                    children: List.generate(gv.categories.length,
                                        (index) => category(cat: gv.categories[index])),
                                  ),
                                  SizedBox(height: getProportionateScreenWidth(30))
                                ],
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
                          });
                    });
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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

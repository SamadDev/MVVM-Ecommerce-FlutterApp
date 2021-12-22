import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';
import 'categories.dart';
import '../../../utils/constants.dart';
import '../../../models/category.dart';
import 'package:provider/provider.dart';
import '../../../view_models/globalVariables_viewModel.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/search_field.dart';
import 'package:shimmer/shimmer.dart';

class HomeBody extends StatefulWidget {
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Future _futureProds;
  Future _futureHomeImages;
  bool _connection;

  @override
  void initState() {
    _futureProds =
        Provider.of<globalVars>(context, listen: false).getAllProds();
    _futureHomeImages =
        Provider.of<globalVars>(context, listen: false).getHomeImages();
    super.initState();
  }

  Future connection_checker() async {
    _connection = await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: connection_checker(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_connection == true) {
                  return Consumer<globalVars>(builder: (_, gv, __) {
                    return FutureBuilder(
                        future: Future.wait([_futureProds, _futureHomeImages]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenHeight(15)),
                                SearchField(),
                                SizedBox(
                                    height: getProportionateScreenWidth(5)),
                                Categories(),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 0.9,
                                    autoPlay: true,
                                    aspectRatio: 1.7,
                                    enlargeCenterPage: true,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.height,
                                  ),
                                  items: gv.imgList
                                      .map((item) => Container(
                                            child: Container(
                                              margin: EdgeInsets.all(7.5),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        getProportionateScreenWidth(
                                                            10))),
                                                child: CachedNetworkImage(
                                                    imageUrl: item,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            SizedBox(
                                                              width:
                                                                  getProportionateScreenWidth(
                                                                      6),
                                                              height:
                                                                  getProportionateScreenWidth(
                                                                      6),
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress,
                                                                  strokeWidth:
                                                                      5,
                                                                  color:
                                                                      PrimaryLightColor,
                                                                  backgroundColor:
                                                                      CardBackgroundColor,
                                                                ),
                                                              ),
                                                            ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    placeholderFadeInDuration:
                                                        Duration.zero,
                                                    width: double.infinity),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                Column(
                                  children: List.generate(
                                      gv.categories.length,
                                      (index) =>
                                          category(cat: gv.categories[index])),
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(30))
                              ],
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(15)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenWidth(20)),
                                      child: Container(
                                        width: double.infinity,
                                        height: getProportionateScreenWidth(42),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: getProportionateScreenWidth(6)),
                                    Padding(
                                      padding: EdgeInsets.all(
                                          getProportionateScreenWidth(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                          5,
                                          (index) => SizedBox(
                                            width:
                                                getProportionateScreenWidth(55),
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                  getProportionateScreenWidth(
                                                      13)),
                                              height:
                                                  getProportionateScreenWidth(
                                                      55),
                                              width:
                                                  getProportionateScreenWidth(
                                                      55),
                                              decoration: BoxDecoration(
                                                color: PrimaryColor.withOpacity(
                                                    0.2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenWidth(25)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenWidth(20)),
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            getProportionateScreenWidth(205),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  getProportionateScreenWidth(
                                                      10))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          return Container();
                        });
                  });
                } else {
                  return Center(
                    child: Column(
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
                                '   No Internet Connection',
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
                    ),
                  );
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
    );
  }
}

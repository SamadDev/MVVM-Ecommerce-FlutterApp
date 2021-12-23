import 'package:flutter/material.dart';
import 'package:ecommerce_app/utils/size_config.dart';
import 'categories.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/view_models/globalVariables_viewModel.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/views/home/components/searchBar.dart';
import 'package:ecommerce_app/views/home/components/homeShimmer.dart';

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
      child: Center(
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
                                  searchBar(),
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
                                ConnectionState.waiting) return homeShimmer();
                            return Container();
                          });
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
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return homeShimmer();
                }
                return Container();
              }),
        ),
      ),
    );
  }
}

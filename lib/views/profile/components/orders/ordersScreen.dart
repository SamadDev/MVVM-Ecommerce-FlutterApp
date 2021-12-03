import 'package:flutter/material.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/size_config.dart';
import '../../../../view_models/globalVariables_viewModel.dart';
import 'package:provider/provider.dart';
import '../../../../view_models/auth_viewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'process_timeline.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  User _u;
  bool _connection;

  Future connection_checker() async {
    _connection = await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    _u = Provider.of<auth_viewModel>(context, listen: false).CurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: PrimaryLightColor,
      appBar: AppBar(
        elevation: 5,
        shadowColor: SecondaryColorDark.withOpacity(0.2),
        iconTheme: IconThemeData(color: SecondaryColorDark),
        title: Text(
          "My Orders",
          style: TextStyle(
            color: SecondaryColorDark,
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.w900,
            fontFamily: 'Panton',
          ),
        ),
        backgroundColor: CardBackgroundColor,
      ),
      body: FutureBuilder(
          future: connection_checker(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (_connection == true) {
                return Consumer<globalVars>(builder: (_, gv, __) {
                  return FutureBuilder(
                      future: gv.getUserOrders(args.ordersID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                              padding: EdgeInsets.only(bottom: 25),
                              itemCount: gv.Orders.length,
                              itemBuilder: (context, index) => orderContainer(gv, index));
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
                        '   No Internet Connection',
                        style: TextStyle(
                            fontSize: 16, color: SecondaryColor, fontFamily: 'PantonBoldItalic'),
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
          }),
    );
  }

  Widget orderContainer(globalVars gv, int Oindex) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(right: 25, left: 25, top: 25),
        //padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: CardBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                color: Color(0xFFDADADA),
              )
            ]),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Order ID: ${gv.Orders[Oindex]["ID"]}",
                    style: TextStyle(
                        color: SecondaryColorDark,
                        fontSize: getProportionateScreenWidth(13),
                        fontFamily: 'PantonBoldItalic'),
                  ),
                  Text(
                    DateFormat.yMMMd()
                        .add_jm()
                        .format(gv.Orders[Oindex]["Date&Time"].toDate())
                        .toString(),
                    style: TextStyle(fontSize: getProportionateScreenWidth(12)),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: getProportionateScreenHeight(142)),
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: (gv.Orders[Oindex]["cart"] as List<dynamic>).length,
                        itemBuilder: (context, index) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '${gv.Orders[Oindex]["cart"][index]["option1"]} - ${gv.getSpecificProd(gv.Orders[Oindex]["cart"][index]["id"]).title}',
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: getProportionateScreenWidth(12.5)),
                              ),
                              leading: Stack(alignment: Alignment.bottomRight, children: [
                                Container(
                                  padding: EdgeInsets.all(3.5),
                                  height: getProportionateScreenWidth(50),
                                  width: getProportionateScreenWidth(50),
                                  decoration: BoxDecoration(
                                    color: PrimaryLightColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: gv
                                        .getSpecificProd(gv.Orders[Oindex]["cart"][index]["id"])
                                        .images[0]
                                        .toString(),
                                    memCacheHeight: 200,
                                    memCacheWidth: 200,
                                    maxHeightDiskCache: 200,
                                    maxWidthDiskCache: 200,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        SizedBox(
                                      width: getProportionateScreenWidth(0.1),
                                      height: getProportionateScreenWidth(0.1),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          strokeWidth: 3,
                                          color: PrimaryLightColor,
                                          backgroundColor: CardBackgroundColor,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 1.5, horizontal: 4.0),
                                    child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: getProportionateScreenWidth(14),
                                                fontFamily: 'PantonBoldItalic',
                                                color: PrimaryColor),
                                            children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${gv.Orders[Oindex]["cart"][index]["quantity"].toString()}"),
                                          TextSpan(
                                              text: "x",
                                              style: TextStyle(
                                                  fontSize: getProportionateScreenWidth(9))),
                                        ])))
                              ]),
                              trailing: Text(
                                gv.Orders[Oindex]["cart"][index]["total"].toString(),
                                style: TextStyle(fontSize: getProportionateScreenWidth(13)),
                              ),
                            )),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(5),
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(15),
                              fontFamily: 'PantonBoldItalic',
                              color: SecondaryColorDark),
                          children: <TextSpan>[
                        TextSpan(text: "Total :   "),
                        TextSpan(
                            text: "${gv.Orders[Oindex]["Total"].toString()}",
                            style: TextStyle(color: PrimaryColor)),
                        TextSpan(
                            text: "EGP",
                            style: TextStyle(
                                color: PrimaryColor, fontSize: getProportionateScreenWidth(11))),
                      ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 23),
              child: SizedBox(
                height: getProportionateScreenHeight(80),
                child: ProcessTimelinePage(gv.Orders[Oindex]["Status"].toString()),
              ),
            )
          ],
        ));
  }
}

class OrderArguments {
  final List<dynamic> ordersID;
  OrderArguments({@required this.ordersID});
}

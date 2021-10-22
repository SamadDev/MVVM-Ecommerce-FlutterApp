import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../globalVars.dart';
import 'package:provider/provider.dart';
import '../../../../Services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'process_timeline.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  User u;

  @override
  void initState() {
    u = Provider.of<AuthenticationService>(context, listen: false).CurrentUser();
    super.initState();
  }

  Widget orders(globalVars gv, List<dynamic> ordersID) {
    if (gv.Orders.isEmpty) {
      return FutureBuilder(
          future: gv.getUserOrders(ordersID),
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
    } else {
      return ListView.builder(
          padding: EdgeInsets.only(bottom: 25),
          itemCount: gv.Orders.length,
          itemBuilder: (context, index) => orderContainer(gv, index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderArguments args = ModalRoute.of(context).settings.arguments;
    return SafeArea(
        child: Scaffold(
      backgroundColor: PrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(
            color: SecondaryColor,
            fontSize: getProportionateScreenWidth(20),
            fontFamily: 'Panton',
          ),
        ),
        backgroundColor: SecondaryColorDark,
      ),
      body: Consumer<globalVars>(builder: (_, gv, __) {
        return orders(gv, args.ordersID);
      }),
    ));
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
                  SingleChildScrollView(
                      child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: getProportionateScreenHeight(152)),
                    child: ListView.builder(
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
                                  child: Image.network(gv
                                      .getSpecificProd(gv.Orders[Oindex]["cart"][index]["id"])
                                      .images[0]
                                      .toString()),
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
                  )),
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

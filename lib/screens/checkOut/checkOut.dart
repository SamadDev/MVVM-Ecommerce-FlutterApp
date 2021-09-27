import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../size_config.dart';
import '../cart/components/cart_card.dart';
import '../../constants.dart';
import '../../Services/authentication.dart';
import '../../globalVars.dart';

class checkOut extends StatefulWidget {
  @override
  checkOutState createState() => checkOutState();
}

class checkOutState extends State<checkOut> {
  Future futureInfo;

  @override
  void initState() {
    User u = Provider.of<AuthenticationService>(context, listen: false)
        .CurrentUser();
    futureInfo = Provider.of<globalVars>(context, listen: false).getUserInfo(u);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<globalVars>(builder: (_, gv, __) {
      return FutureBuilder(
          future: futureInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(20),
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(30), //border corner radius
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5), //color of shadow
                            spreadRadius: 5, //spread radius
                            blurRadius: 7, // blur radius
                            offset: Offset(0, 2), // changes position of shadow
                            //first paramerter of offset is left-right
                            //second parameter is top to down
                          ),
                          //you can set more BoxShadow() here
                        ],
                      ),
                      child: Text(
                        "Box Shadow on Container",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
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
  }
}

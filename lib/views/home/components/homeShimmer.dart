import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class homeShimmer extends StatelessWidget {
  const homeShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Color(0xfff6f6f6),
        highlightColor: Colors.grey.shade400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              width: double.infinity,
              height: getProportionateScreenWidth(45),
              decoration: BoxDecoration(
                color: PrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(26)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  5,
                  (index) => SizedBox(
                    width: getProportionateScreenWidth(55),
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(13)),
                      height: getProportionateScreenWidth(55),
                      width: getProportionateScreenWidth(55),
                      decoration: BoxDecoration(
                        color: PrimaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(46)),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              width: double.infinity,
              height: getProportionateScreenWidth(205),
              decoration: BoxDecoration(
                color: PrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.all(
                    Radius.circular(getProportionateScreenWidth(10))),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(31)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: getProportionateScreenWidth(90),
                    height: getProportionateScreenWidth(17),
                    decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                          Radius.circular(getProportionateScreenWidth(5))),
                    ),
                  ),
                  Container(
                    width: getProportionateScreenWidth(50),
                    height: getProportionateScreenWidth(15),
                    decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                          Radius.circular(getProportionateScreenWidth(5))),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(11)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    3,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Container(
                          width: getProportionateScreenWidth(140),
                          height: getProportionateScreenWidth(140),
                          decoration: BoxDecoration(
                            color: PrimaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(65)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: getProportionateScreenWidth(90),
                    height: getProportionateScreenWidth(18),
                    decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                          Radius.circular(getProportionateScreenWidth(5))),
                    ),
                  ),
                  Container(
                    width: getProportionateScreenWidth(50),
                    height: getProportionateScreenWidth(15),
                    decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                          Radius.circular(getProportionateScreenWidth(5))),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    3,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Container(
                          width: getProportionateScreenWidth(140),
                          height: getProportionateScreenWidth(140),
                          decoration: BoxDecoration(
                            color: PrimaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              ),
            ),
          ],
        ));
  }
}

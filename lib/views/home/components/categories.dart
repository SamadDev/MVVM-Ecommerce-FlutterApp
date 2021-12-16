import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/views/category/categoryScreen.dart';
import '../../../utils/size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/tshirt.svg", "text": "Tshirts"},
      {"icon": "assets/icons/hoodie.svg", "text": "Hoodies"},
      {"icon": "assets/icons/jacket_1.svg", "text": "Jackets"},
      {"icon": "assets/icons/jeans.svg", "text": "Pants"},
      {"icon": "assets/icons/sneaker.svg", "text": "Shoes"},
    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {
              Navigator.pushNamed(
                context,
                CategoryScreen.routeName,
                arguments: CategoryDetailsArguments(
                    category: categories[index]["text"]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(13)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: PrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                icon,
                color: PrimaryColor,
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(7)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'PantonBold',
                  fontSize: getProportionateScreenWidth(10),
                  color: SecondaryColorDark),
            )
          ],
        ),
      ),
    );
  }
}

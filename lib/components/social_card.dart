import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';
import 'size_config.dart';

class SocalCard extends StatelessWidget {
  const SocalCard({
    Key key,
    this.icon,
    this.press,
  }) : super(key: key);

  final String icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press as void Function(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        padding: EdgeInsets.all(getProportionateScreenWidth(13)),
        height: getProportionateScreenHeight(45),
        width: getProportionateScreenWidth(45),
        decoration: BoxDecoration(
          color: CardBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon, color: PrimaryColor),
      ),
    );
  }
}

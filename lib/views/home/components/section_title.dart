import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'PantonBoldItalic',
            fontSize: getProportionateScreenWidth(20),
            color: SecondaryColorDark,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            "See All",
            style: TextStyle(
                color: PrimaryColor,
                fontFamily: 'PantonBold',
                fontSize: getProportionateScreenWidth(13)),
          ),
        ),
      ],
    );
  }
}

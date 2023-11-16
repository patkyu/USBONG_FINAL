import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/screens/search/SearchScreen.dart';

class SearchComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
      width: context.width(),
      child: Text(language.search_Plants+'...', style: secondaryTextStyle()),
    ).onTap(() {
      push(SearchScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
    }, borderRadius: radius());
  }
}

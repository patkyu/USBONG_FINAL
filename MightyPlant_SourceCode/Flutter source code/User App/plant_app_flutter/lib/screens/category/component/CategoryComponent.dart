import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/category/CategoryResponse.dart';
import 'package:plant_flutter/screens/category/SubCategoryProductScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';

class CategoryComponent extends StatelessWidget {
  final CategoryResponse value;

  CategoryComponent({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(35), border: Border.all(color: context.dividerColor)),
          padding: EdgeInsets.all(8),
          child: Hero(
            tag: value.term_id.toString(),
            child: cachedImage(value.image,    width: 60,
                height: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(30),
          ),
        ),
        8.height,
        Text(value.name.validate(), style: boldTextStyle(size: 14)),
      ],
    ).onTap(() {
      push(SubCategoryProductScreen(parentCategory: value), pageRouteAnimation: PageRouteAnimation.Fade, duration: 800.milliseconds);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';

Widget headerComponent(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    width: context.width(),
    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
    decoration: boxDecorationDefault(color: context.cardColor),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: boxDecorationDefault(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor, width: 4),
          ),
          child: cachedImage(userStore.userImage.isNotEmpty ? userStore.userImage : "", height: 100, width: 100, fit: BoxFit.cover, radius: 50).cornerRadiusWithClipRRect(55),
        ),
        16.height,
        Text(userStore.userName, style: boldTextStyle(size: 20)),
        4.height,
        Text(userStore.userEmail, style: secondaryTextStyle()),
      ],
    ),
  );
}

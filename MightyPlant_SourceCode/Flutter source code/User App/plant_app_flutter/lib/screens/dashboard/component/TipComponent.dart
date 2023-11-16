import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/images.dart';

class TipComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(color: unSelectedColor, borderRadius: radius()),
      child: Stack(
        children: [
          Row(
            children: [
              Icon(Ionicons.flower,color: Colors.white),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.tips_and_Plant_Care, style: boldTextStyle(color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1),
                  Text(language.find_Tips_For_Keeping_Your_Plants_Alive, style: secondaryTextStyle(color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 2),
                ],
              ).expand()
            ],
          ).paddingOnly(bottom: 16, left: 16, right: 80, top: 16),
          Positioned(
            right: 0,
            top: 0,
            bottom: -10,
            child: cachedImage(appImages.plant2, height: 180, width: 90),
          )
        ],
      ),
    );
  }
}

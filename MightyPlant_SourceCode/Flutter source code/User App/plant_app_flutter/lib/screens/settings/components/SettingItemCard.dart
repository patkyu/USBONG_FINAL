import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingItemCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String subTitle;
  final IconData icon;
  final Function() onTap;

  SettingItemCard({required this.context, required this.title, required this.subTitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() / 2 - 26,
      decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
      padding: EdgeInsets.all(16),
      child:  Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('$title', style: boldTextStyle(size: 14)).paddingRight(24),
              4.height,
              Text('$subTitle', style: secondaryTextStyle(size: 12)),
            ],
          ),
          Icon(icon, size: 24)
        ],
      ),
    ).onTap(onTap, borderRadius: radius());
  }
}

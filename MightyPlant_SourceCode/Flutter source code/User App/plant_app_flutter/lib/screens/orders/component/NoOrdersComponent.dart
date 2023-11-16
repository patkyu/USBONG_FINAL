import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/images.dart';

class NoOrdersComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.height,
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(
              shape: BoxShape.circle,
              boxShadow: defaultBoxShadow(spreadRadius: 0, blurRadius: 0),
              color: primaryColor.withOpacity(0.5),
            ),
            child: Image.asset(appImages.appLogo, height: 180),
          ),
          16.height,
          Text(language.no_Orders_Yet, style: boldTextStyle(size: 24)),
          8.height,
          Text(
            language.sorry_you_havent_place_any_order_yet,
            style: primaryTextStyle(size: 18),
            textAlign: TextAlign.center,
          ),
          64.height,
          AppButton(
            width: context.width(),
            text: language.go_Back,
            color: context.primaryColor,
            textColor: Colors.white,
            onTap: () {
              finish(context);
            },
          )
        ],
      ),
    );
  }
}

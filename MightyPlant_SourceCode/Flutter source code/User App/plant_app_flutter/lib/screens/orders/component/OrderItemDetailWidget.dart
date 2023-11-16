import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/order/OrderResponse.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/extensions/ColorExtension.dart';
import 'package:plant_flutter/utils/extensions/StringExtension.dart';

class OrderItemDetailWidget extends StatelessWidget {
  final OrderResponse data;

  final EdgeInsetsGeometry? padding;

  OrderItemDetailWidget({required this.data, this.padding});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(46, 16, 16, 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.status.validate().toUpperCase(), style: boldTextStyle(color: data.status!.getPaymentStatusColor)),
                  Marquee(child: Text("${data.lineItems!.last.name}", style: boldTextStyle(size: 18))),
                  2.height,
                  Text(language.total + ': ${userStore.currencySymbol}${data.total}', style: boldTextStyle(color: primaryColor)),
                  2.height,
                  Text(language.ordered_on + ': ${DateFormat("dd MMM yy - hh:mm aa").format(DateTime.parse(data.dateCreated!.date!))}', style: secondaryTextStyle()),
                ],
              ).expand(),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 8,
          bottom: 8,
          child: Hero(
            tag: data.id.validate(),
            child: Container(
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              decoration: boxDecorationDefault(color: data.status!.getPaymentStatusColor.withOpacity(0.1), boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0)),
              child: Image.asset(data.status!.getImageString, height: 20, width: 20, color: data.status!.getPaymentStatusColor),
            ),
          ),
        )
      ],
    );
  }
}

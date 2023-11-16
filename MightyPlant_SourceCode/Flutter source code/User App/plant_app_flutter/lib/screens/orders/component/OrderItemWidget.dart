import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/order/OrderResponse.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/extensions/ColorExtension.dart';
import 'package:plant_flutter/utils/extensions/StringExtension.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderResponse data;

  final EdgeInsetsGeometry? padding;

  OrderItemWidget({required this.data, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(46, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('#${data.id}', style: boldTextStyle(size: 18)),
                    Text("${data.lineItems!.length - 1}+", style: secondaryTextStyle(size: 14)).visible(data.lineItems!.length - 1 > 0),
                  ],
                ),
                Text("${data.lineItems!.last.name}", style: boldTextStyle(size: 16)),
                HorizontalList(
                  padding: EdgeInsets.only(left: 0, right: 8, top: 8, bottom: 4),
                  itemCount: data.lineItems!.length,
                  itemBuilder: (context, index) {
                    LineItem lineData = data.lineItems![index];
                    return Container(
                      padding: EdgeInsets.all(1),
                      decoration: boxDecorationDefault(color: primaryColor.withOpacity(0.2), shape: BoxShape.circle, boxShadow: null),
                      child: cachedImage(lineData.productImages!.first.src, height: 34, width: 34).cornerRadiusWithClipRRect(defaultRadius),
                    );
                  },
                ),
                2.height,
                Text(language.total + ': ${userStore.currencySymbol} ${data.total}', style: boldTextStyle(size: 14)),
                2.height,
                Text(language.ordered_on + ' : ${DateFormat("dd MMM yy - hh:mm aa").format(DateTime.parse(data.dateCreated!.date!))}', style: secondaryTextStyle(size: 12)),
                2.height,
                Text(language.payment_mode + ': ${data.paymentMethod.validate()}', style: secondaryTextStyle(size: 12)),
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
      ),
    );
  }
}

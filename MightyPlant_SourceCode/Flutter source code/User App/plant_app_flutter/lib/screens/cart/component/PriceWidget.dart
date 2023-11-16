import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/colors.dart';

class PriceWidget extends StatelessWidget {
  final String? salePrice;
  final bool? isSale;
  final String? regularPrice;
  final int? salePriceSize;
  final int? regularPriceSize;
  final Color? color;
  final Color? salecolor;

  PriceWidget({this.salePrice, this.regularPrice, this.regularPriceSize, this.salePriceSize, this.isSale,this.color=primaryColor,this.salecolor= Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.start,
      children: [
        Text(
          '${userStore.currencySymbol}${(isSale.validate()) ? salePrice.validate(value: "0") : regularPrice.validate(value: "0")}',
          style: boldTextStyle(size: regularPriceSize ?? 16,color:color, fontFamily: 'Roboto'),
        ),
        4.width,
        if (isSale.validate())
          Text(
            '${userStore.currencySymbol}${regularPrice.validate(value: "0")}',
            style: secondaryTextStyle(decoration: TextDecoration.lineThrough, size: salePriceSize ?? 14,color: Colors.grey.shade500),
          ),
      ],
    );
  }
}

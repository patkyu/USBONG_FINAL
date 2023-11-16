import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/order/OrderResponse.dart';
import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';

import '../../../main.dart';

class OrderItemsComponent extends StatefulWidget {
  final OrderResponse? data;

  OrderItemsComponent(this.data);

  @override
  _OrderItemsComponentState createState() => _OrderItemsComponentState();
}

class _OrderItemsComponentState extends State<OrderItemsComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language.items_you_ordered_are, style: boldTextStyle()).center(),
          Divider(),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.only(top: 8),
              itemCount: widget.data!.lineItems!.length,
              itemBuilder: (c, i) {
                LineItem lineData = widget.data!.lineItems![i];
                return Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: boxDecorationDefault(color: primaryColor.withOpacity(0.2), shape: BoxShape.circle, boxShadow: null),
                      child: Hero(
                        tag: lineData.id.validate(),
                        child: cachedImage(lineData.productImages!.first.src, height: 70, width: 70).cornerRadiusWithClipRRect(35),
                      ),
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(lineData.name.validate(), style: primaryTextStyle(size: 14)).expand(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: 'Qty: ', style: secondaryTextStyle()),
                                  TextSpan(text: lineData.quantity.toString().validate(), style: boldTextStyle(size: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        PriceWidget(regularPrice: lineData.subtotal.toString().validate()),
                      ],
                    ).expand()
                  ],
                ).onTap(() {
                  // push(ProductDetailScreen(id: lineData.id!.toInt()));
                }).paddingBottom(16);
              }),
        ],
      ),
    ).visible(widget.data!.lineItems!.length > 1);
  }
}

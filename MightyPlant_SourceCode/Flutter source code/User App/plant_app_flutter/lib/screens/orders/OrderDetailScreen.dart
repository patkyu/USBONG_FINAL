import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/order/OrderResponse.dart';
import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
import 'package:plant_flutter/screens/checkout/component/AddressComponent.dart';
import 'package:plant_flutter/screens/orders/component/OrderItemDetailWidget.dart';
import 'package:plant_flutter/screens/orders/component/Trackingcomponent.dart';
import 'package:plant_flutter/utils/colors.dart';

import 'component/CancleOrderComponent.dart';
import 'component/OrderItemsComponent.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderResponse data;

  OrderDetailScreen({required this.data});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String? value = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.data.metaData != null) {
      widget.data.metaData!.forEach((element) {
        if (element.key == "delivery_date") {
          value = DateFormat("dd MMM yyyy - hh:mm aa").format(DateTime.parse(element.value!));
        }
      });
    } else {
      value = "";
    }
  }

  pricingComponent() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
      child: Column(
        children: [
          Text(language.lblPricingDetail, style: boldTextStyle()),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.lblShipping, style: secondaryTextStyle(size: 14)),
              Text(widget.data.shippingTotal.toString().toInt() != 0 ? getStringAsync(userStore.currencySymbol) + widget.data.shippingTotal.validate() : "Free", style: primaryTextStyle()),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.price, style: boldTextStyle()),
              PriceWidget(regularPrice: widget.data.total, regularPriceSize: 16, color: primaryColor),
            ],
          ),
          2.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.payment_mode, style: secondaryTextStyle()),
              Text(widget.data.paymentMethod.validate(), style: boldTextStyle(size: 14)),
            ],
          ),
        ],
      ).paddingAll(16),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("#${widget.data.id}", textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderItemDetailWidget(data: widget.data, padding: EdgeInsets.zero),
                Container(
                  margin: EdgeInsets.only(bottom: 16, top: 16),
                  width: context.width(),
                  decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_shipping,color: primaryColor),
                          6.width,
                          Text(language.lblDeliveredOn + " " + value.toString(), style: secondaryTextStyle()),
                        ],
                      )
                    ],
                  ).paddingAll(16),
                ).visible(value!.isNotEmpty),
                8.height,
                pricingComponent(),
                if (widget.data.shipping!.address_1.validate().isNotEmpty || widget.data.shipping!.address_2.validate().isNotEmpty)
                  AddressComponent(
                    address: widget.data.shipping!,
                    name: language.shipping_Address,
                    width: context.width(),
                    isCheckOut: false,
                  ),
                16.height,
                if (widget.data != null)
                  Container(
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
                      child: Column(
                        children: [
                          TrackingComponent(orderId: widget.data.id.validate()),
                          CancelOrderComponent(widget.data),
                        ],
                      )),
                16.height,
                OrderItemsComponent(widget.data),
              ],
            ),
          ),
          AppLoader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}

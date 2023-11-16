import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/OrderResponse.dart';
import 'package:mighty_plant_admin/screens/OrderDetailScreen.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderCardWidget extends StatefulWidget {
  final OrderResponse? orderResponse;
  final Function? onUpdate;

  OrderCardWidget({this.orderResponse, this.onUpdate});

  @override
  _OrderCardWidgetState createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  OrderResponse? data;
  String currency = '₹';

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    // data = widget.orderResponse;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.orderResponse != null
        ? Container(
            decoration: boxDecorationDefault(
              borderRadius: radius(defaultRadius),
              boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
              color: context.cardColor,
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.orderResponse!.billing!.firstName.validate().capitalizeFirstLetter()}\t'
                      '${widget.orderResponse!.billing!.lastName}',
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).expand(),
                    Text("#" + widget.orderResponse!.id.toString(), style: secondaryTextStyle()),
                  ],
                ),
                Text(currency + widget.orderResponse!.total.validate(), style: primaryTextStyle()),
                Row(
                  children: [
                    Text(convertDate(widget.orderResponse!.dateCreated.validate()), style: secondaryTextStyle(), maxLines: 1).expand(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor(widget.orderResponse!.status), borderRadius: radius(5)),
                      child: Text(widget.orderResponse!.status.capitalizeFirstLetter(), style: boldTextStyle(color: Colors.white, size: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ).onTap(() async {
            bool? res = await OrderDetailScreen(mOrderModel: widget.orderResponse).launch(context);
            if (res ?? false) {
              widget.onUpdate?.call();
            }
          }, borderRadius: BorderRadius.circular(defaultRadius)).paddingBottom(16)
        : SizedBox();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mighty_plant_admin/component/OrderCardWidget.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/OrderResponse.dart';
import 'package:mighty_plant_admin/models/VendorModel.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class VendorDashboardScreen extends StatefulWidget {
  @override
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(
          "",
          titleWidget: Row(
            children: [
              cachedImage(app_logo, height: 50, width: 50, color: white),
              8.width,
              Text("lbl_dashboard".translate, style: boldTextStyle(color: white, size: 20)),
            ],
          ),
          elevation: 0,
          color: primaryColor,
          showBack: false,
          center: false,
        ),
        body: Container(
          child: FutureBuilder<VendorModel>(
            future: getVendorDashboard(),
            builder: (context, snap) {
              if (snap.hasData) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerWidget(),
                      16.height,
                      orderSummary(snap.data!.order_summary),
                      16.height,
                      orderWidget(snap.data!.order),
                    ],
                  ),
                );
              }
              return snapWidgetHelper(snap);
            },
          ),
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Observer(builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat("MMM dd, yyyy").format(DateTime.now()), style: secondaryTextStyle()),
          Text('${"lbl_Hello".translate}, ${getStringAsync(FIRST_NAME)} ${getStringAsync(LAST_NAME)}', style: boldTextStyle()),
        ],
      );
    });
  }

  Widget orderSummary(OrderSummary? orderSummary) {
    return Container(
      decoration: boxDecorationDefault(
        borderRadius: radius(8),
        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
        color: context.cardColor,
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('lbl_order_total'.translate, style: boldTextStyle(size: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
          16.height,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              cardWidget1(context, total: orderSummary!.wc_pending.validate(), orderName: "lbl_pending".translate),
              cardWidget1(context, total: orderSummary.wc_processing.validate(), orderName: "lbl_processing".translate),
              cardWidget1(context, total: orderSummary.wc_on_hold.validate(), orderName: "lbl_on_hold".translate),
              cardWidget1(context, total: orderSummary.wc_completed.validate(), orderName: "lbl_completed".translate),
              cardWidget1(context, total: orderSummary.wc_cancelled.validate(), orderName: "lbl_cancelled".translate),
              cardWidget1(context, total: orderSummary.wc_refunded.validate(), orderName: "lbl_Refunded".translate),
              cardWidget1(context, total: orderSummary.wc_failed.validate(), orderName: "lbl_failed".translate),
            ],
          )
        ],
      ),
    );
  }

  Widget orderWidget(List<OrderResponse>? order) {
    return order!.isNotEmpty ? Container(
      decoration: boxDecorationDefault(
        borderRadius: radius(8),
        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
        color: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('lbl_new_order'.translate, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
          ListView.separated(
            separatorBuilder: (context, i) => Divider(height: 0),
            itemCount: order.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              OrderResponse data = order[i];
              return OrderCardWidget(orderResponse: data);
            },
          )
        ],
      ),
    ) : SizedBox();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/models/OrderNotesResponse.dart';
import 'package:mighty_plant_admin/models/OrderResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'ProductDetailScreen.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderResponse? mOrderModel;
  static String tag = '/OrderDetailScreen';

  OrderDetailScreen({Key? key, this.mOrderModel}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<String> mStatusList = ['pending', 'processing', 'on-hold', 'completed', 'cancelled', 'refunded', 'failed'];
  String? mSelectedStatusIndex;
  String mErrorMsg = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mSelectedStatusIndex = widget.mOrderModel!.status ?? 'pending';
  }

  void updateOrderAPI(id, status) async {
    appStore.setLoading(true);
    var request = {"status": status};
    await updateOrder(id, request).then((res) async {
      widget.mOrderModel!.status = mSelectedStatusIndex;
      appStore.setLoading(false);
      toast('Successfully update status');
      setState(() {});
      finish(context, true);
    }).catchError((error) {
      appStore.setLoading(false);
      mErrorMsg = error.toString();
      print(error.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mOrderInfo() {
      return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            cachedImage(ic_card, height: 50, width: 50, fit: BoxFit.cover),
            10.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("lbl_payment_via".translate + " " + widget.mOrderModel!.paymentMethod!, style: boldTextStyle()).expand(),
                    16.width,
                    Text(widget.mOrderModel!.status!, style: primaryTextStyle(color: statusColor(widget.mOrderModel!.status!)))
                  ],
                ),
                Text(convertDate(widget.mOrderModel!.dateCreated), style: secondaryTextStyle(), maxLines: 1),
              ],
            ).expand(),
          ],
        ),
      );
    }

    Widget mItemInfo() {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("lbl_items".translate, style: boldTextStyle()),
            16.height,
            widget.mOrderModel!.lineItems!.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.mOrderModel!.lineItems!.length,
                    itemBuilder: (context, i) {
                      OrderResponse data = widget.mOrderModel!;
                      return GestureDetector(
                        onTap: () {
                          ProductDetailScreen(mProId: data.lineItems![i].productId).launch(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.grey.withOpacity(0.1)),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${data.lineItems![i].name}', style: primaryTextStyle(), maxLines: 2),
                              4.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("lbl_qty".translate + " " + data.lineItems![i].quantity.toString(), style: primaryTextStyle(color: appStore.textSecondaryColor)),
                                  8.width,
                                  PriceWidget(price: data.lineItems![i].price, size: 16)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
          ],
        ),
      );
    }

    Widget mPaymentInfo() {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("lbl_payment_info".translate, style: boldTextStyle()),
            16.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("lbl_discount_total".translate, style: secondaryTextStyle()),
                PriceWidget(
                  price: widget.mOrderModel!.discountTotal,
                  size: 14.toDouble(),
                )
              ],
            ).visible(widget.mOrderModel!.shippingTotal.toInt() > 0),
            8.height.visible(widget.mOrderModel!.shippingTotal.toInt() > 0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("lbl_shipping_total".translate, style: secondaryTextStyle()),
                PriceWidget(
                  price: widget.mOrderModel!.shippingTotal,
                  size: 14.toDouble(),
                )
              ],
            ).visible(widget.mOrderModel!.shippingTotal.toInt() > 0),
            8.height.visible(widget.mOrderModel!.shippingTotal.toInt() > 0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("lbl_total_amount".translate, style: secondaryTextStyle(color: primaryColor, size: 16)),
                PriceWidget(
                  price: widget.mOrderModel!.total,
                  size: 16.toDouble(),
                  color: primaryColor,
                ),
              ],
            ),
            8.height,
          ],
        ),
      );
    }

    Widget mShipping() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("lbl_shipping".translate, style: boldTextStyle()),
          16.height,
          Text(
            widget.mOrderModel!.shipping!.firstName! + " " + widget.mOrderModel!.shipping!.lastName!,
            style: primaryTextStyle(),
          ),
          4.height,
          Text(
            widget.mOrderModel!.shipping!.address_1! +
                "\n" +
                widget.mOrderModel!.shipping!.city! +
                "\t" +
                widget.mOrderModel!.shipping!.postcode! +
                "\n" +
                widget.mOrderModel!.shipping!.state! +
                ",\t" +
                widget.mOrderModel!.shipping!.country!,
            style: secondaryTextStyle(),
          ),
        ],
      );
    }

    Widget mBilling() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("lbl_billing".translate, style: boldTextStyle()),
          16.height,
          Text(
            widget.mOrderModel!.billing!.firstName! + " " + widget.mOrderModel!.billing!.lastName!,
            style: primaryTextStyle(),
          ),
          2.height,
          Text(
            widget.mOrderModel!.billing!.address_1! +
                "\n" +
                widget.mOrderModel!.billing!.city! +
                "\t" +
                widget.mOrderModel!.billing!.postcode! +
                "\n" +
                widget.mOrderModel!.billing!.state! +
                ",\t" +
                widget.mOrderModel!.billing!.country!,
            style: secondaryTextStyle(),
          ),
        ],
      );
    }

    Widget mUpdateStatus() {
      return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            8.height,
            Text("lbl_change_status".translate, style: boldTextStyle()).expand(),
            16.width,
            DropdownButton(
              isExpanded: true,
              dropdownColor: context.cardColor,
              value: mSelectedStatusIndex,
              style: boldTextStyle(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: appStore.iconColor,
              ),
              underline: 0.height,
              onChanged: (dynamic newValue) {
                setState(() {
                  mSelectedStatusIndex = newValue;
                  updateOrderAPI(widget.mOrderModel!.id, newValue);
                });
              },
              items: mStatusList.map((category) {
                return DropdownMenuItem(
                  child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                  value: category,
                );
              }).toList(),
            ).withWidth(150),
          ],
        ),
      );
    }

    Widget orderNotes() {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("lbl_notes".translate, style: boldTextStyle()),
            16.height,
            FutureBuilder<List<OrderNotesResponse>>(
              future: getOrderNotes(widget.mOrderModel!.id),
              builder: (_, snap) {
                if (snap.hasData) {
                  if (snap.data!.isNotEmpty) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snap.data!.length,
                        itemBuilder: (context, i) {
                          return Text(snap.data![i].note!, style: primaryTextStyle());
                        });
                  } else {
                    return NoDataFound(
                      title: 'lbl_no_data'.translate,
                      onPressed: () {
                        //
                      },
                    );
                  }
                }
                return snapWidgetHelper(snap);
              },
            )
          ],
        ),
      ).visible(widget.mOrderModel!.customerNote != null && !widget.mOrderModel!.customerNote.isEmptyOrNull);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        appBar: appBarWidget(
          "",
          titleWidget: Text("${'lbl_order_number'.translate} #${widget.mOrderModel!.id}", style: boldTextStyle(color: Colors.white)),
          elevation: 10,
          color: primaryColor,
          backWidget: IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back, color: white),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  mOrderInfo(),
                  Divider(height: 0),
                  mUpdateStatus(),
                  Divider(height: 0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mShipping().expand().visible(widget.mOrderModel!.shipping!.address_1!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.city!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.postcode!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.state!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.country!.isNotEmpty),
                      16.width.visible(widget.mOrderModel!.shipping!.address_1!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.city!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.postcode!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.state!.isNotEmpty ||
                          widget.mOrderModel!.shipping!.country!.isNotEmpty),
                      mBilling().expand().visible(widget.mOrderModel!.billing!.address_1!.isNotEmpty ||
                          widget.mOrderModel!.billing!.city!.isNotEmpty ||
                          widget.mOrderModel!.billing!.postcode!.isNotEmpty ||
                          widget.mOrderModel!.billing!.state!.isNotEmpty ||
                          widget.mOrderModel!.billing!.country!.isNotEmpty),
                    ],
                  ).paddingAll(16),
                  Divider(height: 0),
                  mItemInfo(),
                  Divider(height: 0),
                  orderNotes(),
                  Divider(height: 0),
                  mPaymentInfo(),
                ],
              ),
            ).visible(!appStore.isLoading),
            Observer(
              builder: (_) => loading().center().visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}

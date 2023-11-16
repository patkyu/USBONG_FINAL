import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/order/OrderResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/constants.dart';

import '../../../main.dart';

class CancelOrderComponent extends StatefulWidget {
  final OrderResponse? data;

  CancelOrderComponent(this.data);

  @override
  _CancelOrderComponentState createState() => _CancelOrderComponentState();
}

class _CancelOrderComponentState extends State<CancelOrderComponent> {
  final List<String> mCancelList = [
    language.cancleOrderMsg11,
    language.cancleOrderMsg2,
    language.cancleOrderMsg3,
    language.cancleOrderMsg4,
    language.cancleOrderMsg5,
    language.cancleOrderMsg6,
  ].toList();
  String? mValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  void cancelOrderData(String? mValue) async {
    appStore.setLoading(true);
    var request = {
      "status": "cancelled",
      "customer_note": mValue,
    };
    await orderApi.cancelOrder(orderId: widget.data!.id!.toInt(), request: request).then((res) {
      if (!mounted) return;
      setState(() {
        var request = {
          'customer_note': true,
          'note': "{\n" + "\"status\":\"Cancelled\",\n" + "\"message\":\"Order Canceled by you due to " + mValue! + ".\"\n" + "} ",
        };
        orderApi.createOrderNotes(widget.data!.id, request).then((res) {
          if (!mounted) return;
          appStore.setLoading(false);
          finish(context, true);
        }).catchError((error) {
          appStore.setLoading(false);
          finish(context, true);
          toast(error.toString());
        });
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      toast(error.toString());
      finish(context, true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return (widget.data!.status == COMPLETED || widget.data!.status == REFUNDED || widget.data!.status == CANCELED || widget.data!.status == TRASH || widget.data!.status == FAILED)
        ? SizedBox()
        : GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                builder: (context) {
                  return BottomSheet(
                    backgroundColor: context.cardColor,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(language.lblCancleORder, style: boldTextStyle()).expand(),
                                    Icon(Icons.close).onTap(() {
                                      finish(context);
                                    })
                                  ],
                                ),
                                24.height,
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: mCancelList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        mValue = mCancelList[index];
                                        print(mValue);
                                        setState(() {
                                          appStore.setCancelItemIndex(index);
                                          print(appStore.cancelOrderIndex.toString());
                                        });
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: boxDecorationWithRoundedCorners(
                                                borderRadius: radius(12),
                                                border: Border.all(color: primaryColor),
                                                backgroundColor: appStore.cancelOrderIndex == index ? primaryColor : context.cardColor,
                                              ),
                                              width: 20,
                                              height: 20,
                                              child: Icon(Icons.done, size: 12, color: context.cardColor)),
                                          4.width,
                                          Text(mCancelList[index], style: primaryTextStyle()).paddingLeft(8).expand(),
                                        ],
                                      ).paddingOnly(top: 8, bottom: 8),
                                    );
                                  },
                                ),
                                24.height,
                                AppButton(
                                  width: context.width(),
                                  textStyle: primaryTextStyle(color: white),
                                  text: language.lblCancleORder,
                                  color: primaryColor,
                                  onTap: () {
                                    Navigator.pop(context);
                                    appStore.isLoading = true;
                                    setState(() {});
                                    cancelOrderData(mValue);
                                  },
                                ),
                                20.height,
                              ],
                            ),
                          );
                        },
                      );
                    },
                    onClosing: () {},
                  );
                },
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
              child: Text(language.lblCancleORder, style: primaryTextStyle(color: primaryColor)),
            ),
          ).visible(widget.data != null);
  }
}

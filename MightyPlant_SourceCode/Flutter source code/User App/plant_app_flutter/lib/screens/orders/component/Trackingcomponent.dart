import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/order/OrderTrackingResponse.dart';
import 'package:plant_flutter/model/order/TrackingResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackingComponent extends StatefulWidget {
  final int orderId;

  TrackingComponent({required this.orderId});

  @override
  State<TrackingComponent> createState() => _TrackingComponentState();
}

class _TrackingComponentState extends State<TrackingComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderTrackingResponse>>(
      initialData: [],
      future: orderApi.getOrderTrackingDetail(orderId: widget.orderId),
      builder: (context, snap) {
        if (snap.hasData) {
          log(snap.data!.length);
          return AnimatedContainer(
            duration: 1200.milliseconds,
            curve: Curves.ease,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.shipping_information, style: boldTextStyle()).center(),
                Divider(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snap.data!.length,
                  shrinkWrap: true,padding: EdgeInsets.only(top: 8),
                  itemBuilder: (BuildContext context, int index) {
                    OrderTrackingResponse data = snap.data![index];
                    TrackingResponse? trackingData;
                    if (data.note!.contains('{')) {
                      trackingData = TrackingResponse.fromJson(jsonDecode(data.note.validate()));
                    }
                    return TimelineTile(
                      indicatorStyle: IndicatorStyle(
                        width: 14,
                        color: primaryColor,
                        drawGap: true,
                        indicatorXY: 0.0,
                      ),
                      isFirst: index == 0,
                      afterLineStyle: LineStyle(color: primaryColor.withOpacity(0.2)),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.0,
                      hasIndicator: true,
                      isLast: index == snap.data!.length - 1,
                      endChild: Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
                        child: data.note!.contains('{')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${trackingData!.status}', style: boldTextStyle(size: 14)),
                                  Text('${trackingData.message} ', style: secondaryTextStyle()),
                                  4.height,
                                  Text(DateFormat("dd MMM yyyy - hh:mm aa").format(DateTime.parse(data.dateCreated.validate())), style: secondaryTextStyle()),
                                ],
                              )
                            : Text(data.note.validate(), style: primaryTextStyle(size: 14)),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return snapWidgetHelper(snap, loadingWidget: AppLoader().center());
      },
    );
  }
}

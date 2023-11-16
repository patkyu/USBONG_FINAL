import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/dashboard/TipResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/dashboard/TipDetailsScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:share_plus/share_plus.dart';

class TipListScreen extends StatefulWidget {
  @override
  _TipListScreenState createState() => _TipListScreenState();
}

class _TipListScreenState extends State<TipListScreen> {
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
    return Scaffold(
      appBar: appBarWidget(language.tips_for_growing_plants,
          textColor: Colors.white,
          backWidget: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => finish(context))),
      body: FutureBuilder<TipResponse>(
        future: dashboardApi.getTips(),
        builder: (context, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data!.tipData!.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              itemBuilder: (BuildContext context, int index) {
                TipData data = snap.data!.tipData![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Hero(
                            tag: data.image.validate(),
                            child: cachedImage("${data.image.validate()}",
                                    fit: BoxFit.cover,
                                    width: context.width(),
                                    height: 200)
                                .cornerRadiusWithClipRRect(16)
                                .paddingSymmetric(horizontal: 16)),
                        Container(
                          width: 32,
                          height: 32,
                          margin: EdgeInsets.only(bottom: 16, right: 24),
                          decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.share,
                                size: 20, color: Colors.white),
                            onPressed: () {
                              Share.share(data.share_url.validate());
                            },
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${data.post_title.validate()}',
                            style: boldTextStyle(size: 20)),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${data.readable_date.validate()}',
                                style: secondaryTextStyle(size: 16)),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: grey),
                                4.width,
                                Text('${data.human_time_diff.validate()}',
                                    style: secondaryTextStyle(size: 16)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${parseHtmlString(data.post_excerpt.validate())}',
                            style: primaryTextStyle(size: 16)),
                        8.height,
                        Text(
                            '${language.lblAuthor} : ${data.post_author_name.validate().capitalizeFirstLetter()} ',
                            style: boldTextStyle(size: 14)),
                      ],
                    ).paddingOnly(left: 16, right: 16),
                    Divider(height: 40, thickness: 2)
                        .visible(index != snap.data!.tipData!.length - 1),
                    16.height.visible(index == snap.data!.tipData!.length - 1),
                  ],
                ).onTap(() {
                  TipDetailsScreen(tipData: data).launch(context);
                });
              },
            );
          }
          return snapWidgetHelper(snap, loadingWidget: AppLoader().center());
        },
      ),
    );
  }
}

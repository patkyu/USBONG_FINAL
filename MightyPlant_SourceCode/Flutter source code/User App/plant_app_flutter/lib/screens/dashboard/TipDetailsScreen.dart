import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/dashboard/TipResponse.dart';
import 'package:plant_flutter/screens/dashboard/component/HtmlWidget.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:share_plus/share_plus.dart';

class TipDetailsScreen extends StatefulWidget {
  final TipData? tipData;

  TipDetailsScreen({this.tipData});

  @override
  _TipDetailsScreenState createState() => _TipDetailsScreenState();
}

class _TipDetailsScreenState extends State<TipDetailsScreen> {
  TipData? tipData;
  String postContent = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    tipData = widget.tipData;
    setPostContent(widget.tipData!.post_content.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> setPostContent(String text) async {
    postContent = widget.tipData!.post_content
        .validate()
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('[embed]', '<embed>')
        .replaceAll('[/embed]', '</embed>')
        .replaceAll('[caption]', '<caption>')
        .replaceAll('[/caption]', '</caption>');

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
                tag: widget.tipData!.image.validate(),
                child: cachedImage("${widget.tipData!.image.validate()}", fit: BoxFit.cover, width: context.width(), height: 200)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.access_time_rounded, color: textSecondaryColorGlobal, size: 16),
                4.width,
                Text(tipData!.readable_date.validate(), style: secondaryTextStyle()),
              ],
            ).paddingOnly(bottom: 8,right: 16,top: 8),
            8.height,
            Text(parseHtmlString(tipData!.post_title.validate()), style: boldTextStyle(size: 26)).paddingOnly(left: 16, right: 16),
            HtmlWidget(postContent: postContent.validate()).paddingOnly(left: 8, right: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('${parseHtmlString(tipData!.post_title.validate())}', textColor: Colors.white, actions: [
        IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(tipData!.share_url.validate());
            })
      ],backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: body(),
    );
  }
}

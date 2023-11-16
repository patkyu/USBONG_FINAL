import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/model/review/ReviewResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/review/AddReviewScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/common.dart';

class ReviewCardComponent extends StatefulWidget {
  final ReviewResponse data;
  final ProductDetailResponse productData;
  final bool? isDetail;

  ReviewCardComponent({required this.data, required this.productData, this.isDetail});

  @override
  State<ReviewCardComponent> createState() => _ReviewCardComponentState();
}

class _ReviewCardComponentState extends State<ReviewCardComponent> {
  deleteReview() async {
    appStore.setLoading(true);
    await reviewApi.deleteReview(id: widget.data.id.validate()).then((value) {
      toast(language.deleted);
      productStore.mIsUserExistInReview = false;
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: boxDecorationDefault(border: Border.all(color: context.dividerColor), color: context.cardColor),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage("${widget.data.reviewerAvatarUrls!.s24}", height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(25),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.data.reviewer}', style: boldTextStyle(size: 14)),
                  RatingBarWidget(
                    onRatingChanged: (c) {
                      //
                    },
                    disable: true,
                    itemCount: 5,
                    rating: widget.data.rating!.toDouble(),
                    size: 14,
                  ),
                ],
              ).expand(),
              8.width,
              Text('${(DateTime.parse(widget.data.dateCreated.validate()).timeAgo)}', style: secondaryTextStyle(size: 12)),
              if (widget.isDetail == false && userStore.userEmail == widget.data.reviewerEmail && userStore.isLoggedIn)
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  onSelected: (i) async {
                    if (i == 1) {
                      bool isUpdate = await AddReviewScreen(productData: widget.productData, reviewResponse: widget.data).launch(context);
                      if (isUpdate) {
                        setState(() {});
                      }
                    } else {
                      showDialogBox(context, language.are_you_sure_you_want_to_delete_this_review, () {
                        deleteReview();
                        finish(context);
                        setState(() {});
                      });
                    }
                  },
                  itemBuilder: (context) {
                    List<PopupMenuItem> list = [];
                    list.add(PopupMenuItem(
                      value: 1,
                      child: Text(language.edit, style: boldTextStyle()),
                    ));
                    list.add(PopupMenuItem(
                      value: 2,
                      child: Text(language.delete, style: boldTextStyle()),
                    ));
                    return list;
                  },
                ),
            ],
          ),
          8.height,
          Text(parseHtmlString(widget.data.review.capitalizeFirstLetter()), style: primaryTextStyle(size: 14)).paddingSymmetric(horizontal: 8),
        ],
      ),
    );
  }
}

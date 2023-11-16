import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/models/ReviewResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class UpdateReviewDialog extends StatefulWidget {
  static String tag = '/UpdateReviewScreen';
  final ReviewResponse? data;
  final Function? onUpdate;

  UpdateReviewDialog({this.data,this.onUpdate});

  @override
  UpdateReviewDialogState createState() => UpdateReviewDialogState();
}

class UpdateReviewDialogState extends State<UpdateReviewDialog> {
  TextEditingController reviewCont = TextEditingController();

  int totalStar = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    reviewCont.text = parseHtmlString(widget.data!.review.validate());
    totalStar = widget.data!.rating.validate();
  }

  Future<void> updateReviews() async {
    appStore.setLoading(true);

    Map req = {"rating": totalStar, "review": reviewCont.text.validate()};

    await updateReview(reviewId: widget.data!.id.validate(), request: req).then((res) {
      widget.data!.rating = totalStar;
      widget.data!.review = reviewCont.text.validate();
      toast('lbl_update_successfully'.translate);
      widget.onUpdate!.call();
    }).catchError((error) {
      log(error.toString());
      toast(error.toString().validate());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${"lbl_Update_Review".translate}',style: boldTextStyle(size: 20)),
              CloseButton(color: Colors.grey),
            ],
          ),
          16.height,
          RatingBarWidget(
              spacing: 6,
              itemCount: 5,
              size: 36,
              activeColor: Colors.amber,
              rating: totalStar.toDouble(),
              onRatingChanged: (rating) {
                log(rating);
                totalStar = rating.toInt();
                setState(() {});
              }).center(),
          30.height,
          AppTextField(
            controller: reviewCont,
            textFieldType: TextFieldType.OTHER,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: "lbl_Product_Review".translate),
            maxLines: 3,
            minLines: 3,
          ),
          30.height,
          AppButton(
            text: "lbl_Update".translate,
            color: primaryColor,
            textColor: white,
            width: context.width(),
            onTap: () {
              hideKeyboard(context);
              finish(context);
              updateReviews();
            },
          ),
        ],
      ),
    );
  }
}

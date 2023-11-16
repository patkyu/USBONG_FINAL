import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/ReviewResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/screens/UpdateReviewDialog.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewItemWidget extends StatefulWidget {
  final ReviewResponse? data;
  final Function? onUpdate;
  final Function(int)? onDelete;

  ReviewItemWidget({this.data, this.onUpdate, this.onDelete});

  @override
  _ReviewItemWidgetState createState() => _ReviewItemWidgetState();
}

class _ReviewItemWidgetState extends State<ReviewItemWidget> {
  Future<void> deleteReviews() async {
    hideKeyboard(context);

    appStore.setLoading(true);

    deleteReview(reviewId: widget.data!.id).then((res) {
      if (res.status == 'trash') toast('successfully_deleted'.translate);
      widget.onDelete!.call(widget.data!.id!);
    }).catchError((error) {
      log(error.toString());
    }).whenComplete(() {
      LiveStream().emit(REMOVE_REVIEW, true);
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        borderRadius: radius(8),
        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
        color: context.cardColor,
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cachedImage(getStringAsync(AVATAR), height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(35),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(parseHtmlString('${widget.data!.reviewer.capitalizeFirstLetter()}'), maxLines: 1, style: boldTextStyle()).expand(),
                      Text(DateFormat.yMMMd().format(DateTime.parse(widget.data!.dateCreated!)), style: secondaryTextStyle(size: 14)),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      RatingBarWidget(
                        onRatingChanged: (rating) {},
                        itemCount: 5,
                        size: 18,
                        activeColor: Colors.amber,
                        inActiveColor: grey,
                        allowHalfRating: true,
                        disable: true,
                        rating: widget.data!.rating!.toDouble(),
                      ),
                      4.width,
                      Text('${widget.data!.rating!.toDouble()}', style: boldTextStyle()),
                    ],
                  ),
                ],
              ).expand(),
            ],
          ),
          8.height,
          Row(
           crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(parseHtmlString('${widget.data!.review}'), style: primaryTextStyle(size: 14)).expand(),
              8.width,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  commonEditButtonComponent(
                      icon: Icons.edit,
                      color: primaryColor,
                      onCall: () async {
                        if (isVendor) {
                          toast("admin_toast".translate);
                          return;
                        }
                        showInDialog(context, builder: (context) {
                          return UpdateReviewDialog(
                              data: widget.data,
                              onUpdate: () {
                                widget.onUpdate?.call();
                              });
                        }, backgroundColor: context.cardColor);
                      }),
                  16.width,
                  commonEditButtonComponent(
                      icon: Icons.delete,
                      color: redColor,
                      onCall: () async {
                        if (isVendor) {
                          toast("admin_toast".translate);
                          return;
                        }
                        showConfirmDialogCustom(context,primaryColor: primaryColor, title: "lbl_confirmation_Delete_Review".translate, onAccept: (_) {
                          deleteReviews();
                        }, dialogType: DialogType.DELETE, positiveText: 'lbl_Delete'.translate, negativeText: 'lbl_cancel'.translate);
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

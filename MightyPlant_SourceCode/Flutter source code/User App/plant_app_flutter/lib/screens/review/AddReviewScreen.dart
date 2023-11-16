import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/model/review/ReviewResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/widgets/rounded_loading_button.dart';

class AddReviewScreen extends StatefulWidget {
  final ProductDetailResponse productData;
  final ReviewResponse? reviewResponse;

  AddReviewScreen({required this.productData, this.reviewResponse});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  int selectedRating = 0;

  TextEditingController reviewCont = TextEditingController();

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.reviewResponse != null;
    if (isUpdate) {
      reviewCont.text = parseHtmlString(widget.reviewResponse!.review!);
      selectedRating = widget.reviewResponse!.rating.validate();
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _btnController.start();

      if (isUpdate) {
        Map<String, dynamic> req = {
          "review": reviewCont.text,
          "rating": "$selectedRating",
        };
        reviewApi.updateReview(id: widget.reviewResponse!.id.validate(), req: req).then((value) {
          _btnController.success();
          toast(language.your_review_has_been_saved);
          productStore.mIsUserExistInReview = false;
          setState(() {});
          finish(context, isUpdate);
        }).catchError((e) {
          _btnController.error();

          appStore.setLoading(false);
          toast(e.toString());
        });
      } else {
        Map<String, dynamic> req = {
          "reviewer": "${userStore.firstName.validate()} ${userStore.lastName.validate()}",
          "reviewer_email": "${userStore.userEmail.validate()}",
          "review": reviewCont.text,
          "rating": "${selectedRating.toDouble()}",
          "product_id": widget.productData.id,
        };
        reviewApi.createReviewResponse(req: req).then((value) {
          appStore.setLoading(false);
          _btnController.success();
          toast(language.your_review_has_been_saved);
          finish(context, true);
          setState(() {});
        }).catchError((e) {
          _btnController.error();
          appStore.setLoading(false);
          toast(e.toString());
        });
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget productWidget() {
    return Container(
      decoration: boxDecorationDefault(color: context.cardColor),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          cachedImage("${widget.productData.imagess!.first.src!}", height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
          16.width,
          Text('${widget.productData.name}', style: boldTextStyle()).expand(),
        ],
      ),
    );
  }

  Widget reviewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        8.height,
        Text(language.your_overall_rating_for_this_product, style: primaryTextStyle(size: 14)),
        16.height,
        RatingBarWidget(
          onRatingChanged: (v) {
            selectedRating = v.toInt();
          },
          size: 28,
          inActiveColor: Colors.grey,
          rating: selectedRating.toDouble(),
        ),
        8.height,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.add_Review, textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productWidget(),
                8.height,
                Divider(),
                reviewWidget().center(),
                Divider(),
                8.height,
                Text(language.what_do_you_like_or_dislike, style: boldTextStyle()),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.ADDRESS,
                  isValidationRequired: true,
                  validator: (value) {
                    if (value!.trim().isEmpty) return errorThisFieldRequired;
                  },
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.dividerColor)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.dividerColor)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.dividerColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.dividerColor)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.theme.colorScheme.error)),
                    alignLabelWithHint: true,
                    filled: true,
                    hintText: "",
                  ),
                  controller: reviewCont,
                  maxLength: 3000,
                  maxLines: 15,
                  minLines: 5,
                ),
                32.height,
                RoundedLoadingButton(
                  successIcon: Icons.done,
                  width: context.width(),
                  failedIcon: Icons.close,
                  borderRadius: defaultRadius,
                  child: Text(language.submit, style: boldTextStyle(color: Colors.white)),
                  controller: _btnController,
                  animateOnTap: false,
                  resetAfterDuration: true,
                  color: context.primaryColor,
                  onPressed: () => submit(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

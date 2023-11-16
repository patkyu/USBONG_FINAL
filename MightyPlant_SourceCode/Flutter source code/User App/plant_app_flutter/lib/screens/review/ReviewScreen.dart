import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/model/review/ReviewResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/review/AddReviewScreen.dart';
import 'package:plant_flutter/screens/review/component/ReviewCardComponent.dart';
import 'package:plant_flutter/utils/common.dart';

class ReviewScreen extends StatefulWidget {
  final ProductDetailResponse productData;

  ReviewScreen({required this.productData});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
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
      appBar: appBarWidget(language.product_Review, textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: FutureBuilder<List<ReviewResponse>>(
        future: reviewApi.getProductReview(id: widget.productData.id.validate()),
        builder: (context, snap) {
          productStore.mIsUserExistInReview = false;
          if (snap.data.validate().isNotEmpty) {
            snap.data.forEachIndexed((element, index) {
              if (element.reviewerEmail.validate().contains(userStore.userEmail)) {
                productStore.mIsUserExistInReview = true;
              }
            });
          }
          log(userStore.userEmail);
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextIcon(
                  onTap: () {
                    ifLoggedIn(() async {
                      bool isUpdate = await push(AddReviewScreen(productData: widget.productData));
                      if (isUpdate) {
                        setState(() {});
                        appStore.setLoading(false);
                      }
                    });
                  },
                  edgeInsets: EdgeInsets.symmetric(vertical: 16),
                  expandedText: true,
                  spacing: 16,
                  prefix: Icon(MaterialIcons.rate_review),
                  suffix: Icon(MaterialIcons.keyboard_arrow_right, size: 18),
                  text: language.add_Review,
                ).visible(!productStore.mIsUserExistInReview),
                (snap.hasData && snap.data!.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(height: 0).visible(!productStore.mIsUserExistInReview),
                          16.height.visible(!productStore.mIsUserExistInReview),
                          Text(language.user_reviews, style: boldTextStyle(size: 16)),
                          16.height,
                          if (snap.data!.isNotEmpty)
                            ...List.generate(
                              snap.data!.length,
                              (index) {
                                return ReviewCardComponent(data: snap.data![index], productData: widget.productData, isDetail: false);
                              },
                            ),
                          if (snap.data!.isEmpty) NoDataWidget(title: language.no_Reviews).center(),
                        ],
                      )
                    : AppLoader().visible(appStore.isLoading)
              ],
            ),
          );
        },
      ),
    );
  }
}

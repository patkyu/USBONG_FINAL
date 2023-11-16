import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/screens/review/ReviewScreen.dart';
import 'package:plant_flutter/utils/images.dart';

class InfoComponent extends StatelessWidget {
  final ProductDetailResponse data;

  InfoComponent({required this.data});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          childAnimationBuilder: (p0) => SlideAnimation(
            duration: 800.milliseconds,
            verticalOffset: 20.0,
            child: FadeInAnimation(child: p0),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(appImages.icPlantRate, color: Colors.white, height: 24, width: 24),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.ratings.toUpperCase(), style: primaryTextStyle(size:14,color: white)),
                       4.height,
                        Row(
                          children: [
                            Text(
                              data.average_rating == '0.00' ? '0' : "${data.average_rating}",
                              style: secondaryTextStyle(color: white, size: 14),
                            ),
                            4.width,
                            Icon(LineIcons.star_1, size: 14, color: Colors.amber)
                          ],
                        ),
                      ],
                    ).onTap(() {
                      push(ReviewScreen(productData: data));
                    }),
                  ],
                ),
                16.height,
                data.weight == null
                    ? Offstage()
                    : Row(
                        children: [
                          Image.asset(appImages.icPlantWeight, color: Colors.white, height: 24, width: 24),
                          8.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.weight.toUpperCase(), style: primaryTextStyle(size:14,color: Colors.white)),
                             4.height,
                              Text("${(data.weight.validate().toDouble() * 1000).toStringAsFixed(0)} g", style: secondaryTextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                16.height,
                data.dimensions == null
                    ? Offstage()
                    : Row(
                        children: [
                          Image.asset(appImages.icPlantHeight, color: Colors.white, height: 24, width: 24),
                          8.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.height.toUpperCase(), style: primaryTextStyle(size:14,color: Colors.white)),
                             4.height,
                              Text("${(data.dimensions!.height.validate().toDouble() * 0.393701).toStringAsFixed(0)} inches", style: secondaryTextStyle(color: Colors.white, size: 14)),
                            ],
                          ),
                        ],
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

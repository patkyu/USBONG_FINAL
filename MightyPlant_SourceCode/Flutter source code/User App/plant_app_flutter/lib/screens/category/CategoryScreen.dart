import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/category/CategoryResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/screens/category/SubCategoryProductScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
      backgroundColor: context.scaffoldBackgroundColor,
      body: FutureBuilder<List<CategoryResponse>>(
          future: categoryApi.getCategories(catId: 0),
          builder: (context, snap) {
            if (snap.hasData) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimationLimiter(
                      child: Wrap(
                        runSpacing: 16,
                        spacing: 16,
                        children: List.generate(
                          snap.data!.length,
                              (index) {
                            CategoryResponse data = snap.data![index];
                            return AnimationConfiguration.staggeredGrid(
                              duration: const Duration(milliseconds: 750),
                              columnCount: 1,
                              position: index,
                              child: FlipAnimation(
                                curve: Curves.linear,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                      onTap: (() {
                                        push(SubCategoryProductScreen(parentCategory: data), pageRouteAnimation: PageRouteAnimation.Fade, duration: 800.milliseconds);
                                      }),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: context.width() * 0.43,
                                            height: 160,
                                            decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(), border: Border.all(color: context.dividerColor)),
                                            padding: EdgeInsets.all(8),
                                            child: Hero(
                                              tag: data,
                                              child: cachedImage(data.image, fit: BoxFit.cover).cornerRadiusWithClipRRect(20),
                                            ),
                                          ),
                                          8.height,
                                          Text(data.name.validate(), style: boldTextStyle(size: 14)),
                                        ],
                                      )),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return snapWidgetHelper(snap, loadingWidget: AppLoader().center());
          }),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AdComponent.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/components/VedioPlayingDialog.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/screens/product/component/GroupComponent.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/model/review/ReviewResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
import 'package:plant_flutter/screens/dashboard/component/HtmlWidget.dart';
import 'package:plant_flutter/screens/product/component/AddToCartComponent.dart';
import 'package:plant_flutter/screens/product/component/CategoryComponent.dart';
import 'package:plant_flutter/screens/product/component/SaleComponent.dart';
import 'package:plant_flutter/screens/product/component/SimilarProductComponent.dart';
import 'package:plant_flutter/screens/product/ZoomImageScreen.dart';
import 'package:plant_flutter/screens/review/component/ReviewCardComponent.dart';
import 'package:plant_flutter/screens/review/ReviewScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:plant_flutter/utils/images.dart';

import '../VendorDetailScreen.dart';
import 'component/AttributeComponent.dart';
import 'component/FavoriteProductComponent.dart';

class ProductDetailScreen extends StatefulWidget {
  final int id;
  final bool? isFromDashboard;
  final String? uniqueKeyForAnimation;

  ProductDetailScreen({required this.id, this.isFromDashboard, this.uniqueKeyForAnimation});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailResponse? productDetailNew;
  PageController _pageController = PageController(initialPage: 0);

  int currentIndex = 0;
  num rating = 0.0;
  num? discount = 0;

  List<ProductDetailResponse> product = [];
  List<ProductDetailResponse> initialData = [];
  List<ProductDetailResponse> mProductsList = [];
  List<String?> mProductOptions = [];
  List<ProductDetailResponse> mProducts = [];
  List<int> mProductVariationsIds = [];
  List<Widget> productImg = [];
  List<String?> productImg1 = [];

  String videoType = '';
  String? mSelectedVariation = '';
  String? mExternalUrl = "";

  int? selectedInd = 0;

  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  void init() async {
    createInterstitialAd1();
    productDetail();
  }

  adShow1() async {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('onAdDismissedFullScreenContent.');
        print('onAdDismissedFullScreenContent.');
        ad.dispose();
        interstitialAd!.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('onAdFailedToShowFullScreenContent: $error');
        print('onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        interstitialAd!.dispose();
      },
    );
    interstitialAd?.show();
    interstitialAd = null;
  }

  void createInterstitialAd1() {
    InterstitialAd.load(
      adUnitId: kReleaseMode ? getInterstitialAdUnitId()! : InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          print('$ad loaded');

          interstitialAd = ad;
          adShow1();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          print('interstitialAd failed to load');

          interstitialAd = null;
        },
      ),
    );
  }

  Future productDetail() async {
    appStore.setLoading(true);
    await productApi.getProductDetails(id: widget.id.toInt()).then((res) {
      setState(() {

        Iterable mInfo = res;
        mProducts = mInfo.map((model) => ProductDetailResponse.fromJson(model)).toList();
        if (mProducts.isNotEmpty) {
          productDetailNew = mProducts[0];
          rating = double.parse(mProducts[0].average_rating!);
          productDetailNew!.variations!.forEach((element) {
            mProductVariationsIds.add(element);
          });
          mProductsList.clear();

          for (var i = 0; i < mProducts.length; i++) {
            if (i != 0) {
              mProductsList.add(mProducts[i]);
            }
          }

          if (productDetailNew!.type == "variable" || productDetailNew!.type == "variation") {
            mProductOptions.clear();
            mProductsList.forEach((product) {
              var option = '';

              product.attributes!.forEach((attribute) {
                if (option.isNotEmpty) {
                  option = '$option - ${attribute.option.validate()}';
                } else {
                  option = attribute.option.validate();
                }
              });
              if (product.on_sale!) {
                option = '$option [Sale]';
              }
              mProductOptions.add(option);
            });

            if (mProductOptions.isNotEmpty) mSelectedVariation = mProductOptions.first;
            if (productDetailNew!.type == "variable" || productDetailNew!.type == "variation" && mProductsList.isNotEmpty) {
              productDetailNew = mProductsList[0];
              mProducts = mProducts;
            }
          } else if (productDetailNew!.type == 'grouped') {
            product.clear();
            product.addAll(mProductsList);
          }
          mImage();
          setPriceDetail();
          if (productDetailNew!.woofv_video_embed != null) {
            if (productDetailNew!.woofv_video_embed!.url != '') {
              if (productDetailNew!.woofv_video_embed!.url.validate().contains(VideoTypeYouTube)) {
                videoType = VideoTypeYouTube;
              } else if (productDetailNew!.woofv_video_embed!.url.validate().contains(VideoTypeIFrame)) {
                videoType = VideoTypeIFrame;
              } else {
                videoType = VideoTypeCustom;
              }
              productImg.add(
                Stack(
                  fit: StackFit.expand,
                  children: [
                    cachedImage(
                      productDetailNew!.imagess![0].src.validate(),
                      fit: BoxFit.cover,
                      height: 400,
                      width: double.infinity,
                    ).cornerRadiusWithClipRRectOnly(topLeft: 20, topRight: 20).paddingOnly(bottom: 24),
                    Icon(Icons.play_circle_fill_outlined, size: 40, color: Colors.grey).center(),
                  ],
                ).onTap(() {
                  VideoPlayDialog(data: productDetailNew!.woofv_video_embed).launch(context);
                }),
              );
            }
          }
        }
      });
      appStore.setLoading(false);
    }).catchError((error) {
      log('error:$error');
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget setPriceDetail() {
    if (productDetailNew!.on_sale!) {
      num mrp = productDetailNew!.regular_price.validate().toDouble();
      num discountPrice = productDetailNew!.price!.validate().toDouble();
      discount = ((mrp - discountPrice) / mrp) * 100;
    }
    return SizedBox();
  }

  void mImage() {
    setState(() {
      productImg1.clear();
      productDetailNew!.imagess!.forEach((element) {
        productImg1.add(element.src);
      });
    });
  }

  Widget mDiscount() {
    setPriceDetail();
    if (productDetailNew!.on_sale == true)
      return Container(
        child: Text("(" + '${discount.validate().toStringAsFixed(2)} ' + "% off )", style: primaryTextStyle(color: Colors.red)),
      );
    else
      return SizedBox();
  }

  Widget overViewProduct({required String name, String? icon}) {
    return Container(
      width: context.width() / 2 - 20,
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Image.asset(icon ?? appImages.appLogo, height: 28, width: 28, color: appStore.isDarkMode ? unSelectedColor : primaryColor, fit: BoxFit.fill),
          8.width,
          Text(name, style: secondaryTextStyle(size: 12, color: appStore.isDarkMode ? unSelectedColor : primaryColor)).expand(),
        ],
      ),
    );
  }

  mOtherAttribute() {
    toast('Product type not supported');
    finish(context);
  }

  @override
  Widget build(BuildContext context) {
    final videoSlider = productDetailNew != null
        ? Stack(
            children: [
              PageView(
                  children: productImg,
                  controller: _pageController,
                  onPageChanged: (index) {
                    currentIndex = index;
                    setState(() {});
                  }),
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DotIndicator(
                      pageController: _pageController,
                      pages: productImg,
                      indicatorColor: primaryColor,
                      unselectedIndicatorColor: primaryColor.withOpacity(0.5),
                      currentBoxShape: BoxShape.rectangle,
                      boxShape: BoxShape.rectangle,
                      borderRadius: radius(2),
                      currentBorderRadius: radius(3),
                      currentDotSize: 18,
                      currentDotWidth: 6,
                      dotSize: 6,
                    ),
                    if (productDetailNew!.on_sale! && productDetailNew!.date_on_sale_from.validate().isNotEmpty) SaleComponent(data: productDetailNew!),
                  ],
                ),
              ),
            ],
          )
        : SizedBox();

    final imageSlider = productDetailNew != null
        ? Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: productImg1.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ZoomImageScreen(currentIndex, productDetailNew!, productDetailNew!.id.validate(), widget.uniqueKeyForAnimation.toString()).launch(context);
                    },
                    child: Hero(tag: "${productDetailNew!.id}${widget.uniqueKeyForAnimation}", child: cachedImage(productImg1[index]).paddingAll(8)),
                  );
                },
                onPageChanged: (index) {
                  currentIndex = index;
                  setState(() {});
                },
              ).paddingSymmetric(vertical: 16),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (productImg1.length > 1)
                      DotIndicator(
                        pageController: _pageController,
                        pages: productImg1,
                        indicatorColor: primaryColor,
                        unselectedIndicatorColor: primaryColor.withOpacity(0.5),
                        currentBoxShape: BoxShape.rectangle,
                        boxShape: BoxShape.rectangle,
                        borderRadius: radius(2),
                        currentBorderRadius: radius(3),
                        currentDotSize: 18,
                        currentDotWidth: 6,
                        dotSize: 6,
                      ),
                    if (productDetailNew!.on_sale! && productDetailNew!.date_on_sale_from.validate().isNotEmpty) SaleComponent(data: productDetailNew!),
                  ],
                ),
              ),
            ],
          )
        : SizedBox();

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        children: [
          productDetailNew != null
              ? CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: productDetailNew!.imagess!.isNotEmpty
                              ? !productDetailNew!.woofv_video_embed!.url.isEmptyOrNull
                                  ? videoSlider
                                  : imageSlider
                              : SizedBox(),
                        ),
                        expandedHeight: 500,
                        backgroundColor: context.scaffoldBackgroundColor,
                        leading: IconButton(
                          onPressed: () {
                            finish(context, true);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
                        ),
                        actions: [
                          productDetailNew!.on_sale == true
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: primaryColor, borderRadius: radiusOnly(topLeft: 16, bottomLeft: 16)),
                                  child: Row(
                                    children: [
                                      Icon(Fontisto.shopping_sale, size: 16),
                                      6.width,
                                      Text(language.lblSale, style: boldTextStyle(color: Colors.white)),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ]
                        //<Widget>[]
                        ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    mDiscount().paddingOnly(left: 16).visible(
                                        productDetailNew!.type != "grouped" && productDetailNew!.on_sale == true && productDetailNew!.type == "variable" || productDetailNew!.type == "variation"),
                                    Container(
                                      padding: EdgeInsets.only(right: 8, left: 16,bottom: 4,top: 4),
                                      decoration: boxDecorationWithShadow(
                                        borderRadius: radiusOnly(bottomRight: 0, topLeft: 24, topRight: 0, bottomLeft: 24),
                                        backgroundColor: primaryColor,
                                      ),
                                      child: PriceWidget(
                                        salePrice: productDetailNew!.sale_price,
                                        regularPrice: productDetailNew!.regular_price,
                                        regularPriceSize: 24,
                                        salePriceSize: 14,
                                        isSale: productDetailNew!.on_sale,
                                        color: Colors.white,
                                      ),
                                    ).visible(productDetailNew!.type != 'grouped'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productDetailNew!.name.validate(), style: boldTextStyle(size: 20)).paddingTop(4),
                                    8.height.visible(productDetailNew!.average_rating.toDouble() > 0),
                                    Row(
                                      children: [
                                        RatingBarWidget(
                                          onRatingChanged: (c) {
                                            //
                                          },
                                          activeColor: Colors.amber,
                                          disable: true,
                                          size: 18,
                                          rating: productDetailNew!.average_rating.toDouble(),
                                        ),
                                        4.width,
                                        Text("| ${productDetailNew!.average_rating.validate()}", style: primaryTextStyle()).expand(),
                                        Icon(Icons.arrow_forward_ios, color: primaryColor, size: 16)
                                      ],
                                    ).onTap(() {
                                      push(ReviewScreen(productData: productDetailNew!));
                                    }).visible(productDetailNew!.average_rating.toDouble() > 0),
                                    8.height,
                                    if (productDetailNew!.store != null)
                                      Row(
                                        children: [
                                          Text(language.lblSoldBy, style: primaryTextStyle()).visible(productDetailNew!.store!.shopName.validate().isNotEmpty),
                                          8.width,
                                          Text(productDetailNew!.store!.shopName != null ? productDetailNew!.store!.shopName! : '', style: boldTextStyle(color: primaryColor, size: 18)).onTap(() {
                                            VendorDetailScreen(productDetailNew!.store!.id).launch(context);
                                          })
                                        ],
                                      ).visible(productDetailNew!.store!.shopName.validate().isNotEmpty),
                                    // Divider().visible(productDetailNew!.weight.toDouble() != 0 || productDetailNew!.dimensions!.height.toDouble() != 0),
                                    // Text(language.overview, style: boldTextStyle())
                                    //     .paddingOnly(bottom: 8)
                                    //     .visible(productDetailNew!.weight.toDouble() != 0 || productDetailNew!.dimensions!.height.toDouble() != 0),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //   children: [
                                    //     productDetailNew!.weight.toDouble() == 0
                                    //         ? Offstage()
                                    //         : Row(
                                    //             children: [
                                    //               Image.asset(appImages.icPlantWeight, color: context.iconColor, height: 25, width: 25, fit: BoxFit.fill),
                                    //               12.width,
                                    //               Column(
                                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                                    //                 children: [
                                    //                   Text(language.weight.toUpperCase(), style: secondaryTextStyle(size: 12)),
                                    //                   4.height,
                                    //                   Text("${(productDetailNew!.weight.validate().toDouble() ).toStringAsFixed(0)} kg",
                                    //                       style: secondaryTextStyle(size: 14, color: context.iconColor)),
                                    //                 ],
                                    //               ),
                                    //             ],
                                    //           ),
                                    //     if (productDetailNew!.weight.toDouble() != 0 && productDetailNew!.dimensions!.height.toDouble() != 0)
                                    //       Container(height: 24, child: VerticalDivider(color: viewLineColor)),
                                    //     productDetailNew!.dimensions!.height.toDouble() == 0
                                    //         ? Offstage()
                                    //         : Row(
                                    //             children: [
                                    //               Image.asset(appImages.icPlantHeight, color: context.iconColor, height: 25, width: 25, fit: BoxFit.fill),
                                    //               12.width,
                                    //               Column(
                                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                                    //                 children: [
                                    //                   Text(language.height.toUpperCase(), style: secondaryTextStyle(size: 12)),
                                    //                   4.height,
                                    //                   Text("${(productDetailNew!.dimensions!.height.validate().toDouble() * 0.393701).toStringAsFixed(0)} inches",
                                    //                       style: secondaryTextStyle(size: 14, color: context.iconColor)),
                                    //                 ],
                                    //               ),
                                    //             ],
                                    //           ),
                                    //   ],
                                    // ),
                                    // 8.height.visible(productDetailNew!.dimensions != null && productDetailNew!.weight != null),
                                    Divider().visible(productDetailNew!.type == "variable" || productDetailNew!.type == "variation"),
                                    if (productDetailNew!.type == "variable" || productDetailNew!.type == "variation")
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(language.lblAvailableIn, style: boldTextStyle()),
                                          Wrap(
                                            children: mProductOptions.map((e) {
                                              int index = mProductOptions.indexOf(e);
                                              log(mProductOptions);
                                              return Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.all(8),
                                                decoration: boxDecorationWithRoundedCorners(
                                                    backgroundColor: selectedInd == index ? unSelectedColor : context.cardColor, border: Border.all(width: 0.1, color: context.iconColor)),
                                                child: Text(e!, style: secondaryTextStyle()),
                                              ).onTap(() {
                                                setState(
                                                  () {
                                                    mSelectedVariation = e;
                                                    selectedInd = index;
                                                    mProducts.forEach((product) {
                                                      if (mProductVariationsIds[index] == product.id) {
                                                        this.productDetailNew = product;
                                                      }
                                                    });
                                                    setPriceDetail();
                                                    mImage();
                                                  },
                                                );
                                              });
                                            }).toList(),
                                          )
                                        ],
                                      )
                                    else if (productDetailNew!.type == "grouped")
                                      GroupProductComponent(product: mProductsList).visible(mProductsList.isNotEmpty)
                                    else if (productDetailNew!.type == "external")
                                      Container()
                                    else if (productDetailNew!.type == "simple")
                                      Container()
                                    else
                                      mOtherAttribute(),
                                    16.height.visible(productDetailNew!.type == "variable" || productDetailNew!.type == "variation" && productDetailNew!.type == "grouped"),
                                    Divider().visible(productDetailNew!.description.validate().isNotEmpty),
                                    Text(language.lblDescription, style: boldTextStyle()).visible(productDetailNew!.description.validate().isNotEmpty),
                                    HtmlWidget(postContent: productDetailNew!.description.validate()),
                                    AttributeComponent(productDetailNew!),
                                    Divider().visible(productDetailNew!.short_description.validate().isNotEmpty),
                                    if (productDetailNew!.short_description!.isNotEmpty) Text(language.lblShortDescription, style: boldTextStyle()),
                                    if (productDetailNew!.short_description!.isNotEmpty) HtmlWidget(postContent: productDetailNew!.short_description.validate()),
                                    if (!mProducts[0].plant_app_plant_type.isEmptyOrNull ||
                                        !mProducts[0].plant_app_fertile.isEmptyOrNull ||
                                        !mProducts[0].plant_app_light.isEmptyOrNull ||
                                        !mProducts[0].plant_app_temprature.isEmptyOrNull ||
                                        !mProducts[0].plantApp_water.isEmptyOrNull)
                                      Divider(),
                                    if (!mProducts[0].plant_app_plant_type.isEmptyOrNull ||
                                        !mProducts[0].plant_app_fertile.isEmptyOrNull ||
                                        !mProducts[0].plant_app_light.isEmptyOrNull ||
                                        !mProducts[0].plant_app_temprature.isEmptyOrNull ||
                                        !mProducts[0].plantApp_water.isEmptyOrNull)
                                      Text(language.lblTreatment, style: boldTextStyle()).paddingOnly(bottom: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        if (!mProducts[0].plant_app_plant_type.isEmptyOrNull)
                                          overViewProduct(name: mProducts[0].plant_app_plant_type.validate() + language.lblPlant, icon: appImages.icPlantType),
                                        if (!mProducts[0].plant_app_fertile.isEmptyOrNull) overViewProduct(name: mProducts[0].plant_app_fertile.validate(), icon: appImages.icPlantFertile),
                                        if (!mProducts[0].plant_app_light.isEmptyOrNull) overViewProduct(name: mProducts[0].plant_app_light.validate(), icon: appImages.icPlantLight),
                                        if (!mProducts[0].plant_app_temprature.isEmptyOrNull)
                                          overViewProduct(name: mProducts[0].plant_app_temprature.validate(), icon: appImages.icPlantTemprature),
                                        if (!mProducts[0].plantApp_water.isEmptyOrNull) overViewProduct(name: mProducts[0].plantApp_water.validate(), icon: appImages.icPlantWater),
                                      ],
                                    ),
                                    16.height,
                                    if (mProducts[0].categories != null)
                                      CategoryComponent(categoryData: mProducts[0].categories!).visible(mProducts[0].categories.validate().isNotEmpty),
                                    16.height,
                                    if (mProducts[0].upsell_id.validate().isNotEmpty) SimilarProductComponent(upSells: mProducts[0].upsell_id.validate()),
                                    FutureBuilder<List<ReviewResponse>>(
                                      future: reviewApi.getProductReview(id: productDetailNew!.id.validate()),
                                      builder: (context, snap) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            (snap.hasData && snap.data!.isNotEmpty)
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Divider(),
                                                      Text(language.user_reviews, style: boldTextStyle(size: 16)),
                                                      8.height,
                                                      if (snap.data!.isNotEmpty)
                                                        ...List.generate(
                                                          snap.data!.length,
                                                          (index) {
                                                            return ReviewCardComponent(data: snap.data![index], productData: productDetailNew!, isDetail: true);
                                                          },
                                                        ),
                                                    ],
                                                  )
                                                : SizedBox()
                                          ],
                                        );
                                      },
                                    )
                                  ],
                                ).paddingOnly(left: 16, right: 16),
                              ],
                            ),
                          ],
                        ),
                        childCount: 1,
                      ),
                    ),
                  ],
                ).visible(!appStore.isLoading)
              : Container(),
          Observer(builder: (context) {
            return AppLoader().center().visible(appStore.isLoading);
          })
        ],
      ),
      bottomNavigationBar: productDetailNew != null
          ? Container(
              color: context.scaffoldBackgroundColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FavoriteProductComponent(productDetailNew),
                  10.width,
                  AddToCartComponent(
                      productDetailResponse: productDetailNew!,
                      onUpdate: () {
                        init();
                        setState(() {});
                      }).expand(),
                ],
              ),
            ).paddingSymmetric(horizontal: 16, vertical: 8).visible(productDetailNew!.type != "grouped")
          : SizedBox(),
    );
  }
}

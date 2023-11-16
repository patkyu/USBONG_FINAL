import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/ProductDetailResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/screens/AddProductScreen.dart';
import 'package:mighty_plant_admin/screens/ZoomImageScreen.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  final int? mProId;
  final bool isShowEdit;
  final Function(int?)? onDelete;
  final Function()? onUpdate;

  ProductDetailScreen({Key? key, this.mProId, this.isShowEdit = false, this.onDelete, this.onUpdate}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  PageController _pageController = PageController(initialPage: 0);

  bool mIsGroupedProduct = false;

  String? mSelectedVariation = '';
  double rating = 0.0;
  num discount = 0;
  DateTime saleStartFrom = DateTime.now();
  DateTime saleStartTo = DateTime.now();

  ProductDetailResponse1? mProducts;
  ProductDetailResponse1? productDetailNew;
  ProductDetailResponse1? mainProduct;

  List<ProductDetailResponse1> mProductsList = [];
  List<int> mProductVariationsIds = [];
  List<String?> mProductOptions = [];

  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.transparent);
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    productDetail();
  }

  Future deleteProductApi() async {
    appStore.setLoading(true);
    await deleteProduct(widget.mProId).then((value) {
      toast('lbl_remove_product'.translate);
      finish(context);
      widget.onDelete!.call(widget.mProId);
    }).catchError((onError) {
      toast(onError.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future productDetail() async {
    appStore.setLoading(true);

    await getProductDetail(widget.mProId).then((res) {
      if (!mounted) return;
      mProducts = ProductDetailResponse1.fromJson(res);
      if (mProducts != null) {
        productDetailNew = mProducts;
        mainProduct = mProducts;
        rating = double.parse(mainProduct!.averageRating);
        productDetailNew!.variations!.forEach((element) {
          mProductVariationsIds.add(element);
        });
        mProductsList.clear();
        if (mainProduct!.type == "variable") {
          mProductOptions.clear();
          mProductsList.forEach((product) {
            String? option = '';
            product.attributes!.forEach(
              (attribute) {
                if (option!.isNotEmpty) {
                  option = '$option - ${attribute.options}';
                } else {
                  option = attribute.options as String?;
                }
              },
            );
            if (product.onSale!) {
              option = '$option [Sale]';
            }
            mProductOptions.add(option);
          });
          if (mProductOptions.isNotEmpty) mSelectedVariation = mProductOptions.first;
          if (mainProduct!.type == "variable" && mProductsList.isNotEmpty) {
            productDetailNew = mProductsList[0];
            mProducts = mProducts;
          }
        } else if (mainProduct!.type == 'grouped') {
          mIsGroupedProduct = true;
        }
        setPriceDetail();
      }
      setState(() {});
    }).catchError((error) {
      toast(error.toString(), print: true);
      setState(() {});
    }).whenComplete(() => appStore.setLoading(false));
  }

  // ignore: missing_return
  void setPriceDetail() {
    setState(() {
      if (productDetailNew!.onSale!) {
        num mrp = productDetailNew!.regularPrice!.toDouble();
        num discountPrice = productDetailNew!.price!.toDouble();
        discount = ((mrp - discountPrice) / mrp) * 100;
      }
    });
  }

  String getAllAttribute(Attributes attribute) {
    String attributes = "";
    for (var i = 0; i < attribute.options!.length; i++) {
      attributes = attributes + attribute.options![i];
      if (i < attribute.options!.length - 1) {
        attributes = attributes + ", ";
      }
    }
    return attributes;
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(primaryColor);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              setStatusBarColor(Colors.transparent, statusBarIconBrightness: innerBoxIsScrolled ? Brightness.light : Brightness.dark);
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 350,
                  collapsedHeight: kToolbarHeight,
                  elevation: 0,
                  backgroundColor: innerBoxIsScrolled ? primaryColor : Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () {
                      finish(context);
                    },
                    icon: Icon(Icons.arrow_back, color: (innerBoxIsScrolled || appStore.isDarkModeOn) ? white : black),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: mainProduct != null
                        ? Container(
                            margin: EdgeInsets.only(top: 80),
                            height: 350,
                            child: mainProduct!.images!.isNotEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PageView.builder(
                                        controller: _pageController,
                                        physics: PageScrollPhysics(),
                                        itemCount: mainProduct!.images!.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  ZoomImageScreen(mProductImage: mainProduct!.images![i].src).launch(context);
                                                });
                                              },
                                              child: cachedImage(mainProduct!.images![i].src, height: 200, width: 200, fit: BoxFit.contain));
                                        },
                                      ).withHeight(200),
                                      10.height,
                                      DotIndicator(
                                        pageController: _pageController,
                                        pages: mainProduct!.images!,
                                        indicatorColor: primaryColor,
                                        unselectedIndicatorColor: grey,
                                        currentBoxShape: BoxShape.rectangle,
                                        boxShape: BoxShape.rectangle,
                                        borderRadius: radius(2),
                                        currentBorderRadius: radius(3),
                                        currentDotSize: 18,
                                        currentDotWidth: 6,
                                        dotSize: 6,
                                      ).visible(mainProduct!.images!.length > 1),
                                      10.height,
                                    ],
                                  )
                                : cachedImage('images/place_holder.png', height: 200, width: 200, fit: BoxFit.contain).center(),
                          )
                        : 0.height,
                  ),
                  actions: [
                    commonEditButtonComponent(
                        color: innerBoxIsScrolled ? white : primaryColor,
                        icon: Icons.edit,
                        onCall: () {
                          AddProductScreen(
                            singleProductResponse: mainProduct,
                            isUpdate: true,
                            onUpdate: () {
                              init();
                              widget.onUpdate!.call();
                            },
                          ).launch(context);
                        }).paddingOnly(top: 8, bottom: 8, right: 16).visible(widget.isShowEdit),
                    commonEditButtonComponent(
                        color: redColor,
                        icon: Icons.delete,
                        onCall: () async {
                          if (isVendor) {
                            toast("admin_toast".translate);
                            return;
                          }
                          showConfirmDialogCustom(
                            context,
                            primaryColor: primaryColor,
                            onAccept: (_) {
                              deleteProductApi();
                            },
                            dialogType: DialogType.DELETE,
                            title: "lbl_confirmation_Delete_product".translate,
                            positiveText: 'lbl_Delete'.translate,
                            negativeText: 'lbl_cancel'.translate,
                          );
                        }).paddingOnly(top: 8, bottom: 8, right: 16).visible(widget.isShowEdit),
                  ],
                ),
              ];
            },
            body: Stack(
              children: [
                mainProduct != null
                    ? SingleChildScrollView(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${mainProduct!.name}', style: boldTextStyle(size: 18)).visible(mainProduct!.name != null),
                            16.height,
                            productDetailCard(context, productName: mainProduct!.type, name: 'lbl_Type'.translate).visible(mainProduct!.type!.isNotEmpty),
                            productDetailCard(context, productName: rating.toString(), name: 'lbl_total_ratting'.translate).visible(rating != 0.0),
                            productDetailCard(context, productName: '${discount.toStringAsFixed(2)}%' + "lbl_off1".translate, name: 'lbl_discount_total'.translate)
                                .visible(mainProduct!.type != 'grouped' && mainProduct!.type != 'variation' && mainProduct!.type != 'variable' && discount > 0),
                            productDetailCard(context, productName: mainProduct!.regularPrice.toString(), name: 'lbl_product_regular_price'.translate)
                                .visible(mainProduct!.regularPrice.toString().isNotEmpty),
                            productDetailCard(context, productName: mainProduct!.salePrice, name: 'sale_price'.translate).visible(mainProduct!.salePrice!.isNotEmpty),
                            productDetailCard(context, productName: mainProduct!.status, name: 'lbl_Status'.translate).visible(mainProduct!.status!.isNotEmpty),
                            mainProduct!.attributes!.length > 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("lbl_additional_information".translate, style: boldTextStyle()),
                                      10.height,
                                      UL(
                                        children: List.generate(
                                          mainProduct!.attributes!.length,
                                          (i) => Row(
                                            children: [
                                              Text(mainProduct!.attributes![i].name + " : ", style: primaryTextStyle(color: appStore.textPrimaryColor)),
                                              6.width,
                                              Expanded(child: Text(getAllAttribute(mainProduct!.attributes![i]), maxLines: 4, style: primaryTextStyle(color: appStore.textSecondaryColor)))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(height: 24)
                                    ],
                                  )
                                : SizedBox(),
                            mainProduct!.categories!.length > 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("lbl_Category".translate, style: boldTextStyle()),
                                      10.height,
                                      UL(
                                        children: List.generate(
                                          mainProduct!.categories!.length,
                                          (index) => Text(
                                            mainProduct!.categories![index].name,
                                            style: primaryTextStyle(color: appStore.textSecondaryColor),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Divider(height: 24)
                                    ],
                                  )
                                : SizedBox(),
                            mainProduct!.variations!.length > 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("lbl_variation".translate, style: boldTextStyle()),
                                      10.height,
                                      UL(
                                        children: List.generate(
                                          mainProduct!.variations!.length,
                                          (index) => Text(
                                            mainProduct!.variations![index].toString(),
                                            style: primaryTextStyle(color: appStore.textSecondaryColor),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Divider(height: 24),
                                    ],
                                  )
                                : SizedBox(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("lbl_upcoming_sale_on_this_item".translate, style: boldTextStyle()),
                                10.height,
                                UL(
                                  children: [
                                    Text(
                                      "lbl_sale_start_from".translate +
                                          " " +
                                          ' ${mainProduct!.dateOnSaleFrom.toString()} ' +
                                          " " +
                                          "lbl_to".translate +
                                          " " +
                                          '${mainProduct!.dateOnSaleTo.toString()}' +
                                          " " +
                                          "lbl_ge_amazing_discounts_on_the_products".translate,
                                      style: primaryTextStyle(color: appStore.textSecondaryColor),
                                      textAlign: TextAlign.justify,
                                    )
                                  ],
                                ),
                                Divider(height: 24),
                              ],
                            ).visible(mainProduct!.dateOnSaleFrom != null && mainProduct!.dateOnSaleTo != null),
                            productDetailCard(context, productName: parseHtmlString(mainProduct!.description), name: 'hint_description'.translate).visible(mainProduct!.description!.isNotEmpty),
                            productDetailCard(context, productName: parseHtmlString(mainProduct!.shortDescription), name: 'lbl_short_product_description'.translate, isShowDivider: false)
                                .visible(mainProduct!.shortDescription!.isNotEmpty),
                            16.height,
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Observer(builder: (_) => Center(child: loading()).visible(appStore.isLoading)),
        ],
      ),
    );
  }
}

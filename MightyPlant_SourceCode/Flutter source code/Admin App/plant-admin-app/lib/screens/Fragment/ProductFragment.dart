import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/component/ProductItemWidget.dart';
import 'package:mighty_plant_admin/models/ProductDetailResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../AddProductScreen.dart';

class ProductFragment extends StatefulWidget {
  static String tag = '/ProductFragment';

  @override
  ProductFragmentState createState() => ProductFragmentState();
}

class ProductFragmentState extends State<ProductFragment> {
  bool switchValue = false;
  bool mIsLastPage = false;
  List<ProductDetailResponse1> mProductModel = [];
  ScrollController scrollController = ScrollController();
  String mErrorMsg = '';
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;
          fetchProductData();
        }
      }
    });
  }

  Future<void> init() async {
    fetchProductData();
  }

  Future fetchProductData() async {
    appStore.setLoading(true);
    await getAllProducts(page).then((res) {
      mProductModel.addAll(res);
      mIsLastPage = res.length != perPage;
      setState(() {});
    }).catchError((error) {
      mErrorMsg = error.toString();
      setState(() {});
    }).whenComplete(() => appStore.setLoading(false));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        titleWidget: Row(
          children: [
            cachedImage(app_logo, height: 50, width: 50, color: white),
            8.width,
            Text("lbl_my_products".translate, style: boldTextStyle(color: white, size: 20)),
          ],
        ),
        elevation: 0,
        color: primaryColor,
        showBack: false,
        center: false,
      ),
      body: Stack(
        children: [
          mProductModel.isNotEmpty
              ? SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 70),
                  controller: scrollController,
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: mProductModel.map((data) {
                      return ProductItemWidget(
                        product: data,
                        onUpdate: () {
                          mProductModel.clear();
                          page = 1;
                          init();
                        },
                        onDelete: (id) {
                          mProductModel.clear();
                          page = 1;
                          init();
                        },
                      );
                    }).toList(),
                  ).paddingAll(16),
                )
              : NoDataFound(
                  title: 'lbl_no_data'.translate,
                  onPressed: () {
                    fetchProductData();
                  },
                ).center().visible(!appStore.isLoading && mProductModel.isEmpty),
          Observer(builder: (_) => loading().visible(appStore.isLoading)),
          Text(mErrorMsg.validate(), style: primaryTextStyle()).center(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '1',
        elevation: 5,
        backgroundColor: primaryColor,
        onPressed: () {
          AddProductScreen(
              isUpdate: false,
              onUpdate: () {
                mProductModel.clear();
                init();
              }).launch(context);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

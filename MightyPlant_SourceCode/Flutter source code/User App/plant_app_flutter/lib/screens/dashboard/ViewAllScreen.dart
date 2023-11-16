import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AdComponent.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/model/product/ProductResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/dashboard/component/ProductComponent.dart';

class ViewAllScreen extends StatefulWidget {
  final String type;
  final String test;
  final String valueType;

  ViewAllScreen({required this.type, required this.valueType, required this.test});

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  Map<String, dynamic> request = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    request = {
      "text": "",
      "item_type": "",
      "attribute": [],
      "price": [],
      "page": 1,
      "product_per_page": 30,
      widget.type: widget.test,
    };
    setState(() {});
    log(request);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.valueType, textColor: Colors.white,backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: FutureBuilder<ProductResponse>(
        future: categoryApi.getProductListBySection(req: request),
        builder: (context, snap) {
          if (snap.hasData) {
            log(snap.data!.productData!.length);
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  snap.data!.productData!.length,
                  (index) => ProductComponent(
                    itemData: ProductListResponse(
                      average_rating: snap.data!.productData![index].average_rating,
                      description: snap.data!.productData![index].description,
                      featured: snap.data!.productData![index].featured,
                      id: snap.data!.productData![index].id,
                      images: snap.data!.productData![index].images,
                      in_stock: snap.data!.productData![index].in_stock,
                      is_added_cart: snap.data!.productData![index].is_added_cart,
                      is_added_wishlist: snap.data!.productData![index].is_added_wishlist,
                      manage_stock: snap.data!.productData![index].manage_stock,
                      name: snap.data!.productData![index].name,
                      on_sale: snap.data!.productData![index].on_sale,
                      permalink: snap.data!.productData![index].permalink,
                      plant_product_type: snap.data!.productData![index].plant_product_type,
                      price: snap.data!.productData![index].price,
                      rating_count: snap.data!.productData![index].rating_count,
                      regular_price: snap.data!.productData![index].regular_price,
                      sale_price: snap.data!.productData![index].sale_price,
                      short_description: snap.data!.productData![index].short_description,
                      status: snap.data!.productData![index].status,
                      stock_quantity: snap.data!.productData![index].stock_quantity,
                      type: snap.data!.productData![index].type,
                    ),
                    index: index,
                    heroAnimationUniqueValue: widget.valueType,
                  ),
                ),
              ),
            );
          }
          return snapWidgetHelper(snap, loadingWidget: AppLoader().center());
        },
      ),
      bottomNavigationBar:  Container(
        height: 60,
        child: AdWidget(
          ad: BannerAd(
            adUnitId: kReleaseMode ? getBannerAdUnitId()! : BannerAd.testAdUnitId,
            size: AdSize.banner,
            request: AdRequest(),
            listener: BannerAdListener(),
          )..load(),
        ),
      ),
    );
  }
}

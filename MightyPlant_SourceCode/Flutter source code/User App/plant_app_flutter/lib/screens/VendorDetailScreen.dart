import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/model/dashboard/VendorResponse.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/model/product/ProductResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/dashboard/component/ProductComponent.dart';

import '../main.dart';

class VendorDetailScreen extends StatefulWidget {
  final int? id;

  VendorDetailScreen(this.id);

  @override
  _VendorDetailScreenState createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  VendorsResponse? mVendorModel;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    fetchVendorProfile();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future fetchVendorProfile() async {
    await vendorApi.getVendorProfile(widget.id).then((res) {
      mVendorModel = res;
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      print("error" + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(mVendorModel != null ? mVendorModel!.storeName.validate() : "",
          textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mVendorModel != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mVendorModel!.banner!.isNotEmpty
                          ? Container(
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(mVendorModel!.banner.validate())),
                              ),
                            ).cornerRadiusWithClipRRect(defaultRadius).paddingAll(14)
                          : SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mVendorModel!.storeName != null ? mVendorModel!.storeName! : '', style: boldTextStyle(size: 18)).visible(mVendorModel!.storeName!.isNotEmpty),
                          6.height.visible(!mVendorModel!.phone.isEmptyOrNull),
                          Text(mVendorModel!.phone.validate(), style: primaryTextStyle()).visible(mVendorModel!.phone!.isNotEmpty),
                          6.height.visible(mVendorModel!.phone!.isNotEmpty),
                          Text(
                              '${mVendorModel!.address!.street1.validate()},'
                              '\n${mVendorModel!.address!.street2.validate()},'
                              '\n${mVendorModel!.address!.city.validate()},'
                              ' ${mVendorModel!.address!.state.validate()} '
                              '- ${mVendorModel!.address!.zip.validate()},'
                              '\n${mVendorModel!.address!.country.validate()}',
                              style: primaryTextStyle(size: 12)),
                          10.height,
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    ],
                  )
                : SizedBox(),
            FutureBuilder<List<ProductData>>(
                future: vendorApi.getVendorProduct(widget.id),
                builder: (context, snap) {
                  if (snap.hasData) {
                    if (snap.data!.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Products', style: boldTextStyle(size: 18)).visible(snap.data != null),
                          16.height,
                          AnimationLimiter(
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: List.generate(snap.data!.length, (index) {
                                ProductData value = snap.data![index];
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  columnCount: 2,
                                  duration: const Duration(milliseconds: 600),
                                  child: FlipAnimation(
                                    duration: const Duration(milliseconds: 600),
                                    flipAxis: FlipAxis.y,
                                    child: ProductComponent(
                                      itemData: ProductListResponse(
                                        average_rating: value.average_rating,
                                        description: value.description,
                                        featured: value.featured,
                                        id: value.id,
                                        images: value.images,
                                        in_stock: value.in_stock,
                                        is_added_cart: value.is_added_cart,
                                        is_added_wishlist: value.is_added_wishlist,
                                        manage_stock: value.manage_stock,
                                        name: value.name,
                                        on_sale: value.on_sale,
                                        permalink: value.permalink,
                                        plant_product_type: value.plant_product_type,
                                        price: value.price,
                                        rating_count: value.rating_count,
                                        regular_price: value.regular_price,
                                        sale_price: value.sale_price,
                                        short_description: value.short_description,
                                        status: value.status,
                                        stock_quantity: value.stock_quantity,
                                        type: value.type,
                                      ),
                                      index: index,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 16);
                    } else {
                      NoDataWidget(title: "No Product");
                    }
                  }
                  return snapWidgetHelper(snap, loadingWidget: AppLoader().center(), errorWidget: Offstage());
                })
          ],
        ),
      ),
    );
  }
}

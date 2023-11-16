import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:plant_flutter/components/AppLoader.dart';

import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/category/CategoryResponse.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/model/product/ProductResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/category/component/CategoryComponent.dart';
import 'package:plant_flutter/screens/dashboard/component/ProductComponent.dart';

class SubCategoryProductScreen extends StatefulWidget {
  final CategoryResponse parentCategory;

  SubCategoryProductScreen({required this.parentCategory});

  @override
  SubCategoryProductScreenState createState() => SubCategoryProductScreenState();
}

class SubCategoryProductScreenState extends State<SubCategoryProductScreen> {
  bool isNoData = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("${widget.parentCategory.name}", backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context)), textColor: Colors.white),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<CategoryResponse>>(
                    future: categoryApi.getCategories(catId: widget.parentCategory.term_id.validate()),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        if (snap.data!.isNotEmpty) {
                          return AnimationLimiter(
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
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      horizontalOffset: 20.0,
                                      curve: Curves.linear,
                                      child: FadeInAnimation(
                                        child: CategoryComponent(value: data),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 16, vertical: 16);
                        }
                      }
                      return snapWidgetHelper(snap, loadingWidget: SizedBox());
                    }),
                FutureBuilder<ProductResponse>(
                  future: categoryApi.getProductListByCategory(catId: widget.parentCategory.cat_ID.validate()),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (snap.data!.productData!.isEmpty) {
                        appStore.setLoading(false);
                        return NoDataWidget().center();
                      } else {
                        afterBuildCreated(() {
                          appStore.setLoading(false);
                        });
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(
                              snap.data!.productData!.length,
                              (index) => ProductComponent(
                                  itemData: ProductListResponse(
                                    average_rating: snap.data!.productData![index].average_rating.validate(),
                                    description: snap.data!.productData![index].description.validate(),
                                    featured: snap.data!.productData![index].featured.validate(),
                                    id: snap.data!.productData![index].id.validate(),
                                    images: snap.data!.productData![index].images.validate(),
                                    in_stock: snap.data!.productData![index].in_stock.validate(),
                                    is_added_cart: snap.data!.productData![index].is_added_cart.validate(),
                                    is_added_wishlist: snap.data!.productData![index].is_added_wishlist.validate(),
                                    manage_stock: snap.data!.productData![index].manage_stock.validate(),
                                    name: snap.data!.productData![index].name.validate(),
                                    on_sale: snap.data!.productData![index].on_sale.validate(),
                                    permalink: snap.data!.productData![index].permalink.validate(),
                                    plant_product_type: snap.data!.productData![index].plant_product_type.validate(),
                                    price: snap.data!.productData![index].price.validate(),
                                    rating_count: snap.data!.productData![index].rating_count.validate(),
                                    regular_price: snap.data!.productData![index].regular_price.validate(),
                                    sale_price: snap.data!.productData![index].sale_price.validate(),
                                    short_description: snap.data!.productData![index].short_description.validate(),
                                    status: snap.data!.productData![index].status.validate(),
                                    stock_quantity: snap.data!.productData![index].stock_quantity.validate(),
                                    type: snap.data!.productData![index].type.validate(),
                                  ),
                                  index: index)),
                        ).paddingSymmetric(horizontal: 16, vertical: 16);
                      }
                    }
                    return snapWidgetHelper(snap, loadingWidget: SizedBox().center());
                  },
                ),
              ],
            ),
          ),
          Observer(builder: (context) {
            return AppLoader().center().visible(appStore.isLoading);
          })
        ],
      ),
    );
  }
}

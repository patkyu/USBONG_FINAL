import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/model/dashboard/DashboardResponse.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/dashboard/component/ProductComponent.dart';

class ViewAllScreenCustom extends StatefulWidget {
  final int index;
  final String valueType;

  ViewAllScreenCustom({required this.index, required this.valueType});

  @override
  _ViewAllScreenCustomState createState() => _ViewAllScreenCustomState();
}

class _ViewAllScreenCustomState extends State<ViewAllScreenCustom> {
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
      appBar: appBarWidget(widget.valueType, textColor: Colors.white,backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: FutureBuilder<List<DashboardResponse>>(
        future: dashboardApi.getViewALlCustomDataList(id: widget.index),
        builder: (context, snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  snap.data!.first.productData!.length,
                  (index) => ProductComponent(
                    itemData: ProductListResponse(
                      average_rating: snap.data!.first.productData![index].average_rating,
                      description: snap.data!.first.productData![index].description,
                      featured: snap.data!.first.productData![index].featured,
                      id: snap.data!.first.productData![index].id,
                      images: snap.data!.first.productData![index].images,
                      in_stock: snap.data!.first.productData![index].in_stock,
                      is_added_cart: snap.data!.first.productData![index].is_added_cart,
                      is_added_wishlist: snap.data!.first.productData![index].is_added_wishlist,
                      manage_stock: snap.data!.first.productData![index].manage_stock,
                      name: snap.data!.first.productData![index].name,
                      on_sale: snap.data!.first.productData![index].on_sale,
                      permalink: snap.data!.first.productData![index].permalink,
                      plant_product_type: snap.data!.first.productData![index].plant_product_type,
                      price: snap.data!.first.productData![index].price,
                      rating_count: snap.data!.first.productData![index].rating_count,
                      regular_price: snap.data!.first.productData![index].regular_price,
                      sale_price: snap.data!.first.productData![index].sale_price,
                      short_description: snap.data!.first.productData![index].short_description,
                      status: snap.data!.first.productData![index].status,
                      stock_quantity: snap.data!.first.productData![index].stock_quantity,
                      type: snap.data!.first.productData![index].type,
                    ),
                    index: index,
                    heroAnimationUniqueValue: widget.valueType,
                  ),
                ),
              ).paddingTop(30),
            );
          }
          return snapWidgetHelper(snap, loadingWidget: AppLoader().center());
        },
      ),
    );
  }
}

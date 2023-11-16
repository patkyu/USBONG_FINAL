import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/ProductDetailResponse.dart';
import 'package:mighty_plant_admin/screens/ProductDetailScreen.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductItemWidget extends StatefulWidget {
  static String tag = '/ProductItemWidget';
  final ProductDetailResponse1? product;
  final Function? onDelete;
  final Function? onUpdate;

  ProductItemWidget({this.product, this.onDelete, this.onUpdate});

  @override
  ProductItemWidgetState createState() => ProductItemWidgetState();
}

class ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    String? img = widget.product!.images!.isNotEmpty ? widget.product!.images!.first.src : '';
    return Container(
      width: context.width() / 2 - 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: context.width(),
            decoration: boxDecorationDefault(
              borderRadius: radius(8),
              boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
              color: context.cardColor,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cachedImage(img, height: 150, fit: BoxFit.cover).center(),
                    8.height,
                    Text('${widget.product!.name}', style: boldTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 2),
                    4.height,
                    Row(
                      children: [
                        PriceWidget(
                          price: widget.product!.onSale == true
                              ? widget.product!.salePrice.validate().isNotEmpty
                                  ? widget.product!.salePrice.toString()
                                  : widget.product!.price.validate()
                              : widget.product!.regularPrice!.isNotEmpty
                                  ? widget.product!.regularPrice.validate().toString()
                                  : widget.product!.price.validate().toString(),
                          size: 16,
                          color: appStore.textPrimaryColor,
                        ).visible(widget.product!.salePrice.validate().isNotEmpty || widget.product!.regularPrice!.isNotEmpty),
                        8.width,
                        PriceWidget(
                          price: widget.product!.regularPrice.validate().toString(),
                          size: 16,
                          isLineThroughEnabled: true,
                          color: widget.product!.onSale! ? Colors.grey : appStore.textPrimaryColor,
                        ).visible(widget.product!.salePrice.validate().isNotEmpty && widget.product!.onSale == true),
                      ],
                    ),
                  ],
                ).paddingAll(16),
                mSale(widget.product!),
              ],
            ),
          ),
        ],
      ),
    ).onTap(() {
      ProductDetailScreen(
        mProId: widget.product!.id,
        isShowEdit: true,
        onDelete: (int? id) {
          widget.onDelete!.call(id);
        },
        onUpdate: () {
          widget.onUpdate!.call();
        },
      ).launch(context);
    });
  }
}

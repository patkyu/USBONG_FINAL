import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/model/product/ProductResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
import 'package:plant_flutter/screens/product/ProductDetailScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';

class ProductComponent extends StatefulWidget {
  final ProductListResponse itemData;
  final int index;
  final String? heroAnimationUniqueValue;

  ProductComponent({required this.itemData, required this.index, this.heroAnimationUniqueValue});

  @override
  State<ProductComponent> createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  int? selectedItem;

  late ProductListResponse itemData;

  ProductData? previousData;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    itemData = widget.itemData;
    previousData = ProductData(
      average_rating: itemData.average_rating.validate(),
      description: itemData.description.validate(),
      featured: itemData.featured.validate(),
      id: itemData.id.validate(),
      images: itemData.images.validate(),
      in_stock: itemData.in_stock.validate(),
      is_added_cart: itemData.is_added_cart.validate(),
      is_added_wishlist: itemData.is_added_wishlist.validate(),
      manage_stock: itemData.manage_stock.validate(),
      name: itemData.name.validate(),
      on_sale: itemData.on_sale.validate(),
      permalink: itemData.permalink.validate(),
      plant_product_type: itemData.plant_product_type.validate(),
      price: itemData.price.validate(),
      rating_count: itemData.rating_count.validate(),
      regular_price: itemData.regular_price.validate(),
      sale_price: itemData.sale_price.validate(),
      short_description: itemData.short_description.validate(),
      status: itemData.status.validate(),
      stock_quantity: itemData.stock_quantity.validate(),
      type: itemData.type.validate(),
    );
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void addToCart() {
    if (itemData.in_stock.validate(value: false)) {
      selectedItem = itemData.id;
      appStore.setLoading(true);
      cartApi.addToCart(pId: itemData.id.validate(), qty: 1).then((value) {
        toast(value.message);
        productStore.addToCartList(prodId: itemData.id!);
        setState(() {});
      }).catchError((e) {
        toast(e.toString(), print: true);
      }).whenComplete(() {
        appStore.setLoading(false);
        selectedItem = 0;
      });
    } else {
      toast(language.out_Of_Stock);
    }
  }

  void removeFromCart() {
    if (itemData.in_stock.validate(value: false)) {
      selectedItem = itemData.id;
      cartApi.removeFromCart(pId: itemData.id.validate()).then((value) {
        toast(value.message);
        productStore.removeFromCartList(prodId: itemData.id!);
        setState(() {});
      }).catchError((e) {
        toast(e.toString(), print: true);
      }).whenComplete(() {
        selectedItem = 0;
      });
    } else {
      toast(language.out_Of_Stock);
    }
  }

  Widget cartWidget({required Widget child, Color? color, required Function() onTap}) {
    return Container(
      decoration: boxDecorationDefault(
        borderRadius: radiusOnly(bottomRight: 12, topLeft: 12),
        color: primaryColor,
      ),
      child: SizedBox(
        height: 40,
        width: 40,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: (appStore.isLoading && selectedItem == itemData.id)
              ? Loader(
                  color: Colors.transparent,
                  accentColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : child,
          onPressed: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        push(ProductDetailScreen(id: previousData!.id!.toInt(), uniqueKeyForAnimation: widget.heroAnimationUniqueValue), duration: 800.milliseconds, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      child: Container(
        width: context.width() / 2 - 24,
        decoration: boxDecorationWithShadow(
            boxShadow: appStore.isDarkMode ? defaultBoxShadow(blurRadius: 0, spreadRadius: 0) : defaultBoxShadow(blurRadius: 24, spreadRadius: 2),
            borderRadius: radius(),
            backgroundColor: context.cardColor),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                34.height,
                Hero(tag: "${itemData.id}${widget.heroAnimationUniqueValue}", child: cachedImage(itemData.images!.first.src, height: 150)).center(),
                8.height,
                Text('${itemData.name.validate()}', style: boldTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 2),
                4.height,
                if (itemData.type != "grouped" && itemData.type != "variation" && itemData.type != "variable" && itemData.type != 'external')
                  PriceWidget(salePrice: itemData.sale_price, regularPrice: itemData.regular_price, regularPriceSize: 18, isSale: itemData.on_sale),
                8.height,
              ],
            ).paddingAll(8),
            if (itemData.type != "grouped" && itemData.type != "variation" && itemData.type != "variable" && itemData.type != 'external')
              Positioned(
                bottom: 0,
                right: 0,
                child: Observer(
                  builder: (_) {
                    if (productStore.isItemInCart(prodId: itemData.id!)) {
                      return cartWidget(
                        child: Icon(MaterialIcons.remove_shopping_cart, color: Colors.white, size: 20),
                        onTap: () {
                          ifLoggedIn(() {
                            removeFromCart();
                          });
                        },
                      );
                    } else if (!itemData.in_stock.validate()) {
                      return SizedBox();
                    } else {
                      return cartWidget(
                        child: Icon(MaterialIcons.add_shopping_cart, color: Colors.white, size: 20),
                        onTap: () {
                          ifLoggedIn(() {
                            addToCart();
                          });
                        },
                      );
                    }
                  },
                ),
              ).visible(getStringAsync(SELECTED_LANGUAGE_CODE) != 'ar'),
            if (itemData.type != "grouped" && itemData.type != "variation" && itemData.type != "variable" && itemData.type != 'external')
              Positioned(
                bottom: 0,
                left: 0,
                child: Observer(
                  builder: (_) {
                    if (productStore.isItemInCart(prodId: itemData.id!)) {
                      return cartWidget(
                        child: Icon(MaterialIcons.remove_shopping_cart, color: Colors.white, size: 20),
                        onTap: () {
                          ifLoggedIn(() {
                            removeFromCart();
                          });
                        },
                      );
                    } else if (!itemData.in_stock.validate()) {
                      return SizedBox();
                    } else {
                      return cartWidget(
                        child: Icon(MaterialIcons.add_shopping_cart, color: Colors.white, size: 20),
                        onTap: () {
                          ifLoggedIn(() {
                            addToCart();
                          });
                        },
                      );
                    }
                  },
                ),
              ).visible(getStringAsync(SELECTED_LANGUAGE_CODE) == 'ar'),
            if (itemData.type != "grouped" && itemData.type != "variation" && itemData.type != "variable" && itemData.type != 'external')
              Positioned(
                  top: 0,
                  right: 0,
                  child: Observer(builder: (context) {
                    return IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.all(0),
                      icon: wishCartStore.isItemInWishlist(itemData.id!) ? Icon(MaterialIcons.bookmark, color: primaryColor) : Icon(MaterialIcons.bookmark_border, color: primaryColor),
                      onPressed: () {
                        ifLoggedIn(() {
                          addItemToWishlist(data: itemData);
                        });
                      },
                    );
                  })),
          ],
        ),
      ),
    );
  }
}

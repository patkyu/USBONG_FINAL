import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/wishlist/WishlistResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
import 'package:plant_flutter/screens/product/ProductDetailScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';

class WishListComponent extends StatefulWidget {
  final WishlistResponse itemData;
  final int index;
  final String? heroAnimationUniqueValue;
  final bool? isBookmark;
  final Function? onCall;

  WishListComponent({required this.itemData, required this.index, this.heroAnimationUniqueValue,this.isBookmark=false,this.onCall});

  @override
  State<WishListComponent> createState() => _WishListComponentState();
}

class _WishListComponentState extends State<WishListComponent> {
  int? selectedItem;

  late WishlistResponse itemData;

  @override
  void initState() {
    super.initState();
    init();
    print("akxx");
  }

  void init() async {
    itemData = widget.itemData;
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void addToCart() {
    if (itemData.in_stock.validate(value: false)) {
      selectedItem = itemData.pro_id;
      appStore.setLoading(true);
      cartApi.addToCart(pId: itemData.pro_id.validate(), qty: 1).then((value) {
        toast(value.message);
        productStore.addToCartList(prodId: itemData.pro_id!);
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
      selectedItem = itemData.pro_id;
      cartApi.removeFromCart(pId: itemData.pro_id.validate()).then((value) {
        toast(value.message);
        productStore.removeFromCartList(prodId: itemData.pro_id!);
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
        color:  primaryColor,
      ),
      child: SizedBox(
        height: 40,
        width: 40,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: (appStore.isLoading && selectedItem == itemData.pro_id)
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
        push(ProductDetailScreen(id: itemData.pro_id!.toInt(), uniqueKeyForAnimation: widget.heroAnimationUniqueValue), duration: 800.milliseconds, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      child: Container(
        width: context.width() / 2 - 24,
        decoration: boxDecorationWithShadow(boxShadow:appStore.isDarkMode?defaultBoxShadow(blurRadius: 0, spreadRadius: 0): defaultBoxShadow(blurRadius: 24, spreadRadius: 2), borderRadius: radius(),backgroundColor: context.cardColor),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                34.height,
                cachedImage(itemData.full!.validate(), height: 150).center(),
                8.height,
                Text('${itemData.name.validate()}', style: boldTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 2),
                4.height,
                if (itemData.plant_product_type != "grouped" && itemData.plant_product_type != "variation" && itemData.plant_product_type != "variable" && itemData.plant_product_type != 'external')
                  PriceWidget(salePrice: itemData.sale_price, regularPrice: itemData.regular_price, regularPriceSize: 18),
                8.height,
              ],
            ).paddingAll(8),

            if (itemData.plant_product_type != "grouped" && itemData.plant_product_type != "variation" && itemData.plant_product_type != "variable" && itemData.plant_product_type != 'external')
              Positioned(
                bottom: 0,
                right: 0,
                child: Observer(
                  builder: (_) {
                    if (productStore.isItemInCart(prodId: itemData.pro_id!)) {
                      return cartWidget(
                        child: Icon(MaterialIcons.remove_shopping_cart, color:  Colors.white, size: 20),
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
              ).visible( getStringAsync(SELECTED_LANGUAGE_CODE)!='ar'),
            if (itemData.plant_product_type != "grouped" && itemData.plant_product_type != "variation" && itemData.plant_product_type != "variable" && itemData.plant_product_type != 'external')
              Positioned(
                bottom: 0,
                left:  0,
                child: Observer(
                  builder: (_) {
                    if (productStore.isItemInCart(prodId: itemData.pro_id!)) {
                      return cartWidget(
                        child: Icon(MaterialIcons.remove_shopping_cart, color:  Colors.white, size: 20),
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
              ).visible( getStringAsync(SELECTED_LANGUAGE_CODE)=='ar'),
            if (itemData.plant_product_type != "grouped" && itemData.plant_product_type != "variation" && itemData.plant_product_type != "variable" && itemData.plant_product_type != 'external')
              Positioned(
                  top: 0,
                  right: 0,
                  child: Observer(builder: (context) {
                    return IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.all(0),
                      icon: wishCartStore.isItemInWishlist(itemData.pro_id!) ? Icon(MaterialIcons.bookmark, color: primaryColor) : Icon(MaterialIcons.bookmark_border, color: primaryColor),
                      onPressed: () {

                            WishlistResponse mWishListModel = WishlistResponse();
                            var mList = <String>[];
                            itemData.gallery.forEachIndexed((element, index) {
                              mList.add(element);
                            });
                            mWishListModel.name = itemData.name;
                            mWishListModel.pro_id = itemData.pro_id;
                            mWishListModel.sale_price = itemData.sale_price;
                            mWishListModel.regular_price = itemData.regular_price;
                            mWishListModel.price = itemData.price;
                            mWishListModel.gallery = mList;
                            mWishListModel.stock_quantity = '1';
                            mWishListModel.thumbnail = "";
                            mWishListModel.full = itemData.full;
                            mWishListModel.sku = "";
                            mWishListModel.created_at = "";
                            widget.onCall!();
                      },
                    );
                  })),
          ],
        ),
      ),
    );
  }
}

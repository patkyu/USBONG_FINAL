// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:plant_flutter/main.dart';
// import 'package:plant_flutter/model/product/ProductResponse.dart';
// import 'package:plant_flutter/network/RestApi.dart';
// import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
// import 'package:plant_flutter/screens/product/ProductDetailScreen.dart';
// import 'package:plant_flutter/utils/CachedNetworkImage.dart';
// import 'package:plant_flutter/utils/colors.dart';
// import 'package:plant_flutter/utils/common.dart';
//
// class ProductItemWidget extends StatefulWidget {
//   final ProductData itemData;
//   final int index;
//
//   ProductItemWidget({required this.itemData, required this.index});
//
//   @override
//   State<ProductItemWidget> createState() => _ProductItemWidgetState();
// }
//
// class _ProductItemWidgetState extends State<ProductItemWidget> {
//   int? selectedItem;
//   late ProductData itemData;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   void init() async {
//     itemData = widget.itemData;
//     setState(() {});
//   }
//
//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }
//
//   void addToCart() {
//     if (itemData.in_stock.validate(value: false)) {
//       selectedItem = itemData.id;
//       appStore.setLoading(true);
//       cartApi.addToCart(pId: itemData.id.validate(), qty: 1).then((value) {
//         toast(value.message);
//         productStore.addToCartList(prodId: itemData.id!);
//         setState(() {});
//       }).catchError((e) {
//         toast(e.toString(), print: true);
//       }).whenComplete(() {
//         appStore.setLoading(false);
//         selectedItem = 0;
//       });
//     } else {
//       toast(language.out_Of_Stock);
//     }
//   }
//
//   void removeFromCart() {
//     if (itemData.in_stock.validate(value: false)) {
//       selectedItem = itemData.id;
//       appStore.setLoading(true);
//       cartApi.removeFromCart(pId: itemData.id.validate()).then((value) {
//         toast(value.message);
//         productStore.removeFromCartList(prodId: itemData.id!);
//         setState(() {});
//       }).catchError((e) {
//         toast(e.toString(), print: true);
//       }).whenComplete(() {
//         appStore.setLoading(false);
//         selectedItem = 0;
//       });
//     } else {
//       toast(language.out_Of_Stock);
//     }
//   }
//
//   Widget cartWidget({required Widget child, Color? color, required Function() onTap}) {
//     return Container(
//       decoration: boxDecorationDefault(
//         borderRadius: radiusOnly(bottomRight: defaultRadius, topRight: defaultRadius, topLeft: defaultRadius),
//         color: color ?? primaryColor,
//       ),
//       child: IconButton(
//         icon: (appStore.isLoading && selectedItem == itemData.id)
//             ? Loader(
//                 color: Colors.transparent,
//                 accentColor: Colors.white,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               )
//             : child,
//         onPressed: onTap,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         push(ProductDetailScreen(id: itemData.id!.toInt()), duration: 800.milliseconds, pageRouteAnimation: PageRouteAnimation.Fade);
//       },
//       child: Container(
//         margin: EdgeInsets.only(top: 66),
//         width: context.width() / 2 - 24,
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               margin: EdgeInsets.only(top: 56, bottom: 16),
//               padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 0),
//               width: context.width(),
//               decoration: boxDecorationDefault(color: context.cardColor),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('${itemData.name.validate()}', style: boldTextStyle(size: 22)),
//                       4.height,
//                       Text('${parseHtmlString(itemData.description.validate())}', style: primaryTextStyle(size: 16), overflow: TextOverflow.ellipsis, maxLines: 2),
//                       16.height,
//                       PriceWidget(salePrice: itemData.sale_price, regularPrice: itemData.regular_price, regularPriceSize: 26, isSale: itemData.on_sale),
//                       8.height,
//                     ],
//                   ).paddingRight(16).paddingTop(40),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Observer(
//                       builder: (_) {
//                         if (!itemData.in_stock.validate()) {
//                           return cartWidget(
//                             child: Icon(MaterialIcons.shopping_cart, color: Colors.white, size: 20),
//                             onTap: () {
//                               ifLoggedIn(() {
//                                 toast(language.out_Of_Stock.toUpperCase());
//                               });
//                             },
//                           );
//                         }
//                         if (productStore.isItemInCart(prodId: itemData.id!)) {
//                           return cartWidget(
//                             child: Icon(MaterialIcons.remove_shopping_cart, color: Colors.white, size: 20),
//                             onTap: () {
//                               ifLoggedIn(() {
//                                 removeFromCart();
//                               });
//                             },
//                           );
//                         }
//                         return cartWidget(
//                           child: Icon(MaterialIcons.add_shopping_cart, color: Colors.white, size: 20),
//                           onTap: () {
//                             ifLoggedIn(() {
//                               addToCart();
//                             });
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: -86,
//               left: 0,
//               right: 0,
//               child: Stack(
//                 alignment: Alignment.bottomRight,
//                 clipBehavior: Clip.none,
//                 children: [
//                   Hero(tag: "${itemData.id}", child: cachedImage(itemData.images!.first.src, height: 180, radius: 20, fit: BoxFit.cover)).cornerRadiusWithClipRRect(20).center(),
//                   IconButton(
//                     color: Colors.red,
//                     iconSize: 24,
//                     padding: EdgeInsets.all(0),
//                     icon: productStore.isItemInWish(prodId: itemData.id!) ? Icon(MaterialIcons.favorite) : Icon(MaterialIcons.favorite_border),
//                     onPressed: () {
//                       ifLoggedIn(() {
//                         if (productStore.isItemInWish(prodId: itemData.id!)) {
//                           productStore.removeFromWish(prodId: itemData.id!);
//                           setState(() {});
//
//                           wishlistApi.removeFromWishList(pId: itemData.id.validate()).then((value) {
//                             toast(value.message);
//                           }).catchError((e) {
//                             toast(e.toString(), print: true);
//                           });
//                         } else {
//                           productStore.addToWish(prodId: itemData.id!);
//
//                           setState(() {});
//
//                           wishlistApi.addToWishList(pId: itemData.id.validate()).then((value) {
//                             toast(value.message);
//                           }).catchError((e) {
//                             toast(e.toString(), print: true);
//                           });
//                         }
//                       });
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

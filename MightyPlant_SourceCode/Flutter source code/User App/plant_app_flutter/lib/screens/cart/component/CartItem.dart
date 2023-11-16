import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/cart/CartResponse.dart';
import 'package:plant_flutter/screens/cart/component/IncrementComponent.dart';
import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/common.dart';

class CartItem extends StatefulWidget {
  final CartData cartData;

  CartItem({required this.cartData});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    int index = cartStore.cartList.indexOf(widget.cartData);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor, border: Border.all(color: context.dividerColor)),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(widget.cartData.full, height: 70, width: 70),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Marquee(child: Text(widget.cartData.name.validate(), style: boldTextStyle())).expand(),
                      16.width,
                      IconButton(
                        onPressed: () {
                          showDialogBox(context,language.CartItemRemove, () {
                            cartStore.removeFromCart(index: index);
                            finish(context);
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.close, size: 20, color: Colors.red),
                        visualDensity: VisualDensity.compact,
                      )
                    ],
                  ),
                  Text(widget.cartData.stock_status.toString(),style: secondaryTextStyle(color:widget.cartData.stock_status.toString()=='instock'?Colors.green:Colors.red)),
                  16.height,
                  Row(
                    children: [
                      IncrementComponent(
                        initialValue: widget.cartData.quantity.toInt(),
                        onValueChanged: (count) {
                          if (count == 0) {
                            showDialogBox(context, language.CartItemRemove, () {
                              cartStore.removeFromCart(index: index);
                            });
                            setState(() {});
                          }
                          cartStore.addToCart(index: index, qty: count);
                          setState(() {});
                        },
                      ),
                      8.width,
                      Text('X',style: primaryTextStyle(size: 12)),
                      8.width,
                      PriceWidget(regularPrice: widget.cartData.regular_price, salePrice: widget.cartData.sale_price, isSale: widget.cartData.on_sale).expand(),
                      Observer(
                        builder: (_) => Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                          decoration: boxDecorationDefault(color: context.primaryColor, borderRadius: radius(10)),
                          child: Text(parseHtmlString('${userStore.currencySymbol}${cartStore.itemCalculatedPrice.isNaN ? 1 : widget.cartData.itemCalculatedPrice}'), style: boldTextStyle(color: Colors.white, size: 14)).center(),
                        ),
                      )
                    ],
                  ),
                ],
              ).expand()
            ],
          ),
        ],
      ),
    );
  }
}


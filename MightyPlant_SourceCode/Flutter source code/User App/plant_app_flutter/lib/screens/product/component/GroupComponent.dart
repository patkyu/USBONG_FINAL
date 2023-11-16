import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/WebViewScreen.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/cart/component/PriceWidget.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';

import '../../../main.dart';

class GroupProductComponent extends StatefulWidget {
  final List<ProductDetailResponse>? product;

  final ProductDetailResponse? productDetailNew;

  GroupProductComponent({this.product, this.productDetailNew});

  @override
  _GroupProductComponentState createState() => _GroupProductComponentState();
}

class _GroupProductComponentState extends State<GroupProductComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    log(widget.product);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Text(language.lblGrpProduct, style: boldTextStyle()),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.product!.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(right: 8, bottom: 8, top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    cachedImage(widget.product![i].imagess![0].src, height: 85, width: 85, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                    4.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product![i].name!, style: boldTextStyle()).paddingOnly(left: 8, right: 8),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: radius(8), backgroundColor: widget.product![i].in_stock == true ? primaryColor : white, border: Border.all(color: primaryColor)),
                              child: Text(
                                widget.product![i].in_stock! == true
                                    ? widget.product![i].type! == 'external'
                                        ? widget.product![i].button_text!
                                        : productStore.isItemInCart(prodId: widget.product![i].id.validate())
                                            ? language.remove_from_cart
                                            : language.add_to_cart
                                    : language.remove_from_cart,
                                textAlign: TextAlign.center,
                                style: boldTextStyle(color: widget.product![i].in_stock == false ? primaryColor : white, size: 12),
                              ),
                            ).onTap(() {
                              ifLoggedIn(() {
                                if (widget.product![i].in_stock == true) {
                                  if (productStore.isItemInCart(prodId: widget.product![i].id!)) {
                                    cartApi.removeFromCart(pId: widget.product![i].id.validate()).then((value) async {
                                      toast(value.message);
                                      productStore.removeFromCartList(prodId: widget.product![i].id!);
                                      setState(() {});
                                    }).catchError((e) {
                                      toast(e.toString(), print: true);
                                    });
                                  } else if (widget.product![i].type == 'external') {
                                    push(WebViewScreen(url: widget.product![i].external_url.validate(), name: ""));
                                  } else {
                                    cartApi.addToCart(pId: widget.product![i].id.validate(), qty: 1).then((value) async {
                                      toast(value.message);
                                      productStore.addToCartList(prodId: widget.product![i].id!);
                                      setState(() {});
                                    }).catchError((e) {
                                      toast(e.toString(), print: true);
                                    });
                                  }
                                }
                              });
                            }),
                            PriceWidget(salePrice: widget.product![i].sale_price.toString(), regularPrice: widget.product![i].price.toString().validate(), regularPriceSize: 16, color: primaryColor)
                          ],
                        ).paddingOnly(left: 8),
                      ],
                    ).expand()
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

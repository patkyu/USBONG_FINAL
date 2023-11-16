import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/WebViewScreen.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/widgets/rounded_loading_button.dart';

class AddToCartComponent extends StatefulWidget {
  final ProductDetailResponse productDetailResponse;
  final Function()? onUpdate;

  AddToCartComponent({required this.productDetailResponse, this.onUpdate});

  @override
  State<AddToCartComponent> createState() => _AddToCartComponentState();
}

class _AddToCartComponentState extends State<AddToCartComponent> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      height: 42,
      successIcon: Icons.done,
      failedIcon: Icons.close,
      borderRadius: 16,
      child: Text(
        widget.productDetailResponse.in_stock == true
            ? widget.productDetailResponse.type == "external"
                ? widget.productDetailResponse.button_text!
                : productStore.isItemInCart(prodId: widget.productDetailResponse.id!)
                    ? language.remove_from_cart
                    : language.add_to_cart
            : language.lblSoldOut,
        style: boldTextStyle(color: Colors.white, size: 16),
      ),
      controller: _btnController,
      animateOnTap: false,
      width: context.width(),
      color: context.primaryColor,
      onPressed: () {
        ifLoggedIn(() {
          if (widget.productDetailResponse.in_stock == true) {
            if (productStore.isItemInCart(prodId: widget.productDetailResponse.id!)) {
              _btnController.start();
              cartApi.removeFromCart(pId: widget.productDetailResponse.id.validate()).then((value) async {
                toast(value.message);

                productStore.removeFromCartList(prodId: widget.productDetailResponse.id!);
                _btnController.success();
                await 2.seconds.delay;
                _btnController.reset();

                setState(() {});
              }).catchError((e) {
                _btnController.error();

                toast(e.toString(), print: true);
              });
            } else if (widget.productDetailResponse.type == 'external') {
              push(WebViewScreen(url: widget.productDetailResponse.external_url.validate(), name: ""));
            } else {
              _btnController.start();
              cartApi.addToCart(pId: widget.productDetailResponse.id.validate(), qty: 1).then((value) async {
                toast(value.message);
                productStore.addToCartList(prodId: widget.productDetailResponse.id!);
                _btnController.success();
                await 2.seconds.delay;
                _btnController.reset();
                setState(() {});
              }).catchError((e) {
                toast(e.toString(), print: true);

                _btnController.error();
              });
            }
          }
        });
      },
    );
  }
}

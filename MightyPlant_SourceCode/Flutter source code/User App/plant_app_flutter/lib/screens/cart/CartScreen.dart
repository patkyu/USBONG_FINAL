import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/cart/CartResponse.dart';
import 'package:plant_flutter/screens/SignIn/LoginRequiredWidget.dart';
import 'package:plant_flutter/screens/cart/component/CartItem.dart';
import 'package:plant_flutter/screens/checkout/CheckOutScreen.dart';
import 'package:plant_flutter/screens/userSettings/EditProfileScreen.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/constants.dart';
// import 'package:slide_to_act/slide_to_act.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isShow = false;

  // final GlobalKey<SlideActionState> _key = GlobalKey();
  Future<CartResponse>? mCart;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (userStore.isLoggedIn) {
      mCart = cartStore.init();
    }
    LiveStream().on(cartUpdate, (p0) {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: userStore.isLoggedIn
          ? FutureBuilder<CartResponse>(
              future: mCart,
              builder: (context, snap) {
                if (snap.hasData) {
                  if (snap.data!.cartData.validate().isNotEmpty) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AnimationLimiter(
                          child: Observer(
                            builder: (_) => ListView.builder(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 250),
                              physics: BouncingScrollPhysics(),
                              itemCount: cartStore.cartList.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 750),
                                  child: SlideAnimation(
                                    horizontalOffset: 50.0,
                                    verticalOffset: 20.0,
                                    child: FadeInAnimation(
                                      child: CartItem(
                                        cartData: cartStore.cartList[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        cartStore.cartList.isNotEmpty
                            ? DraggableScrollableSheet(
                                initialChildSize: 0.1,
                                minChildSize: 0.1,
                                maxChildSize: 0.37,
                                builder: (BuildContext context, ScrollController scrollController) {
                                  return SingleChildScrollView(
                                      controller: scrollController,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: boxDecorationWithShadow(
                                            borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                                            border: Border.all(color: viewLineColor),
                                            backgroundColor: context.cardColor,
                                            shadowColor: Colors.black),
                                        padding: EdgeInsets.all(8),
                                        child: Observer(
                                          builder: (_) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(width: context.width() / 3, child: Divider(thickness: 3)),
                                              16.height,
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Text(language.price_Details.toUpperCase(), style: boldTextStyle(size: 14)),
                                                    Divider(),
                                                    8.height,
                                                  ],
                                                ),
                                              ).onTap(() {
                                                isShow = false;
                                                setState(() {});
                                              }),
                                              TextIcon(
                                                text: "${language.price} (${cartStore.cartList.length} ${language.items})",
                                                textStyle: primaryTextStyle(size: 14),
                                                expandedText: true,
                                                suffix: Text('${userStore.currencySymbol}${cartStore.cartTotalAmount.toString()}', style: boldTextStyle(size: 14)),
                                              ),
                                              8.height,
                                              TextIcon(
                                                text: language.discounts,
                                                expandedText: true,
                                                textStyle: primaryTextStyle(size: 14),
                                                suffix: Text('-${userStore.currencySymbol}${cartStore.discountedValue}', style: boldTextStyle(size: 14, color: primaryColor)),
                                              ).visible(cartStore.discountedValue > 0),
                                              Divider(),
                                              TextIcon(
                                                text: language.total_Amount,
                                                textStyle: boldTextStyle(size: 14),
                                                expandedText: true,
                                                suffix: Text('${userStore.currencySymbol}${cartStore.cartTotalPayableAmount}', style: boldTextStyle(size: 14)),
                                              ),
                                              16.height,
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: ActionSlider.standard(
                                                  height: 50,
                                                  successIcon: Icon(Icons.check, color: whiteColor),
                                                  iconAlignment: Alignment.center,
                                                  backgroundColor: context.cardColor,
                                                  icon: Icon(Icons.arrow_forward, color: whiteColor),
                                                  child: Text(language.swipe_to_Checkout, style: boldTextStyle(color: primaryColor)),
                                                  loadingAnimationDuration: Duration(milliseconds: 5000),
                                                  actionThreshold: 1.0,
                                                  action: (controller) async {
                                                    controller.loading();
                                                    await Future.delayed(const Duration(seconds: 3));
                                                    controller.success();
                                                    if (userStore.shippingAddress!.first_name!.isNotEmpty) {
                                                      push(CheckOutScreen());
                                                      isShow = false;

                                                      setState(() {});
                                                    } else {
                                                      toast(language.please_add_the_shipping_address_first);
                                                      push(EditProfileScreen());
                                                    }
                                                  }, //many more parameters
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ).cornerRadiusWithClipRRectOnly(topLeft: 12, topRight: 12));
                                },
                              )
                            : Offstage(),
                      ],
                    );
                  } else {
                    return NoDataWidget(title: language.cart_is_Empty);
                  }
                }
                return snapWidgetHelper(snap, loadingWidget: AppLoader().center());
              },
            )
          : LoginRequiredWidget(title: language.cart),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/auth/UserResponse.dart';
import 'package:plant_flutter/model/checkout/WebViewOrderRequestModel.dart';
import 'package:plant_flutter/model/checkout/CheckOutResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/checkout/payment/WebViewPaymentScreen.dart';
import 'package:plant_flutter/screens/DashboardScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/extensions/EnumExtension.dart';
import 'package:plant_flutter/utils/images.dart';
import 'package:plant_flutter/utils/common.dart';

void createNativeOrder(BuildContext context, String mPayMethod) async {
  var mBilling = Billing();
  var mShipping = Billing();

  if (userStore.billingAddress != null) {
    mBilling.first_name = userStore.billingAddress!.first_name;
    mBilling.last_name = userStore.billingAddress!.last_name;
    mBilling.email = userStore.billingAddress!.email;
    mBilling.city = userStore.billingAddress!.city;
    mBilling.postcode = userStore.billingAddress!.postcode;
    mBilling.company = userStore.billingAddress!.company;
    mBilling.phone = userStore.billingAddress!.phone;
    mBilling.state = userStore.billingAddress!.state;
    mBilling.country = userStore.billingAddress!.country;
    mBilling.address_1 = userStore.billingAddress!.address_1;
    mBilling.address_2 = userStore.billingAddress!.address_2;
  }

  if (userStore.shippingAddress != null) {
    mShipping.first_name = userStore.shippingAddress!.first_name;
    mShipping.last_name = userStore.shippingAddress!.last_name;
    mShipping.email = userStore.shippingAddress!.email;
    mShipping.city = userStore.shippingAddress!.city;
    mShipping.postcode = userStore.shippingAddress!.postcode;
    mShipping.company = userStore.shippingAddress!.company;
    mShipping.phone = userStore.shippingAddress!.phone;
    mShipping.state = userStore.shippingAddress!.state;
    mShipping.country = userStore.shippingAddress!.country;
    mShipping.address_1 = userStore.shippingAddress!.address_1;
    mShipping.address_2 = userStore.shippingAddress!.address_2;
  }
  List<LineItem> lineItems = [];
  cartStore.cartList.forEach((item) {
    LineItem lineItem = LineItem();
    lineItem.product_id = item.pro_id;
    lineItem.quantity = item.quantity;
    // lineItem.variationId = item.pro_id;
    lineItems.add(lineItem);
  });

  var request = {
    'billing': mBilling,
    'shipping': mShipping,
    'line_items': lineItems,
    'payment_method': mPayMethod,
    'customer_id': userStore.userId.toString(),
    'status': PaymentStatus.processing.getName,
    'set_paid': false,
  };
  appStore.setLoading(true);
  log(request);

  checkOutApi.createOrderApi(request).then((response) async {
    appStore.setLoading(false);
    checkOutApi.createOrderNotes(response['id']).catchError((e) {
      log(e.toString());
    });

    cartApi.clearCart().then((response) {
      cartStore.cartList.clear();
      cartStore.cartTotalAmount = 0.0;
      cartStore.cartTotalPayableAmount = 0.0;
      cartStore.cartSavedAmount = 0.0;
      productStore.cartProductId.clear();
    }).catchError((error) {
      log(error.toString());
    });

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                cachedImage(appImages.orderPlaced, fit: BoxFit.contain, height: 80, width: 80),
                16.height,
                Text(language.payment_Confirmed, style: boldTextStyle(size: 20)),
                8.height,
                Text(language.thank_you_your_payment_has_been_successful, style: primaryTextStyle(), textAlign: TextAlign.center),
                8.height,
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                  ),
                  onPressed: () {
                    DashboardScreen().launch(context, isNewTask: true);
                  },
                  child: Text(language.done, style: primaryTextStyle()),
                )
              ],
            ),
          ),
        );
      },
    );
  }).catchError((error) {
    appStore.setLoading(false);
    log(error.toString());
  });
}

Future createWebViewOrder() async {
  var request = WebViewOrderRequestModel();

  List<LineItemsRequest> lineItems = [];

  cartStore.cartList.forEach((item) {
    var lineItem = LineItemsRequest();
    lineItem.productId = item.pro_id;
    lineItem.quantity = item.quantity;
    lineItem.variationId = item.pro_id;
    lineItems.add(lineItem);
  });

  request.paymentMethod = "webview";
  request.transactionId = "";
  request.customerId = userStore.userId;
  request.status = "pending";
  request.setPaid = false;

  request.lineItems = lineItems;
  request.shipping = userStore.shippingModel;
  request.billing = userStore.billingAddress;
  createOrder(request);
}

void createOrder(WebViewOrderRequestModel mCreateOrderRequestModel) async {
  appStore.setLoading(true);
  await checkOutApi.createOrderApi(mCreateOrderRequestModel.toJson()).then((response) {
    processPaymentApi(response['id']);
  }).catchError((error) {
    appStore.setLoading(false);
    log(error.toString());
  });
}

processPaymentApi(var mOrderId) async {
  log(mOrderId);
  var request = {"order_id": mOrderId};

  checkOutApi.getCheckOutUrl(request).then((res) async {
    appStore.setLoading(false);
    bool isPaymentDone = await push(WebViewPaymentScreen(checkoutUrl: res['checkout_url'])) ?? false;
    if (isPaymentDone) {
      appStore.setLoading(true);
      cartStore.cartList.clear();
      push(DashboardScreen(), isNewTask: true);
    } else {
      checkOutApi.deleteOrder(mOrderId).then((value) => {log(value)}).catchError((error) {
        log(error);
      });
    }
  }).catchError((error) {});
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/screens/checkout/payment/CreateOrderComponent.dart';
import 'package:plant_flutter/utils/images.dart';

class PayStackApi {
  PaystackPlugin payStackPlugin = PaystackPlugin();
  void payStackPayment(BuildContext context, PaystackPlugin plugin) async {
    String? _cardNumber;
    String? _cvv;
    int? _expiryMonth;
    int? _expiryYear;
    CheckoutMethod _method = CheckoutMethod.card;

    Charge charge = Charge()
      ..amount = (double.parse(cartStore.cartTotalPayableAmount.toString()) * 100.00).toInt() // In base currency
      ..email = userStore.userEmail
      ..currency = "NGN"
      ..card = PaymentCard(number: _cardNumber, cvc: _cvv, expiryMonth: _expiryMonth, expiryYear: _expiryYear);

    charge.reference = _getReference();
    try {
      CheckoutResponse response = await plugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        hideEmail: true,
        logo: Image.asset(appImages.appLogo, height: 76, width: 76),
      ); //_updateStatus(response.reference, response.message);
      if (response.message == "Success") {
        createNativeOrder(context, "PayStackPayment");
      } else {
        snackBar(context, title: language.payment_Failed);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}

PayStackApi payStackApi = PayStackApi();

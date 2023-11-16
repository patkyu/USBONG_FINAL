import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/checkout/PaymentModel.dart';
import 'package:plant_flutter/screens/checkout/component/AddressComponent.dart';
import 'package:plant_flutter/screens/checkout/payment/PayStackComponent.dart';
import 'package:plant_flutter/screens/checkout/payment/CreateOrderComponent.dart';
import 'package:plant_flutter/screens/userSettings/EditProfileScreen.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  List<PaymentClass>? paymentList = [];

  int? _currentTimeValue = 0;
  bool isNativePayment = false;
  int? paymentIndex = 0;
  late Razorpay razorPay;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    addList();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    payStackApi.payStackPlugin.initialize(publicKey: paymentKeys.payStackPublicKey);
    log(getStringAsync(sharedPref.paymentMethod));
    if (getStringAsync(sharedPref.paymentMethod) == PAYMENT_METHOD_NATIVE) {
      isNativePayment = true;
    } else {
      isNativePayment = false;
    }
  }

  addList() {
    paymentList!.add(PaymentClass(paymentIndex: 0, paymentMethod: 'Cash On Delivery'));
    if (IS_RAZORPAY) paymentList!.add(PaymentClass(paymentIndex: 1, paymentMethod: 'RazorPay'));
    if (IS_PAY_STACK) paymentList!.add(PaymentClass(paymentIndex: 2, paymentMethod: 'PayStack'));

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.order_Summary, textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Container(
        padding: EdgeInsets.only(right: 16, left: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                children: [
                  Text(language.addresses, style: boldTextStyle()).expand(),
                  Container(
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationWithRoundedCorners(border: Border.all(width: 0.2), backgroundColor: context.cardColor),
                          child: Text('Change Address', style: secondaryTextStyle(color: primaryColor)))
                      .onTap(() {
                    push(EditProfileScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                  })
                ],
              ),
              8.height,
              Wrap(
                spacing: 12,
                children: [
                  AddressComponent(name: language.billing_Address, address: userStore.billingAddress!, isCheckOut: true, width: context.width() / 2 - 24),
                  AddressComponent(name: language.shipping_Address, address: userStore.shippingAddress!, isCheckOut: true, width: context.width() / 2 - 24),
                ],
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.order_Details, style: boldTextStyle()).center(),
                    Divider(),
                    TextIcon(
                        text: language.price + "(${cartStore.cartList.length} " + language.items + ")",
                        textStyle: secondaryTextStyle(),
                        expandedText: true,
                        suffix: Text(parseHtmlString('${userStore.currencySymbol}${cartStore.cartTotalAmount}'), style: boldTextStyle(size: 14))),
                    8.height,
                    TextIcon(
                            text: language.discounts,
                            expandedText: true,
                            textStyle: secondaryTextStyle(),
                            suffix: Text(parseHtmlString('-${userStore.currencySymbol}${cartStore.discountedValue}'), style: boldTextStyle(color: primaryColor, size: 14)))
                        .visible(cartStore.discountedValue > 0),
                    Divider(),
                    TextIcon(
                        text: language.total_Amount,
                        textStyle: boldTextStyle(size: 14),
                        expandedText: true,
                        suffix: Text(parseHtmlString('${userStore.currencySymbol}${cartStore.cartTotalPayableAmount}'), style: boldTextStyle(color: primaryColor))),
                  ],
                ),
              ),
              16.height,
              Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(border: isNativePayment ? Border.all(color: context.dividerColor) : Border.all(color: context.cardColor), borderRadius: radius()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(language.select_Payment_Mode, style: boldTextStyle()).center().visible(isNativePayment),
                    Divider().visible(isNativePayment),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Theme(
                          data: Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).iconTheme.color),
                          child: RadioListTile(
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 6),
                            activeColor: primaryColor,
                            value: index,
                            groupValue: _currentTimeValue,
                            onChanged: (dynamic ind) {
                              setState(() {
                                _currentTimeValue = index;
                                paymentIndex = paymentList![_currentTimeValue.validate()].paymentIndex;
                              });
                            },
                            title: Text(paymentList![index].paymentMethod.validate(), style: primaryTextStyle()),
                          ),
                        );
                      },
                      itemCount: paymentList!.length,
                    ).visible(isNativePayment),
                    16.height,
                    AppButton(
                      width: context.width(),
                      color: primaryColor,
                      child: Text(language.pay_Now, style: boldTextStyle(color: white)),
                      onTap: () {
                        showDialogBox(context, language.lblAreYouSure, () async {
                          if (isNativePayment) {
                            if (paymentIndex == 0) {
                              createNativeOrder(context, "Cash On Delivery");
                            } else if (IS_RAZORPAY && paymentIndex == 1) {
                              razorPayCheckout(double.parse(cartStore.cartTotalPayableAmount.toString()) * 100.00);
                              finish(context);
                            } else if (IS_PAY_STACK && paymentIndex == 2) {
                              await 1.seconds.delay;
                              finish(context);
                              payStackApi.payStackPayment(context, payStackApi.payStackPlugin);
                            }
                          } else {
                            createWebViewOrder();
                          }
                          setState(() {});
                        });
                      },
                    ).cornerRadiusWithClipRRect(35).paddingOnly(top: 4, bottom: 8)
                  ],
                ),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }

  //RazorPay checkOut
  void handlePaymentSuccess(PaymentSuccessResponse response) {
    createNativeOrder(context, "RazorPay");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    toast("Error: " + response.code.toString() + " - " + response.message!);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    toast("external_wallet: " + response.walletName!);
  }

  void razorPayCheckout(num mAmount) async {
    var options = {
      'key': paymentKeys.razorKey,
      'amount': mAmount,
      'name': appName,
      'theme.color': '#469d4f',
      'description': paymentKeys.razorPayDescription,
      'image': 'https://firebasestorage.googleapis.com/v0/b/plan-app-13214.appspot.com/o/app_logo.png?alt=media&token=e280f0ca-bfdd-4f5a-9bef-ae863f94afde',
      'prefill': {'contact': userStore.billingAddress!.phone, 'email': userStore.billingAddress!.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

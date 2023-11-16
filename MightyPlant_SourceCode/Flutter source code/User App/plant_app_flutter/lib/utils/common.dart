import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/auth/UserResponse.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/model/wishlist/WishlistResponse.dart';
import 'package:plant_flutter/screens/SignIn/SignInScreen.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'images.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', subTitle: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'asset/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', subTitle: 'हिंदी', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'asset/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', subTitle: 'عربي', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'asset/flag/ic_ar.png'),
  ];
}
enum PaymentStatus { pending, processing, on_hold, completed, cancelled, refunded, failed }

void ifLoggedIn(VoidCallback callback) {
  if (userStore.isLoggedIn) {
    callback.call();
  } else {
    push(SignInScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
  }
}

defaultSetting() {
  defaultRadius = 20;
  appBarBackgroundColorGlobal = primaryColor;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultAppButtonRadius = defaultRadius;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
}

userValueSetForLogin() {
  userStore.setLogin(getBoolAsync(sharedPref.isLoggedIn), isInitializing: true);
  userStore.setUserName(getStringAsync(sharedPref.userName), isInitialization: true);
  userStore.setToken(getStringAsync(sharedPref.apiToken), isInitialization: true);
  userStore.setUserID(getIntAsync(sharedPref.userId), isInitialization: true);
  userStore.setUserEmail(getStringAsync(sharedPref.userEmail), isInitialization: true);
  userStore.setFirstName(getStringAsync(sharedPref.firstName), isInitialization: true);
  userStore.setLastName(getStringAsync(sharedPref.lastName), isInitialization: true);
  userStore.setUserPassword(getStringAsync(sharedPref.userPassword), isInitialization: true);
  userStore.setUserImage(getStringAsync(sharedPref.userPhotoUrl), isInitialization: true);
  String billingAddressString = getStringAsync(sharedPref.billingAddress);

  if (billingAddressString.isNotEmpty) {
    userStore.setBillingAddress(Billing.fromJson(jsonDecode(billingAddressString)), isInitialization: true);
  }

  String shippingAddressString = getStringAsync(sharedPref.shippingAddress);
  if (shippingAddressString.isNotEmpty) {
    userStore.setShippingAddress(Billing.fromJson(jsonDecode(shippingAddressString)), isInitialization: true);
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  await launch(url, forceWebView: forceWebView, enableJavaScript: true, statusBarBrightness: Brightness.light).catchError((e) {
    log(e);
    toast(language.invalid_URL + ': $url');
  });
}

InputDecoration inputDecoration(
  BuildContext context, {
  String? label,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.theme.colorScheme.error)),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.theme.colorScheme.error)),
    alignLabelWithHint: true,
    filled: true,
    isDense: true,
    labelText: label ?? "Sample Text",
    labelStyle: secondaryTextStyle(),
  );
}

void addItemToWishlist({ProductListResponse? data, ProductDetailResponse? mDetailResponse}) {
  WishlistResponse mWishListModel = WishlistResponse();
  var mList = <String>[];
  if (mDetailResponse != null) {
    mDetailResponse.imagess.forEachIndexed((element, index) {
      mList.add(element.src!);
    });
    mWishListModel.name = mDetailResponse.name;
    mWishListModel.pro_id = mDetailResponse.id;
    mWishListModel.sale_price = mDetailResponse.sale_price;
    mWishListModel.regular_price = mDetailResponse.regular_price;
    mWishListModel.price = mDetailResponse.price;
    mWishListModel.gallery = mList;
    mWishListModel.stock_quantity = '1';
    mWishListModel.thumbnail = "";
    mWishListModel.full = mDetailResponse.imagess![0].src;
    mWishListModel.sku = "";
    mWishListModel.created_at = "";
  } else {
    data!.images.forEachIndexed((element, index) {
      mList.add(element.src!);
    });
    mWishListModel.name = data.name;
    mWishListModel.pro_id = data.id;
    mWishListModel.sale_price = data.sale_price;
    mWishListModel.regular_price = data.regular_price;
    mWishListModel.price = data.price;
    mWishListModel.gallery = mList;
    mWishListModel.stock_quantity = '1';
    mWishListModel.thumbnail = "";
    mWishListModel.full = data.images![0].src;
    mWishListModel.sku = "";
    mWishListModel.created_at = "";
  }
  wishCartStore.addToWishList(mWishListModel);
}

showDialogBox(context, title, onCall, {onCancelCall}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(appImages.appLogo, fit: BoxFit.cover, height: 100, width: 100),
              Text(title, style: boldTextStyle(), textAlign: TextAlign.center),
            ],
          ),
          actions: [
            Row(
              children: [
                AppButton(
                  elevation: 0,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: radius(defaultAppButtonRadius),
                    side: BorderSide(color: viewLineColor),
                  ),
                  color: context.scaffoldBackgroundColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close, color: textPrimaryColorGlobal, size: 20),
                      6.width,
                      Text('Cancel', style: boldTextStyle(color: textPrimaryColorGlobal)),
                    ],
                  ).fit(),
                  onTap: () {
                    onCancelCall != null ? onCancelCall.call() : finish(context);
                  },
                ).expand(),
                16.width,
                AppButton(
                  elevation: 0,
                  color: primaryColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: radius(defaultAppButtonRadius),
                    side: BorderSide(color: viewLineColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 20),
                      6.width,
                      Text(language.lblyes, style: boldTextStyle(color: Colors.white)),
                    ],
                  ).fit(),
                  onTap: () {
                    onCall();
                  },
                ).expand(),
              ],
            ),
          ],
        );
      });
}

String durationFormatter(int milliSeconds) {
  int seconds = milliSeconds ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final formattedTime = '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';
  return formattedTime;
}

import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/auth/UserResponse.dart';
import 'package:plant_flutter/model/dashboard/AppConfigurationResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/constants.dart';

part 'UserStore.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  String userEmail = '';

  @observable
  String userPassword = '';

  @observable
  String firstName = '';

  @observable
  String lastName = '';

  @observable
  String contact = "";

  @observable
  String copyright_text = "";

  @observable
  String facebook = "";

  @observable
  String instagram = "";

  @observable
  String privacy_policy = "";

  @observable
  String refund_policy = "";

  @observable
  String shipping_policy = "";

  @observable
  String term_condition = "";

  @observable
  String twitter = "";

  @observable
  String website_url = "";

  @observable
  String whatsapp = "";

  @observable
  String appLang = "";

  @observable
  String currencySymbol = "";

  @observable
  bool enableCustomDashboard = false;

  @observable
  String paymentMethod = "";

  @observable
  int userId = 0;

  @observable
  Billing shippingModel = Billing();

  @observable
  String userImage = '';

  @observable
  String userName = '';

  @observable
  String token = '';

  @action
  Future<void> setUserImage(String val, {bool isInitialization = false}) async {
    userImage = val;
    if (!isInitialization) await setValue(sharedPref.userPhotoUrl, val);
  }

  @action
  Future<void> setUserID(int val, {bool isInitialization = false}) async {
    userId = val;
    if (!isInitialization) await setValue(sharedPref.userId, val);
  }

  @action
  Future<void> setLogin(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(sharedPref.isLoggedIn, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitialization = false}) async {
    firstName = val;
    if (!isInitialization) await setValue(sharedPref.firstName, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitialization = false}) async {
    lastName = val;
    if (!isInitialization) await setValue(sharedPref.lastName, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitialization = false}) async {
    userEmail = val;
    if (!isInitialization) await setValue(sharedPref.userEmail, val);
  }

  @action
  Future<void> setUserName(String val, {bool isInitialization = false}) async {
    userName = val;
    if (!isInitialization) await setValue(sharedPref.userName, val);
  }

  @action
  Future<void> setUserPassword(String val, {bool isInitialization = false}) async {
    userPassword = val;
    if (!isInitialization) await setValue(sharedPref.userPassword, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitialization = false}) async {
    token = val;
    if (!isInitialization) await setValue(sharedPref.apiToken, val);
  }

  @observable
  Billing? billingAddress;

  @observable
  Billing? shippingAddress;

  @action
  Future<void> setBillingAddress(Billing? model, {bool isInitialization = false}) async {
    billingAddress = model;

    if (model != null) {
      if (!isInitialization) await setValue(sharedPref.billingAddress, jsonEncode(model));
    } else {
      await setValue(sharedPref.billingAddress, '');
    }
  }

  @action
  Future<void> setShippingAddress(Billing? model, {bool isInitialization = false}) async {
    shippingAddress = model;

    if (model != null) {
      shippingModel = model;

      if (!isInitialization) await setValue(sharedPref.shippingAddress, jsonEncode(model));
    } else {
      await setValue(sharedPref.shippingAddress, '');
    }
  }

  @action
  Future<void> setContact(String val, {bool isInitialization = false}) async {
    contact = val;
    if (!isInitialization) await setValue(sharedPref.contact, val);
  }

  @action
  Future<void> setCopyrightText(String val, {bool isInitialization = false}) async {
    copyright_text = val;
    if (!isInitialization) await setValue(sharedPref.copyrightText, val);
  }

  @action
  Future<void> setFacebook(String val, {bool isInitialization = false}) async {
    facebook = val;
    if (!isInitialization) await setValue(sharedPref.facebook, val);
  }

  @action
  Future<void> setInstagram(String val, {bool isInitialization = false}) async {
    instagram = val;
    if (!isInitialization) await setValue(sharedPref.instagram, val);
  }

  @action
  Future<void> setPrivacyPolicy(String val, {bool isInitialization = false}) async {
    privacy_policy = val;
    if (!isInitialization) await setValue(sharedPref.privacyPolicy, val);
  }

  @action
  Future<void> setRefundPolicy(String val, {bool isInitialization = false}) async {
    refund_policy = val;
    if (!isInitialization) await setValue(sharedPref.refundPolicy, val);
  }

  @action
  Future<void> setShippingPolicy(String val, {bool isInitialization = false}) async {
    shipping_policy = val;
    if (!isInitialization) await setValue(sharedPref.shippingPolicy, val);
  }

  @action
  Future<void> setTermCondition(String val, {bool isInitialization = false}) async {
    term_condition = val;
    if (!isInitialization) await setValue(sharedPref.termCondition, val);
  }

  @action
  Future<void> setTwitter(String val, {bool isInitialization = false}) async {
    twitter = val;
    if (!isInitialization) await setValue(sharedPref.twitter, val);
  }

  @action
  Future<void> setWebsiteUrl(String val, {bool isInitialization = false}) async {
    website_url = val;
    if (!isInitialization) await setValue(sharedPref.websiteUrl, val);
  }

  @action
  Future<void> setWhatsapp(String val, {bool isInitialization = false}) async {
    whatsapp = val;
    if (!isInitialization) await setValue(sharedPref.whatsapp, val);
  }

  @action
  Future<void> setAppLang(String val, {bool isInitialization = false}) async {
    appLang = val;
    if (!isInitialization) await setValue(sharedPref.appLang, val);
  }

  @action
  Future<void> setCurrencySymbol(String val, {bool isInitialization = false}) async {
    currencySymbol = parseHtmlString(val);
    if (!isInitialization) await setValue(sharedPref.currencySymbol, parseHtmlString(val));
  }

  @action
  Future<void> setEnableCustomDashboard(bool val, {bool isInitialization = false}) async {
    enableCustomDashboard = val;
    if (!isInitialization) await setValue(sharedPref.enableCustomDashboard, val);
  }

  @action
  Future<void> setPaymentMethod(String val, {bool isInitialization = false}) async {
    paymentMethod = val;
    if (!isInitialization) await setValue(sharedPref.paymentMethod, val);
  }

  Future<void> init() async {
    AppConfigurationResponse snap = await dashboardApi.getAppConfiguration();

    setContact(snap.social_link!.contact.validate());
    setCopyrightText(snap.social_link!.copyright_text.validate());
    setFacebook(snap.social_link!.facebook.validate());
    setInstagram(snap.social_link!.instagram.validate());
    setPrivacyPolicy(snap.social_link!.privacy_policy.validate());
    setRefundPolicy(snap.social_link!.refund_policy.validate());
    setShippingPolicy(snap.social_link!.shipping_policy.validate());
    setTermCondition(snap.social_link!.term_condition.validate());
    setTwitter(snap.social_link!.twitter.validate());
    setWebsiteUrl(snap.social_link!.website_url.validate());
    setWhatsapp(snap.social_link!.whatsapp.validate());
    setAppLang(snap.app_lang.validate());
    setCurrencySymbol(snap.currency_symbol!.currency_symbol.validate());
    setEnableCustomDashboard(snap.enable_custom_dashboard.validate());
    setPaymentMethod(snap.payment_method.validate());
  }
}

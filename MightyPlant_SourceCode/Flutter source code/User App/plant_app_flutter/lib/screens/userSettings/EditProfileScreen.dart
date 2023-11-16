import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/auth/CountryResponse.dart';
import 'package:plant_flutter/model/auth/UserResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:plant_flutter/utils/widgets/rounded_loading_button.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

TabController? tabBarController;

class _EditProfileScreenState extends State<EditProfileScreen> with TickerProviderStateMixin {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int currentIndex = 0;

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController emailNameCont = TextEditingController();

  String profileImageUrl = "";
  Billing? shippingAddress;
  Billing? billingAddress;
  int isSelectedIndex = 0;
  bool isFirst = true;
  XFile? image;
  bool isSame = false;

  TextEditingController billFirstNameCont = TextEditingController();
  TextEditingController billLastNameCont = TextEditingController();
  TextEditingController billEmailCont = TextEditingController();
  TextEditingController billPhoneCont = TextEditingController();
  TextEditingController billCityCont = TextEditingController();
  TextEditingController billPinCodeCont = TextEditingController();
  TextEditingController billCompanyCont = TextEditingController();
  TextEditingController billStateCont = TextEditingController();
  TextEditingController billCountryCont = TextEditingController();
  TextEditingController billAddress1Cont = TextEditingController();
  TextEditingController billAddress2Cont = TextEditingController();

  String billSelectedCountry = "";
  String billSelectedState = "";

  FocusNode billFirstNameFocus = FocusNode();
  FocusNode billLastNameFocus = FocusNode();
  FocusNode billEmailFocus = FocusNode();
  FocusNode billPhoneFocus = FocusNode();
  FocusNode billCityFocus = FocusNode();
  FocusNode billPinCodeFocus = FocusNode();
  FocusNode billCompanyFocus = FocusNode();
  FocusNode billStateFocus = FocusNode();
  FocusNode billCountryFocus = FocusNode();
  FocusNode billAddress1Focus = FocusNode();
  FocusNode billAddress2Focus = FocusNode();

  TextEditingController shippingFirstNameCont = TextEditingController();
  TextEditingController shippingLastNameCont = TextEditingController();
  TextEditingController shippingEmailCont = TextEditingController();
  TextEditingController shippingPhoneCont = TextEditingController();
  TextEditingController shippingCityCont = TextEditingController();
  TextEditingController shippingPinCodeCont = TextEditingController();
  TextEditingController shippingCompanyCont = TextEditingController();
  TextEditingController shippingStateCont = TextEditingController();
  TextEditingController shippingCountryCont = TextEditingController();
  TextEditingController shippingAddress1Cont = TextEditingController();
  TextEditingController shippingAddress2Cont = TextEditingController();

  CountryResponse? shippingSelectedCountry;
  CountryState? shippingSelectedState;

  FocusNode shippingFirstNameFocus = FocusNode();
  FocusNode shippingLastNameFocus = FocusNode();
  FocusNode shippingEmailFocus = FocusNode();
  FocusNode shippingPhoneFocus = FocusNode();
  FocusNode shippingCityFocus = FocusNode();
  FocusNode shippingPinCodeFocus = FocusNode();
  FocusNode shippingCompanyFocus = FocusNode();
  FocusNode shippingStateFocus = FocusNode();
  FocusNode shippingCountryFocus = FocusNode();
  FocusNode shippingAddress1Focus = FocusNode();
  FocusNode shippingAddress2Focus = FocusNode();

  List<CountryResponse> billingCountryList = [];
  List<CountryState> billingStateList = [];
  CountryResponse? billingSelectedCountry;
  CountryState? billingSelectedState;

  List<CountryResponse> shippingCountryList = [];
  List<CountryState> shippingStateList = [];
  CountryResponse? shippingSelectedCountryResponse;
  CountryState? shippingSelectedCountryState;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    tabBarController = new TabController(length: 2, vsync: this);

    tabBarController!.addListener(() {
      currentIndex = tabBarController!.index;
      setState(() {});
    });
    appStore.setLoading(true);
    authApi.getUserData().then((value) {
      firstNameCont.text = value.first_name.validate();
      lastNameCont.text = value.last_name.validate();
      emailNameCont.text = value.email.validate();
      shippingAddress = value.shipping!;
      billingAddress = value.billing!;
      value.meta_data.validate().forEach((element) {
        log(element.value.validate());
        if (element.key == 'plantapp_profile_image') profileImageUrl = element.value.validate();
      });
      if (value.shipping != null) userStore.setShippingAddress(value.shipping);
      if (value.billing != null) userStore.setBillingAddress(value.billing);

      getCountry();
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
    });
    getCustomerInfo();
  }

  Future<void> getCountry() async {
    await authApi.getCountries().then((value) async {
      billingCountryList.clear();
      shippingStateList.clear();
      billingCountryList.addAll(value);
      shippingCountryList.addAll(value);

      value.forEach((e) {
        if (e.name == userStore.billingAddress!.country!) {
          billingSelectedCountry = e;
          billingStateList.addAll(e.states!);
        }
        if (e.name == userStore.shippingAddress!.country!) {
          shippingSelectedCountryResponse = e;
          shippingStateList.addAll(e.states!);
        }
      });
      setState(() {});
      getData();
    }).catchError((e) {
      toast('$e', print: true);
    });
  }

  getData() {
    if (userStore.billingAddress!.country!.isNotEmpty) {
      billingCountryList.forEach((element) {
        if (element.name == userStore.billingAddress!.country!) {
          billingSelectedCountry = element;
        }
      });
    }
    if (userStore.billingAddress!.state!.isNotEmpty) {
      billingStateList.forEach((element) {
        if (element.name == userStore.billingAddress!.state!) {
          billingSelectedState = element;
        }
      });
    }

    if (userStore.shippingAddress!.country!.isNotEmpty) {
      shippingCountryList.forEach((element) {
        if (element.name == userStore.shippingAddress!.country!) {
          shippingSelectedCountryResponse = element;
        }
      });
    }
    if (userStore.shippingAddress!.state!.isNotEmpty) {
      shippingStateList.forEach((element) {
        if (element.name == userStore.shippingAddress!.state!) {
          shippingSelectedCountryState = element;
        }
      });
    }
  }

  getCustomerInfo() {
    log(userStore.billingAddress!.state.validate());
    log(userStore.billingAddress!.country.validate());

    billFirstNameCont.text = userStore.billingAddress!.first_name.validate();
    billLastNameCont.text = userStore.billingAddress!.last_name.validate();
    billEmailCont.text = userStore.billingAddress!.email.validate();
    billPhoneCont.text = userStore.billingAddress!.phone.validate();
    billCityCont.text = userStore.billingAddress!.city.validate();
    billCountryCont.text = userStore.billingAddress!.country.validate();
    billStateCont.text = userStore.billingAddress!.state.validate();
    billPinCodeCont.text = userStore.billingAddress!.postcode.validate();
    billCompanyCont.text = userStore.billingAddress!.company.validate();
    billAddress1Cont.text = userStore.billingAddress!.address_1.validate();
    billAddress2Cont.text = userStore.billingAddress!.address_2.validate();

    shippingFirstNameCont.text = userStore.shippingAddress!.first_name.validate();
    shippingLastNameCont.text = userStore.shippingAddress!.last_name.validate();
    shippingEmailCont.text = userStore.shippingAddress!.email.validate();
    shippingPhoneCont.text = userStore.shippingAddress!.phone.validate();
    shippingCityCont.text = userStore.shippingAddress!.city.validate();
    shippingPinCodeCont.text = userStore.shippingAddress!.postcode.validate();
    shippingCompanyCont.text = userStore.shippingAddress!.company.validate();
    shippingStateCont.text = userStore.shippingAddress!.state.validate();
    shippingCountryCont.text = userStore.shippingAddress!.country.validate();
    shippingAddress1Cont.text = userStore.shippingAddress!.address_1.validate();
    shippingAddress2Cont.text = userStore.shippingAddress!.address_2.validate();
  }

  void fillShipping() {
    if (isSame) {
      shippingFirstNameCont.text = userStore.billingAddress!.first_name.validate();
      shippingLastNameCont.text = userStore.billingAddress!.last_name.validate();
      shippingEmailCont.text = userStore.billingAddress!.email.validate();
      shippingPhoneCont.text = userStore.billingAddress!.phone.validate();
      shippingCityCont.text = userStore.billingAddress!.city.validate();
      shippingPinCodeCont.text = userStore.billingAddress!.postcode.validate();
      shippingCompanyCont.text = userStore.billingAddress!.company.validate();
      shippingSelectedCountryResponse = billingSelectedCountry;
      shippingStateList.clear();
      shippingStateList.addAll(shippingSelectedCountryResponse!.states!);
      shippingAddress1Cont.text = userStore.billingAddress!.address_1.validate();
      shippingAddress2Cont.text = userStore.billingAddress!.address_2.validate();
    } else {
      shippingFirstNameCont.text = "";
      shippingLastNameCont.text = "";
      shippingEmailCont.text = "";
      shippingPhoneCont.text = "";
      shippingCityCont.text = "";
      shippingPinCodeCont.text = "";
      shippingCompanyCont.text = "";
      shippingStateCont.text = "";
      shippingCountryCont.text = "";
      shippingAddress1Cont.text = "";
      shippingAddress2Cont.text = "";
    }
    // log(txtShippingFirstName.text);

    storeData();
    setState(() {});
  }

  void storeData() {
    Billing shipping = Billing();

    shipping.first_name = shippingFirstNameCont.text;
    shipping.last_name = shippingLastNameCont.text;
    shipping.email = shippingEmailCont.text;
    shipping.phone = shippingPhoneCont.text;
    shipping.city = shippingCityCont.text;
    shipping.postcode = shippingPinCodeCont.text;
    shipping.company = shippingCompanyCont.text;
    shipping.state = shippingSelectedCountryState != null ? shippingSelectedCountryState!.name : "";
    shipping.country = shippingSelectedCountryResponse!.name;
    shipping.address_1 = shippingAddress1Cont.text;
    shipping.address_2 = shippingAddress2Cont.text;

    Billing shipping1 = Billing();

    shipping1.first_name = billFirstNameCont.text;
    shipping1.last_name = billLastNameCont.text;
    shipping1.email = billEmailCont.text;
    shipping1.phone = billPhoneCont.text;
    shipping1.city = billCityCont.text;
    shipping1.postcode = billPinCodeCont.text;
    shipping1.company = billCompanyCont.text;
    shipping1.state = billingSelectedState != null ? billingSelectedState!.name : "";
    shipping1.country = billingSelectedCountry!.name;
    shipping1.address_1 = billAddress1Cont.text;
    shipping1.address_2 = billAddress2Cont.text;

    userStore.setShippingAddress(shipping);
    userStore.setBillingAddress(shipping1);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<XFile?> getImg() async {
    return ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
  }

  Widget profileImage() {
    if (image != null) {
      return Image.file(File(image!.path), height: 280, width: context.width(), fit: BoxFit.cover);
    } else {
      return Image.network(
        profileImageUrl,
        height: 280,
        width: context.width(),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeHolderWidget(height: 280, fit: BoxFit.cover),
      );
    }
  }

  ImageProvider providerImage() {
    if (image != null) {
      return Image.file(File(image!.path), fit: BoxFit.cover).image;
    } else {
      return Image.network(
        profileImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeHolderWidget(),
      ).image;
    }
  }

  void submit() async {
    storeData();
    if (formKey.currentState!.validate()) {
      log("userStore.billingAddress!.toJson()" + userStore.billingAddress!.toJson().toString());
      Map<String, dynamic> req = {
        'email': emailNameCont.text.trim(),
        'first_name': firstNameCont.text.trim(),
        'last_name': lastNameCont.text.trim(),
        'billing': userStore.billingAddress!.toJson(),
        'shipping': userStore.shippingAddress!.toJson(),
      };
      log(req);
      _btnController.start();
      showDialogBox(context, language.are_you_sure_you_want_to_update_the_profile, () async {
        await authApi.updateCustomer(req: req, id: userStore.userId).then((value) async {
          _btnController.success();

          userStore.setFirstName(value.first_name.validate());
          userStore.setLastName(value.last_name.validate());
          userStore.setUserName("${value.first_name.validate()} ${value.last_name.validate()}");

          userStore.setShippingAddress(value.shipping);
          userStore.setBillingAddress(value.billing);

          finish(context);
          finish(context);
        }).catchError((e) {
          toast(e.toString());
          _btnController.error();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.edit_Profile, textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Observer(
        builder: (_) => appStore.isLoading
            ? AppLoader().center()
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: profileImage().center(),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: boxDecorationDefault(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 4),
                              image: DecorationImage(
                                image: providerImage(),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) => placeHolderWidget(),
                              ),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                Container(
                                  decoration: boxDecorationDefault(color: context.cardColor),
                                  child: IconButton(
                                    onPressed: () async {
                                      image = await getImg();
                                      setState(() {});
                                      if (image != null) {
                                        await 4.microseconds.delay;
                                        showDialogBox(context, language.lbluploadImage, () {
                                          authApi.updateProfileImage(file: File(image!.path.validate())).then(
                                            (value) {
                                              finish(context);
                                            },
                                          ).catchError(
                                            (e) {
                                              toast(e.toString());
                                            },
                                          );
                                        });
                                      }
                                    },
                                    icon: Icon(MaterialIcons.add_a_photo),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).visible(!isSocial),
                      8.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language.personal_Details, style: boldTextStyle(size: 20)),
                          16.height,
                          AppTextField(
                            controller: firstNameCont,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(context, label: language.first_Name),
                          ),
                          16.height,
                          AppTextField(
                            controller: lastNameCont,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(context, label: language.last_Name),
                          ),
                          16.height,
                          AppTextField(
                            controller: emailNameCont,
                            textFieldType: TextFieldType.EMAIL,
                            readOnly: true,
                            decoration: inputDecoration(context, label: language.email),
                          ),
                        ],
                      ).paddingAll(16),
                      TabBar(
                        indicatorColor: primaryColor,
                        controller: tabBarController,
                        onTap: (c) {
                          isSelectedIndex = c;
                          setState(() {});
                        },
                        labelPadding: EdgeInsets.all(8),
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Text(language.billing_Addres, style: boldTextStyle()),
                          Text(language.shipping_Address, style: boldTextStyle()),
                        ],
                      ),
                      32.height,
                      IndexedStack(
                        index: isSelectedIndex,
                        children: [
                          billingComponent(),
                          shippingComponent(),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      Row(
                        children: [
                          AppButton(
                            color: context.scaffoldBackgroundColor,
                            elevation: 0,
                            textStyle: boldTextStyle(),
                            shapeBorder: RoundedRectangleBorder(side: BorderSide(color: viewLineColor), borderRadius: radius()),
                            onTap: () {
                              //
                            },
                            text: language.cancel,
                          ).expand(),
                          16.width,
                          RoundedLoadingButton(
                            successIcon: Icons.done,
                            failedIcon: Icons.close,
                            borderRadius: defaultRadius,
                            child: Text(language.submit, style: boldTextStyle(color: Colors.white)),
                            controller: _btnController,
                            animateOnTap: false,
                            resetAfterDuration: true,
                            color: context.primaryColor,
                            onPressed: () {
                              submit();
                            },
                          ).expand(),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      64.height,
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  getState() {
    billingStateList.clear();
    billingStateList.addAll(billingSelectedCountry!.states!);
    setState(() {});
    billingStateList.forEach((e) {
      billingSelectedState = e;
    });
  }

  getShippingState() {
    shippingStateList.clear();
    shippingStateList.addAll(shippingSelectedCountryResponse!.states!);
    setState(() {});
    shippingStateList.forEach((e) {
      shippingSelectedCountryState = e;
    });
  }

  billingComponent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppTextField(
                controller: billFirstNameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, label: language.first_Name),
                focus: billFirstNameFocus,
                nextFocus: billLastNameFocus,
              ).expand(),
              16.width,
              AppTextField(
                controller: billLastNameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, label: language.last_Name),
                focus: billLastNameFocus,
                nextFocus: billEmailFocus,
              ).expand(),
            ],
          ),
          16.height,
          AppTextField(
            controller: billEmailCont,
            textFieldType: TextFieldType.EMAIL,
            decoration: inputDecoration(context, label: language.email),
            focus: billEmailFocus,
            nextFocus: billCityFocus,
          ),
          16.height,
          Row(
            children: [
              AppTextField(
                controller: billCityCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, label: language.city),
                focus: billCityFocus,
                nextFocus: billPinCodeFocus,
              ).expand(),
              16.width,
              AppTextField(
                controller: billPinCodeCont,
                textFieldType: TextFieldType.PHONE,
                decoration: inputDecoration(context, label: language.pinCode),
                focus: billPinCodeFocus,
                nextFocus: billCompanyFocus,
                validator: (v) {
                  //
                },
              ).expand(),
            ],
          ),
          16.height,
          Row(
            children: [
              DropdownButtonFormField<CountryResponse>(
                decoration: inputDecoration(context, label: ""),
                hint: Text(language.country, style: secondaryTextStyle()),
                isExpanded: true,
                value: billingSelectedCountry,
                items: billingCountryList.map((CountryResponse e) {
                  return DropdownMenuItem<CountryResponse>(
                    value: e,
                    child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (c) {
                  hideKeyboard(context);
                  billingSelectedCountry = c!;
                  if (c != null) {
                    billSelectedCountry = billingSelectedCountry!.name;
                    log(billSelectedCountry);
                  }
                  getState();
                  setState(() {});
                },
              ).expand(),
              16.width,
              DropdownButtonFormField<CountryState>(
                decoration: inputDecoration(context, label: ""),
                hint: Text(language.state, style: secondaryTextStyle()),
                value: billingSelectedState,
                isExpanded: true,
                items: billingSelectedState == null
                    ? []
                    : billingStateList.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                              style: primaryTextStyle(),
                            ),
                          );
                        },
                      ).toList(),
                onChanged: (c) {
                  billingSelectedState = c!;
                  if (c != null) {
                    billSelectedState = billingSelectedState!.name;
                  }
                  setState(() {});
                  log(billingSelectedState!.name);
                },
              ).expand(),
            ],
          ),
          16.height,
          AppTextField(
            controller: billCompanyCont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: language.company),
            focus: billCompanyFocus,
            nextFocus: billPhoneFocus,
          ),
          16.height,
          AppTextField(
            controller: billPhoneCont,
            textFieldType: TextFieldType.PHONE,
            decoration: inputDecoration(context, label: language.phone),
            focus: billPhoneFocus,
            nextFocus: billStateFocus,
          ),
          16.height,
          AppTextField(
            controller: billAddress1Cont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: language.address_1),
            focus: billAddress1Focus,
            nextFocus: billAddress2Focus,
          ),
          16.height,
          AppTextField(
            controller: billAddress2Cont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: language.address_2),
            focus: billAddress2Focus,
          ),
        ],
      ),
    );
  }

  shippingComponent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppTextField(
                controller: shippingFirstNameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, label: language.first_Name),
                focus: shippingFirstNameFocus,
                nextFocus: shippingLastNameFocus,
              ).expand(),
              16.width,
              AppTextField(
                controller: shippingLastNameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, label: language.last_Name),
                focus: shippingLastNameFocus,
                nextFocus: shippingEmailFocus,
              ).expand(),
            ],
          ),
          16.height,
          AppTextField(
            controller: shippingEmailCont,
            textFieldType: TextFieldType.EMAIL,
            decoration: inputDecoration(context, label: language.email),
            focus: shippingEmailFocus,
            isValidationRequired: true,
            nextFocus: shippingCityFocus,
          ),
          16.height,
          Row(
            children: [
              AppTextField(
                controller: shippingCityCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, label: language.city),
                focus: shippingCityFocus,
                nextFocus: shippingPinCodeFocus,
              ).expand(),
              16.width,
              AppTextField(
                controller: shippingPinCodeCont,
                textFieldType: TextFieldType.PHONE,
                decoration: inputDecoration(context, label: language.pinCode),
                focus: shippingPinCodeFocus,
                nextFocus: shippingCompanyFocus,
                validator: (v) {
                  //
                },
              ).expand(),
            ],
          ),
          16.height,
          Row(
            children: [
              DropdownButtonFormField<CountryResponse>(
                decoration: inputDecoration(context, label: ""),
                hint: Text(language.country, style: secondaryTextStyle()),
                isExpanded: true,
                value: shippingSelectedCountryResponse,
                items: shippingCountryList.map((CountryResponse e) {
                  return DropdownMenuItem<CountryResponse>(
                    value: e,
                    child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (c) {
                  hideKeyboard(context);
                  shippingSelectedCountryResponse = c!;
                  getShippingState();
                  setState(() {});
                },
              ).expand(),
              16.width,
              DropdownButtonFormField<CountryState>(
                decoration: inputDecoration(context, label: ""),
                hint: Text(language.state, style: secondaryTextStyle()),
                value: shippingSelectedCountryState,
                isExpanded: true,
                items: shippingSelectedCountryState == null
                    ? []
                    : shippingStateList.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                              style: primaryTextStyle(),
                            ),
                          );
                        },
                      ).toList(),
                onChanged: (c) {
                  shippingSelectedCountryState = c!;
                  setState(() {});
                  log(shippingSelectedCountryState!.name);
                },
              ).expand(),
            ],
          ),
          16.height,
          AppTextField(
            controller: shippingCompanyCont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: language.country),
            focus: shippingCompanyFocus,
            nextFocus: shippingPhoneFocus,
          ),
          16.height,
          AppTextField(
            controller: shippingPhoneCont,
            textFieldType: TextFieldType.PHONE,
            decoration: inputDecoration(context, label: language.phone),
            focus: shippingPhoneFocus,
            nextFocus: shippingStateFocus,
          ),
          16.height,
          AppTextField(
            controller: shippingAddress1Cont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: language.address_1),
            focus: shippingAddress1Focus,
            nextFocus: shippingAddress2Focus,
          ),
          16.height,
          AppTextField(
            controller: shippingAddress2Cont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: language.address_2),
            focus: shippingAddress2Focus,
          ),
          16.height,
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(language.lblSameasBilling, style: secondaryTextStyle()),
                Icon(isSame == true ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSame == true
                            ? appStore.isDarkMode
                                ? Colors.white
                                : Colors.black
                            : Colors.grey,
                        size: 30)
                    .onTap(() {
                  isSame = !isSame;
                  if (isSame == true) {
                    Billing shippingData = Billing();

                    shippingData.first_name = billFirstNameCont.text;
                    shippingData.last_name = billLastNameCont.text;
                    shippingData.email = billEmailCont.text;
                    shippingData.phone = billPhoneCont.text;
                    shippingData.city = billCityCont.text;
                    shippingData.postcode = billPinCodeCont.text;
                    shippingData.company = billCompanyCont.text;

                    shippingSelectedCountryResponse = billingSelectedCountry;
                    shippingStateList.clear();
                    // shippingSelectedCountryResponse = billingSelectedCountry;
                    // shippingStateList.clear();
                    shippingStateList.addAll(shippingSelectedCountryResponse!.states!);
                    shippingSelectedCountryState = shippingStateList.isNotEmpty ? billingSelectedState : null;

                    shippingData.address_1 = billAddress1Cont.text;
                    shippingData.address_2 = billAddress2Cont.text;

                    userStore.setBillingAddress(shippingData);
                    fillShipping();
                  }
                  setState(() {});
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

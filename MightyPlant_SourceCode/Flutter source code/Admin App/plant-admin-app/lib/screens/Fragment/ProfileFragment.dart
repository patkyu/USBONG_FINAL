import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/screens/AboutUsScreen.dart';
import 'package:mighty_plant_admin/screens/AllCustomerListScreen.dart';
import 'package:mighty_plant_admin/screens/CategoryScreen.dart';
import 'package:mighty_plant_admin/screens/ProductAttributeScreen.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppLocalizations.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../ProductReviewScreen.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileFragment';

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 2));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: appBarWidget(
        "",
        titleWidget: Row(
          children: [
            cachedImage(app_logo, height: 50, width: 50, color: white),
            8.width,
            Text("lbl_profile".translate, style: boldTextStyle(color: white, size: 20)),
          ],
        ),
        elevation: 0,
        color: primaryColor,
        showBack: false,
        center: false,
      ),
      body: SingleChildScrollView(
        child: Observer(
          builder: (_) =>
              Column(
                children: [
                  Container(
                    padding:EdgeInsets.all(16),
                    child: Row(
                      children: [
                        cachedImage(getStringAsync(AVATAR),
                            height: 60, width: 60, fit: BoxFit.cover)
                            .cornerRadiusWithClipRRect(30),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${getStringAsync(FIRST_NAME)} ${getStringAsync(LAST_NAME)}',
                                style: boldTextStyle(size: 18)),
                            Text(getStringAsync(USER_EMAIL),
                                style: secondaryTextStyle()),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (!isVendor)
                    SettingItemWidget(
                      title: "lbl_All_Customer".translate,
                      titleTextStyle: primaryTextStyle(size: 18),
                      leading: Image.asset(ic_user,
                          height: 20,
                          width: 20,
                          color: appStore.iconSecondaryColor),
                      onTap: () {
                        AllCustomerListScreen().launch(context);
                      },
                    ),
                  SettingItemWidget(
                    title: "lbl_Product_Attribute".translate,
                    titleTextStyle: primaryTextStyle(size: 18),
                    leading: Image.asset(ic_category,
                        height: 20, width: 20, color: appStore.iconSecondaryColor),
                    onTap: () {
                      ProductAttributeScreen().launch(context);
                    },
                  ),
                  SettingItemWidget(
                    title: "lbl_Category".translate,
                    titleTextStyle: primaryTextStyle(size: 18),
                    leading: Image.asset(ic_category,
                        height: 20, width: 20, color: appStore.iconSecondaryColor),
                    onTap: () {
                      CategoryScreen().launch(context);
                    },
                  ),
                  SettingItemWidget(
                    title: "lbl_reviews".translate,
                    titleTextStyle: primaryTextStyle(size: 18),
                    leading:
                    Icon(AntDesign.staro, color: appStore.iconSecondaryColor),
                    onTap: () {
                      ProductReviewScreen().launch(context);
                    },
                  ).visible(!isVendor),
                  SettingItemWidget(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    title: "lbl_mode".translate,
                    titleTextStyle: primaryTextStyle(size: 18),
                    onTap: () async {
                      appStore.toggleDarkMode(value: !appStore.isDarkModeOn);
                    },
                    leading: Icon(MaterialCommunityIcons.theme_light_dark,
                        color: appStore.iconSecondaryColor),
                    trailing: Switch(
                      value: appStore.isDarkModeOn,
                      onChanged: (s) async {
                        appStore.toggleDarkMode(value: s);
                      },
                    ),
                  ),
                  SettingItemWidget(
                    titleTextStyle: primaryTextStyle(size: 18),
                    leading:
                    Icon(Icons.language, color: appStore.iconSecondaryColor),
                    title: "language".translate,
                    trailing: LanguageListWidget(
                      widgetType: WidgetType.DROPDOWN,
                      onLanguageChange: (LanguageDataModel s) async {
                        appStore.setLanguage(s.languageCode);
                        finish(context);
                      },
                    ),
                  ),
                  SettingItemWidget(
                    title: "lbl_about_us".translate,
                    titleTextStyle: primaryTextStyle(size: 18),
                    leading: Icon(MaterialCommunityIcons.information_outline,
                        color: appStore.iconSecondaryColor),
                    onTap: () {
                      AboutUsScreen().launch(context);
                    },
                  ),
                  SettingItemWidget(
                    title: "lbl_logout".translate,
                    titleTextStyle: primaryTextStyle(size: 18),
                    leading: Image.asset(ic_login,
                        height: 20, width: 20, color: appStore.iconSecondaryColor),
                    onTap: () async {
                      logout(context);
                    },
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

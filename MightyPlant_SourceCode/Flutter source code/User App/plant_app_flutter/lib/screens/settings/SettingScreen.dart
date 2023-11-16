import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/SignIn/SignInScreen.dart';
import 'package:plant_flutter/screens/orders/OrderListScreen.dart';
import 'package:plant_flutter/screens/settings/components/headerComponent.dart';
import 'package:plant_flutter/screens/settings/components/SettingItemCard.dart';
import 'package:plant_flutter/screens/settings/HelpSupportScreen.dart';
import 'package:plant_flutter/screens/settings/LanguageScreen.dart';
import 'package:plant_flutter/screens/settings/ThemeScreen.dart';
import 'package:plant_flutter/screens/userSettings/EditProfileScreen.dart';
import 'package:plant_flutter/screens/userSettings/ChangePasswordScreen.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 20,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                if (userStore.isLoggedIn) headerComponent(context),
                if (userStore.isLoggedIn) 8.height,
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    if (!userStore.isLoggedIn)
                      SettingItemCard(
                        context: context,
                        title: language.login,
                        icon: Icons.login,
                        subTitle: language.welcome_planter,
                        onTap: () {
                          push(SignInScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      ),
                    if (userStore.isLoggedIn)
                      SettingItemCard(
                        context: context,
                        title: language.edit_Profile,
                        icon: MaterialCommunityIcons.account_edit_outline,
                        subTitle: language.change_your_Profile,
                        onTap: () {
                          push(EditProfileScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      ),
                    if (userStore.isLoggedIn && !isSocial)
                      SettingItemCard(
                        context: context,
                        title: language.change_Password,
                        icon: Ionicons.key_outline,
                        subTitle: language.update_Password_to_be_secure,
                        onTap: () {
                          push(ChangePasswordScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      ),
                    if (userStore.isLoggedIn)
                      SettingItemCard(
                        context: context,
                        title: language.orders,
                        icon: SimpleLineIcons.social_dropbox,
                        subTitle: language.iew_All_your_orders,
                        onTap: () {
                          push(OrderListScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      ),
                    SettingItemCard(
                      context: context,
                      title: language.language,
                      icon: Entypo.language,
                      subTitle: appStore.selectedLanguage,
                      onTap: () {
                        push(LanguageScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                    ),
                    SettingItemCard(
                      context: context,
                      title: language.system_Theme,
                      icon: Icons.dark_mode_outlined,
                      subTitle: getStringAsync(sharedPref.appThemeMode),
                      onTap: () {
                        var res = ThemeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                        if (res.toString() == 'true') {
                          setState(() {});
                        }
                      },
                    ),
                    SettingItemCard(
                      context: context,
                      title: language.help_and_Support,
                      icon: Icons.help_outline_outlined,
                      subTitle: language.quires_are_welcomed,
                      onTap: () {
                        push(HelpSupportScreen(), pageRouteAnimation: PageRouteAnimation.Slide, duration: 250.milliseconds);
                      },
                    ),
                    SettingItemCard(
                      context: context,
                      title: language.share,
                      icon: FontAwesome.share_square_o,
                      subTitle: language.spread_more,
                      onTap: () {
                        PackageInfo.fromPlatform().then((value) {
                          Share.share('Share $appName app\n $appDesc\n$playStoreBaseURL${value.packageName}');
                        });
                      },
                    ),
                    if (userStore.isLoggedIn)
                      SettingItemCard(
                        context: context,
                        title: language.logout,
                        icon: Icons.logout,
                        subTitle: language.know_us_more,
                        onTap: () {
                          showDialogBox(context, language.lblLogOutMsg, () {
                            authApi.logout(context);
                            setState(() {});
                          });
                        },
                      ),
                  ],
                ).paddingAll(16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

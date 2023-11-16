import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/screens/DashBoardScreen.dart';
import 'package:mighty_plant_admin/screens/SignInScreen.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppLocalizations.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent,statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark);
    appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
    checkFirstSeen();
  }

  Future<void> checkFirstSeen() async {
    await Future.delayed(Duration(seconds: 2));
    appLocalizations = AppLocalizations.of(context);

    await Future.delayed(Duration(seconds: 2));

    if (appStore.isLoggedIn) {
      currentUrl = isVendor ? vendorUrl : adminUrl;
      if (!getBoolAsync(REMEMBER_PASSWORD, defaultValue: true)) {
        appStore.setLoggedIn(false);
        DashBoardScreen().launch(context, isNewTask: true);
      } else {
        DashBoardScreen().launch(context, isNewTask: true);
      }
    } else {
      SignInScreen().launch(context, isNewTask: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(splash_logo, width:150, height:150, fit: BoxFit.contain),
      ),
    );
  }
}

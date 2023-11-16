import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/screens/GetStartedScreen.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:plant_flutter/utils/images.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(Colors.black.withOpacity(0.1), statusBarIconBrightness: Brightness.light);

    2.seconds.delay.then((value) {
      if (getBoolAsync(sharedPref.isFirstTime, defaultValue: true)) {
        push(GetStartedScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade, duration: 800.milliseconds);
      } else {
        push(GetStartedScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade, duration: 800.milliseconds);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(appImages.splashLogo, height: 150, width: 150, fit: BoxFit.cover).center(),
    );
  }
}

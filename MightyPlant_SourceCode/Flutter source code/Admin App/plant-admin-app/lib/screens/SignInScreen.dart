import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/component/SignInComponent.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:nb_utils/nb_utils.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen>  with TickerProviderStateMixin{
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(primaryColor,statusBarIconBrightness: Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height(),
        child: Stack(
          children: [
            Container(
              height: 300,
              width: context.width(),
              color: primaryColor,
              padding: EdgeInsets.symmetric(vertical:60,horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "lbl_welcome".translate,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: boldTextStyle(size: 32,color: Colors.white),
                  ),
                 4.height,
                  Text(
                    "lbl_welcome_text".translate,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: secondaryTextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200, left: 16, right: 16,bottom: 16),
              padding: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
              decoration: boxDecorationWithShadow(
                shadowColor: primaryColor.withOpacity(0.2),
                borderRadius: radius(20),
                backgroundColor: context.cardColor,
              ),
              child: SignInComponent(),
            ),
          ],
        ),
      ),
    );
  }
}


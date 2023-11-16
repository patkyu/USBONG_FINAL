import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/screens/SignIn/SignInScreen.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/images.dart';

class LoginRequiredWidget extends StatelessWidget {
  final String? title;

  LoginRequiredWidget({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          16.height,
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(
              shape: BoxShape.circle,
              boxShadow: defaultBoxShadow(spreadRadius: 0, blurRadius: 0),
              color: primaryColor.withOpacity(0.2),
            ),
            child: Image.asset(appImages.appLogo,color: primaryColor, height: 120),
          ),
          32.height,
          Text(language.sign_in_to_view_your+' $title', style: boldTextStyle(size: 18)),
          4.height,
          Text(language.shop_them_anytime_you_like , style: primaryTextStyle()),
          32.height,
          AppButton(
            width: context.width() * 0.6,
            text: language.login,
            color: primaryColor,
            onTap: () {
              push(SignInScreen(), pageRouteAnimation: PageRouteAnimation.Scale);
            },
          )
        ],
      ),
    ).center();
  }
}

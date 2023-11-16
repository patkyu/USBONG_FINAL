import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/screens/DashBoardScreen.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SignInComponent extends StatefulWidget {
  @override
  _SignInComponentState createState() => _SignInComponentState();
}

class _SignInComponentState extends State<SignInComponent> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Admin:  mighty.plantapp  |  MJ3T(SIYLuS(njof9
  //vendor: mighty.plantvendor  |  RL8)fcw5lZnSUu^yck7!hGW(

  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isRemember = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  Future<void> signInApi(req) async {
    appStore.setLoading(true);

    await login(req).then((res) async {
      if (!mounted) return;

      appStore.setLoading(false);

      if (appStore.isLoggedIn) DashBoardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((error) {
      appStore.setLoading(false);

      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("lbl_sign_in".translate, style: boldTextStyle(size: 20)),
                30.height,
                AppTextField(
                  controller: usernameCont,
                  textFieldType: TextFieldType.NAME,
                  focus: usernameFocus,
                  nextFocus: passwordFocus,
                  textStyle: secondaryTextStyle(),
                  decoration: commonInputDecoration(context, label: "hint_Username".translate),
                ),
                spacing_standard_new.height,
                AppTextField(
                  controller: passwordCont,
                  textFieldType: TextFieldType.PASSWORD,
                  focus: passwordFocus,
                  textStyle: secondaryTextStyle(),
                  decoration: commonInputDecoration(context, label: "hint_password".translate),
                ),
                30.height,
                Row(
                  children: [
                    Checkbox(
                      focusColor: primaryColor,
                      activeColor: primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: getBoolAsync(REMEMBER_PASSWORD, defaultValue: true),
                      onChanged: (bool? value) async {
                        await setValue(REMEMBER_PASSWORD, value);
                        setState(() {});
                      },
                    ),
                    Text("lbl_remember_me".translate, style: primaryTextStyle()).onTap(() async {
                      await setValue(REMEMBER_PASSWORD, !getBoolAsync(REMEMBER_PASSWORD));
                      setState(() {});
                    }),
                  ],
                ),
                50.height,
                AppButton(
                  width: context.width(),
                  color: primaryColor,
                  text: "lbl_sign_in".translate,
                  textStyle: primaryTextStyle(letterSpacing: 1, color: Colors.white),
                  onTap: () {
                    hideKeyboard(context);
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (!mounted) return;
                      if (usernameCont.text.isEmpty)
                        toast("hint_Username".translate + " " + "error_field_required".translate);
                      else if (passwordCont.text.isEmpty)
                        toast("hint_password".translate + " " + "error_field_required".translate);
                      else {
                        appStore.setLoading(false);
                        var request = {"username": "${usernameCont.text}", "password": "${passwordCont.text}"};
                        signInApi(request);
                      }
                      if (!accessAllowed) {
                        toast("Sorry");
                        return;
                      }
                    }
                    setState(() {});
                  },
                ),
                16.height,
              ],
            ),
          ),
        ),
        Observer(
          builder: (context) => loading().visible(appStore.isLoading),
        )
      ],
    );
  }
}

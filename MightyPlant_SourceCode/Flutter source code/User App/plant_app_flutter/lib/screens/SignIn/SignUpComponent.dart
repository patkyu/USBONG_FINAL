import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/WebViewScreen.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/DashboardScreen.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/widgets/rounded_loading_button.dart';

class SignUpComponent extends StatefulWidget {
  @override
  _SignUpComponentState createState() => _SignUpComponentState();
}

class _SignUpComponentState extends State<SignUpComponent> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);

      _btnController.start();
      await authApi
          .signUp(
              firstName: firstNameCont.text.trim(),
              lastName: lastNameCont.text.trim(),
              userLogin: userNameCont.text.trim(),
              userEmail: emailCont.text.validate(),
              password: passwordCont.text.validate())
          .then(
        (value) async {
          _btnController.success();
          DashboardScreen().launch(context, isNewTask: true);
        },
      ).catchError(
        (error) {
          toast(error.toString());
          _btnController.error();
        },
      ).whenComplete(
        () => _btnController.stop(),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: boxDecorationDefault(
          color: context.cardColor,
          borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
          boxShadow: [
            BoxShadow(color: shadowColorGlobal, offset: Offset(2, 0)),
            BoxShadow(color: shadowColorGlobal, offset: Offset(0, 2)),
            BoxShadow(color: shadowColorGlobal, offset: Offset(-2, 0)),
          ],
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: firstNameCont,
                  focus: firstNameFocus,
                  nextFocus: lastNameFocus,
                  decoration: inputDecoration(context, label: language.first_Name),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: lastNameCont,
                  focus: lastNameFocus,
                  nextFocus: userNameFocus,
                  decoration: inputDecoration(context, label: language.last_Name),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.USERNAME,
                  controller: userNameCont,
                  focus: userNameFocus,
                  nextFocus: emailFocus,
                  decoration: inputDecoration(context, label: language.username),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.EMAIL,
                  controller: emailCont,
                  focus: emailFocus,
                  nextFocus: passwordFocus,
                  decoration: inputDecoration(context, label: language.email),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.PASSWORD,
                  controller: passwordCont,
                  focus: passwordFocus,
                  decoration: inputDecoration(context, label: language.password),
                ),
                30.height,
                RoundedLoadingButton(
                  successIcon: Icons.done,
                  failedIcon: Icons.close,
                  borderRadius: defaultRadius,
                  child: Text(language.submit, style: boldTextStyle(color: Colors.white)),
                  controller: _btnController,
                  animateOnTap: false,
                  resetAfterDuration: true,
                  width: context.width() * 0.8,
                  color: context.primaryColor,
                  onPressed: () => submit(),
                ),
                16.height,
                createRichText(
                  textAlign: TextAlign.center,
                  list: [
                    TextSpan(text: language.by_Submitting_you_are_agreeing_to, style: primaryTextStyle(size: 12)),
                    TextSpan(
                      text: language.terms_and_conditions,
                      style: boldTextStyle(size: 12, color: primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          push(WebViewScreen(url: userStore.term_condition, name: language.terms_and_conditions));
                        },
                    ),
                    TextSpan(text: " & ", style: primaryTextStyle(size: 12)),
                    TextSpan(
                      text: language.privacy_policy,
                      style: boldTextStyle(size: 12, color: primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          push(WebViewScreen(url: userStore.privacy_policy, name: language.privacy_policy));
                        },
                    ),
                  ],
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

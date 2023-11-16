import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/screens/SignIn/ForgotPasswordDialog.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/network/AuthService.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/DashboardScreen.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:plant_flutter/utils/widgets/rounded_loading_button.dart';

class SignInComponent extends StatefulWidget {
  @override
  _SignInComponentState createState() => _SignInComponentState();
}

class _SignInComponentState extends State<SignInComponent> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isValue = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (getBoolAsync(sharedPref.isRemember)) {
      log(emailCont.text.toString());
      emailCont.text = getStringAsync(sharedPref.userEmail);
      passwordCont.text = getStringAsync(sharedPref.userPassword);
    }
  }

  Future<void> submit() async {
    hideKeyboard(context);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _btnController.start();

      Map<String, dynamic> req = {
        'username': emailCont.text.trim(),
        'password': passwordCont.text.trim(),
        "loginType": LoginTypeApp,
      };

      await authApi.logInApi(req).then((value) async {
        _btnController.success();

        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        toast(e.toString());
        _btnController.error();
      }).whenComplete(
        () => _btnController.stop(),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedContainer(
            decoration: boxDecorationDefault(
              color: context.cardColor,
              borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
              boxShadow: [
                BoxShadow(color: shadowColorGlobal, offset: Offset(2, 0)),
                BoxShadow(color: shadowColorGlobal, offset: Offset(0, 2)),
                BoxShadow(color: shadowColorGlobal, offset: Offset(-2, 0)),
              ],
            ),
            duration: 200.milliseconds,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: passwordFocus,
                      textFieldType: TextFieldType.OTHER,
                      validator: (String? value) {
                        if (value.validate().isEmpty) return errorThisFieldRequired;
                      },
                      decoration: inputDecoration(context, label: language.username_or_Email),
                    ),
                    16.height,
                    AppTextField(
                      controller: passwordCont,
                      focus: passwordFocus,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: inputDecoration(context, label: language.password),
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(),
                                activeColor: primaryColor,
                                value: getBoolAsync(sharedPref.isRemember),
                                onChanged: (v) async {
                                  await setValue(sharedPref.isRemember, v);
                                  setState(() {});
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await setValue(sharedPref.isRemember, !getBoolAsync(sharedPref.isRemember));
                                setState(() {});
                              },
                              child: Text(language.remember_me, style: secondaryTextStyle()),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            showInDialog(
                              context,
                              dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                              builder: (_) => ForgotPasswordDialog(),
                              shape: RoundedRectangleBorder(borderRadius: radius()),
                            );
                          },
                          child: Text(language.forgot_Password, style: secondaryTextStyle(color: primaryColor)),
                        ),
                      ],
                    ),
                    32.height,
                    RoundedLoadingButton(
                      successIcon: Icons.done,
                      failedIcon: Icons.close,
                      borderRadius: defaultRadius,
                      child: Text(language.submit, style: boldTextStyle(color: Colors.white)),
                      controller: _btnController,
                      animateOnTap: false,
                      resetAfterDuration: true,
                      width: context.width() * 0.88,
                      color: context.primaryColor,
                      onPressed: () => submit(),
                    ),
                    16.height,
                    Text('Or', style: boldTextStyle()),
                    16.height,
                    AppButton(
                      onTap: () async {
                        appStore.setLoading(true);
                        await signInWithGoogle().then((value) async {
                          return await authApi.logInApi(value, isSocialLogin: true).then((value) {
                            push(DashboardScreen(), isNewTask: true);
                          }).catchError((e) {
                            if (e == "You are already registered with us.") {
                              throw language.you_are_already_registered_with_us;
                            }
                            throw errorSomethingWentWrong;
                          });
                        }).catchError((e) {
                          toast(e.toString());
                        });
                        appStore.setLoading(false);
                      },
                      width: context.width() * 0.8,
                      color: context.scaffoldBackgroundColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GoogleLogoWidget(),
                          16.width,
                          Text(language.sign_in_with_google, style: boldTextStyle()),
                        ],
                      ),
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.dividerColor)),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Observer(
            builder: (context) => AppLoader().center().visible(appStore.isLoading),
          )
        ],
      ),
    );
  }
}

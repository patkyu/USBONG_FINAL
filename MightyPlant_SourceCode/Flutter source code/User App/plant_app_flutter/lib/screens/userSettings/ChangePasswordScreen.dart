import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:plant_flutter/utils/widgets/rounded_loading_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  var oldPassCont = TextEditingController();
  var newPassCont = TextEditingController();
  var confNewPassCont = TextEditingController();

  var newPassFocus = FocusNode();
  var confPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    appStore.setLoading(false);
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      Map req = {
        'old_password': oldPassCont.text.trim(),
        'new_password': newPassCont.text.trim(),
      };
      _btnController.start();
      await authApi.changePassword(req).then((value) {
        setValue(sharedPref.userPassword, newPassCont.text);
        toast(value.message.validate());
        _btnController.success();
        finish(context);
      }).catchError((error) {
        log(error);
        _btnController.error();
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblChangePassword, textColor: Colors.white,backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Observer(
          builder: (_) => SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  AppTextField(
                    controller: oldPassCont,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: inputDecoration(context, label: "${language.lblOldPassword}"),
                    nextFocus: newPassFocus,
                    textStyle: primaryTextStyle(),
                    autoFillHints: [AutofillHints.password],
                    validator: (String? s) {
                      if (s!.isEmpty) return errorThisFieldRequired;
                      if (s != getStringAsync(sharedPref.userPassword)) return '${language.lblOldPasswordIsNotCorrect}';

                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: newPassCont,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: inputDecoration(context, label: '${language.lblNewPassword}'),
                    focus: newPassFocus,
                    nextFocus: confPassFocus,
                    textStyle: primaryTextStyle(),
                    autoFillHints: [AutofillHints.newPassword],
                  ),
                  16.height,
                  AppTextField(
                    controller: confNewPassCont,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: inputDecoration(context, label: '${language.lblConfirmPassword}'),
                    focus: confPassFocus,
                    validator: (String? value) {
                      if (value!.isEmpty) return errorThisFieldRequired;
                      if (value.length < passwordLengthGlobal) return '${language.lblPasswordLengthShouldBeMoreThanSix}';
                      if (value.trim() != newPassCont.text.trim()) return '${language.lblBothPasswordShouldBeMatched}';
                      if (value.trim() == oldPassCont.text.trim()) return '${language.lblOldPasswordShouldNotBeSameAsNewPassword}';

                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (s) {
                      submit();
                    },
                    textStyle: primaryTextStyle(),
                    autoFillHints: [AutofillHints.newPassword],
                  ),
                  30.height,
                  RoundedLoadingButton(
                    successIcon: Icons.done,
                    failedIcon: Icons.close,
                    borderRadius: defaultRadius,
                    child: Text(language.lblSave, style: boldTextStyle(color: Colors.white)),
                    controller: _btnController,
                    animateOnTap: false,
                    resetAfterDuration: true,
                    width: context.width(),
                    color: primaryColor,
                    onPressed: () {
                      hideKeyboard(context);
                      submit();
                    },
                  ),
                ],
              ),
            ),
          ).visible(!appStore.isLoading, defaultWidget: AppLoader().center()),
        ),
      ),
    );
  }
}

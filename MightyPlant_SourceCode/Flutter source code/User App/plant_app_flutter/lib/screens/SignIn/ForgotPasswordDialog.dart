import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/widgets/rounded_loading_button.dart';

class ForgotPasswordDialog extends StatefulWidget {
  static String tag = '/ForgotPasswordScreen';

  @override
  ForgotPasswordDialogState createState() => ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  TextEditingController forgotEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _btnController.start();
      Map req = {
        'email': forgotEmailController.text.trim(),
      };

      await authApi.forgotPassword(req).then((value) {
        _btnController.success();
        toast(value.message);
        finish(context);
      }).catchError((error) {
        toast(error.toString());
        _btnController.error();
      });
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
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(language.forget_Password, style: boldTextStyle(size: 20)),
            Text(language.reset_password_link_will_be_sent_to_the_above_entered_email_address, style: secondaryTextStyle()),
            16.height,
            AppTextField(
              controller: forgotEmailController,
              textFieldType: TextFieldType.EMAIL,
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecoration(context, label: language.email),
              errorInvalidEmail: language.enter_Valid_Email,
              errorThisFieldRequired: errorThisFieldRequired,
            ),
            16.height,
            RoundedLoadingButton(
              successIcon: Icons.done,
              failedIcon: Icons.close,
              borderRadius: defaultRadius,
              child: Text(language.reset_Password, style: boldTextStyle(color: Colors.white)),
              controller: _btnController,
              animateOnTap: false,
              resetDuration: 3.seconds,
              resetAfterDuration: true,
              width: context.width() * 0.8,
              color: context.primaryColor,
              onPressed: () {
                hideKeyboard(context);
                submit();
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/CustomerResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class AddCustomerDialog extends StatefulWidget {
  static String tag = '/EditCustomerScreen';
  CustomerResponse? customerData;
  final Function? onUpdate;

  AddCustomerDialog({this.customerData, this.onUpdate});

  @override
  AddCustomerDialogState createState() => AddCustomerDialogState();
}

class AddCustomerDialogState extends State<AddCustomerDialog> {
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  String? roleCont = '';
  bool isUpdate = false;

  List<String> roleList = [
    'Disable Vendor',
    'Store Vendor',
    'Vendor',
    'Shop Manager',
    'Customer',
    'Subscriber',
    'Contributor',
    'Author',
    'Editor',
    'Administrator',
    '--No role for this site--',
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.customerData!=null;
    if(isUpdate){
      fNameCont.text = widget.customerData!.firstName.validate();
      lNameCont.text = widget.customerData!.lastName.validate();
      emailCont.text = widget.customerData!.email.validate();
      usernameCont.text = widget.customerData!.username.validate();
      roleCont = widget.customerData!.role.validate();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> addCustomers() async {
    appStore.setLoading(true);
    var req ;
    if(!isUpdate) {
      req = {
        'first_name': fNameCont.text.validate(),
        'last_name': lNameCont.text.validate(),
        'email': emailCont.text.validate(),
        'username': usernameCont.text.validate(),
        'password': passwordCont.text.validate(),
        'role': roleCont.validate(),
      };
      await addCustomer(req).then((value) {
        toast('lbl_add_successfully'.translate);
        widget.onUpdate!.call();
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() {
        appStore.setLoading(false);
      });
    }else{
      req = {
        'first_name': fNameCont.text.validate(),
        'last_name': lNameCont.text.validate(),
        'email': emailCont.text.validate(),
        'role': roleCont.validate(),
      };
      await editCustomer(customerId: widget.customerData!.id.validate(), request: req).then((res) {
        widget.customerData!.firstName = fNameCont.text.validate();
        widget.customerData!.lastName = lNameCont.text.validate();
        widget.customerData!.email = emailCont.text.validate();
        widget.customerData!.role = roleCont.validate();
        toast('lbl_update_successfully'.translate);
        widget.onUpdate!.call();
      }).catchError((error) {
        log(error.toString());
        toast(error.toString().validate());
      }).whenComplete(() {
        appStore.setLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${!isUpdate ? 'lbl_Add_Customer'.translate : 'lbl_Update_Customer'.translate}',style: boldTextStyle(size: 20)),
              CloseButton(color: Colors.grey),
            ],
          ),
          16.height,
          AppTextField(
            controller: fNameCont,
            textFieldType: TextFieldType.NAME,
            decoration: commonInputDecoration(context, label: 'hint_fName'.translate),
          ),
          16.height,
          AppTextField(
            controller: lNameCont,
            textFieldType: TextFieldType.NAME,
            decoration: commonInputDecoration(context, label: 'hint_lName'.translate),
          ),
          16.height,
          AppTextField(
            controller: emailCont,
            textFieldType: TextFieldType.EMAIL,
            decoration: commonInputDecoration(context, label: 'hint_enter_your_email_id'.translate),
            errorInvalidEmail: 'invalid_email'.translate,
          ),
          16.height.visible(!isUpdate),
          AppTextField(
            controller: usernameCont,
            textFieldType: TextFieldType.NAME,
            decoration: commonInputDecoration(context, label: 'hintText_username'.translate),
            errorThisFieldRequired: 'This field required',
          ).visible(!isUpdate),
          16.height.visible(!isUpdate),
          AppTextField(
            controller: passwordCont,
            textFieldType: TextFieldType.PASSWORD,
            decoration: commonInputDecoration(context, label: 'hintText_password'.translate),
            errorMinimumPasswordLength: 'password_validation'.translate,
          ).visible(!isUpdate),
          24.height,
          AppButton(
            text: !isUpdate ? 'lbl_Add'.translate : 'lbl_Update'.translate,
            textColor: white,
            color: primaryColor,
            width: context.width(),
            onTap: () {
              hideKeyboard(context);
              finish(context);
              addCustomers();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/AttributeModel.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:nb_utils/nb_utils.dart';

class AddTermDialog extends StatefulWidget {
  static String tag = '/AddTermsScreen';

  final int? attributeId;
  final Function? onUpdate;
  final AttributeModel? termsData;
  final bool isUpdate;

  AddTermDialog({this.attributeId, this.onUpdate, this.termsData, this.isUpdate = false});

  @override
  AddTermDialogState createState() => AddTermDialogState();
}

class AddTermDialogState extends State<AddTermDialog> {
  TextEditingController attributeNameCont = TextEditingController();
  TextEditingController slugCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode slugFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.isUpdate) {
      attributeNameCont.text = widget.termsData!.name!;
      slugCont.text = widget.termsData!.slug!;
      descriptionCont.text = widget.termsData!.description ?? "";
    }
  }

  Future<void> addTerms() async {
    var request = widget.isUpdate
        ? {'name': attributeNameCont.text}
        : {
            "name": attributeNameCont.text,
            "slug": slugCont.text,
            "description": descriptionCont.text,
          };
    appStore.setLoading(true);

    if (widget.isUpdate) {
      await editTerms(request: request, attributeTermId: widget.termsData!.id, attributeId: widget.attributeId).then((res) {
        widget.termsData!.name = attributeNameCont.text.validate();

        toast('lbl_update_successfully'.translate);
        widget.onUpdate!.call();
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setLoading(false));
    } else {
      addTerm(req: request, attributeId: widget.attributeId).then((res) {
        toast('lbl_add_successfully'.translate);
        widget.onUpdate!.call();
      }).catchError((e) {
        toast("${e['message']}");
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
              Text(widget.isUpdate ? "lbl_Update_Attribute".translate : "lbl_Add_Attribute".translate, style: boldTextStyle(size: 20)),
              CloseButton(color: Colors.grey),
            ],
          ),
          16.height,
          AppTextField(
            controller: attributeNameCont,
            textFieldType: TextFieldType.NAME,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: "lbl_Product_Attribute".translate),
            focus: nameFocus,
            nextFocus: slugFocus,
          ),
          16.height,
          AppTextField(
            controller: slugCont,
            focus: slugFocus,
            nextFocus: descriptionFocus,
            textFieldType: TextFieldType.NAME,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: 'lbl_Slug'.translate),
          ).visible(!widget.isUpdate),
          16.height.visible(!widget.isUpdate),
          AppTextField(
            controller: descriptionCont,
            focus: descriptionFocus,
            textFieldType: TextFieldType.NAME,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: "lbl_Description".translate),
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 3,
          ).visible(!widget.isUpdate),
          16.height.visible(!widget.isUpdate),
          AppButton(
            text: widget.isUpdate ? "lbl_Update".translate : "lbl_Add".translate,
            color: primaryColor,
            textColor: white,
            width: context.width(),
            onTap: () {
              hideKeyboard(context);
              finish(context);
              addTerms();
            },
          ),
        ],
      ),
    );
  }
}

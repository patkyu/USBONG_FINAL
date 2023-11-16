import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/models/AttributeModel.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class AddAttributeDialog extends StatefulWidget {
  static String tag = '/AddAttributeScreen';
  final AttributeModel? attributeData;
  final int? attributeId;
  final Function? onUpdate;
  final bool? isUpdate;

  AddAttributeDialog({this.attributeData, this.attributeId, this.onUpdate, this.isUpdate});

  @override
  AddAttributeDialogState createState() => AddAttributeDialogState();
}

class AddAttributeDialogState extends State<AddAttributeDialog> {
  TextEditingController attributeNameCont = TextEditingController();
  TextEditingController slugCont = TextEditingController();

  FocusNode attributeFocus = FocusNode();
  FocusNode slugFocus = FocusNode();
  bool mArchives = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.isUpdate!) {
      attributeNameCont.text = widget.attributeData!.name.toString();
      slugCont.text = widget.attributeData!.slug.toString();
      mArchives = widget.attributeData!.hasArchives!;
    }
  }

  Future<void> addAttributes() async {
    var request = {
      "name": attributeNameCont.text,
      "slug": slugCont.text,
      "type": "select",
      "order_by": "menu_order",
      "has_archives": mArchives,
    };
    appStore.setLoading(true);

    if (widget.isUpdate!) {
      await editAttribute(request: request, attributeId: widget.attributeId).then((res) {
        toast('lbl_update_Attribute_successfully'.translate);
        widget.onUpdate!.call();
      }).catchError((e) {
        toast("${e['message']}");
      }).whenComplete(() => appStore.setLoading(false));
    } else {
      await addAttribute(req: request).then((res) {
        toast('lbl_Add_Attribute_successfully'.translate);
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.isUpdate! ? "lbl_Update_Attribute".translate : 'lbl_Add_Attribute'.translate}', style: boldTextStyle(size: 20)),
              CloseButton(color: Colors.grey),
            ],
          ),
          16.height,
          AppTextField(
            controller: attributeNameCont,
            textFieldType: TextFieldType.NAME,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: 'lbl_Product_Attribute'.translate),
            focus: attributeFocus,
            nextFocus: slugFocus,
          ),
          16.height,
          AppTextField(
            controller: slugCont,
            focus: slugFocus,
            textFieldType: TextFieldType.NAME,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: 'lbl_Slug'.translate),
          ),
          8.height,
          Row(
            children: [
              CustomTheme(
                child: Checkbox(
                  focusColor: primaryColor,
                  activeColor: primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: mArchives,
                  onChanged: (bool? value) async {
                    mArchives = !mArchives;
                    setState(() {});
                  },
                ),
              ),
              Text("lbl_eneble".translate, style: secondaryTextStyle()).onTap(() async {
                mArchives = !mArchives;
                setState(() {});
              }),
            ],
          ),
          16.height,
          AppButton(
            text: widget.isUpdate == true ? "lbl_Update_Attribute".translate : 'lbl_Add_Attribute'.translate,
            color: primaryColor,
            textColor: white,
            width: context.width(),
            onTap: () {
              hideKeyboard(context);
              finish(context);
              addAttributes();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/component/AddAttributeDialog.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/AttributeModel.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/screens/ProductTermScreen.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductAttributesWidget extends StatefulWidget {
  static String tag = '/ProductAttributesItemWidget';

  final AttributeModel? data;
  final Function(int?)? onDelete;
  final Function? onUpdate;

  ProductAttributesWidget({this.data, this.onDelete, this.onUpdate});

  @override
  ProductAttributesWidgetState createState() => ProductAttributesWidgetState();
}

class ProductAttributesWidgetState extends State<ProductAttributesWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  void deleteAttributes() {
    hideKeyboard(context);

    appStore.setLoading(true);

    deleteAttributesTerm(attributeId: widget.data!.id, isAttribute: true).then((res) {
      toast('successfully_deleted'.translate);

      widget.onDelete?.call(res.id);
    }).catchError((e) {
      toast(e.toString());
      log(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.data!.name!, style: boldTextStyle(size: 18)).expand(),
        Row(
          children: [
            commonEditButtonComponent(
                color: primaryColor,
                icon: Icons.edit,
                onCall: () async {
                  if (isVendor) {
                    toast("admin_toast".translate);
                    return;
                  }
                  showInDialog(
                    context,
                    backgroundColor: context.cardColor,
                    builder: (context) {
                      return AddAttributeDialog(
                          attributeData: widget.data,
                          attributeId: widget.data!.id,
                          isUpdate: true,
                          onUpdate: () {
                            widget.onUpdate?.call();
                          });
                    },
                  );
                }).paddingOnly(right: 16),
            commonEditButtonComponent(
                color: redColor,
                icon: Icons.delete,
                onCall: () async {
                  if (isVendor) {
                    toast("admin_toast".translate);
                    return;
                  }
                  showConfirmDialogCustom(
                    context,
                    title: "lbl_confirmation_Product_Attributes".translate,
                    onAccept: (_) {
                      deleteAttributes();
                    },
                    dialogType: DialogType.DELETE,
                    positiveText: 'lbl_Delete'.translate,
                    negativeText: 'lbl_cancel'.translate,
                  );
                }),
          ],
        ),  
      ],
    ).paddingAll(16).onTap(() {
      ProductTermScreen(attributeId: widget.data!.id.validate(), attributeName: widget.data!.name.validate()).launch(context);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/component/AddTermsDialog.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/AttributeModel.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ProductTermWidget extends StatefulWidget {
  static String tag = '/ProductAttributeTermWidget';

  AttributeModel? data;
  final int? attributeId;
  final Function(int?)? onDelete;
  final Function? onUpdate;

  ProductTermWidget({this.data, this.attributeId, this.onDelete, this.onUpdate});

  @override
  _ProductTermWidgetState createState() => _ProductTermWidgetState();
}

class _ProductTermWidgetState extends State<ProductTermWidget> {

  void deleteAttributesTerms() {
    hideKeyboard(context);

    appStore.setLoading(true);

    deleteAttributesTerm(attributeId: widget.attributeId, attributeTermId: widget.data!.id).then((res) {
      toast('successfully_deleted'.translate);

      widget.onDelete?.call(res.id);
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() {
      LiveStream().emit(REMOVE_ATTRIBUTE_TERMS, true);
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.data!.name!, style: boldTextStyle()).expand(),
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
                showInDialog(context, builder: (context) {
                  return AddTermDialog(
                      termsData: widget.data,
                      attributeId: widget.attributeId,
                      isUpdate: true,
                      onUpdate: () {
                        setState(() {});
                        widget.onUpdate?.call();
                      });
                }, backgroundColor: context.cardColor);
              },
            ).paddingOnly(right: 16),
            commonEditButtonComponent(
              color: redColor,
              icon: Icons.delete,
              onCall: () async {
                if (isVendor) {
                  toast("admin_toast".translate);
                  return;
                }
                showConfirmDialogCustom(context, title: "lbl_confirmation_Product_Attributes".translate, onAccept: (_) {
                  deleteAttributesTerms();
                }, dialogType: DialogType.DELETE, positiveText: 'lbl_Delete'.translate, negativeText: 'lbl_cancel'.translate);
              },
            ),
          ],
        ),
      ],
    ).paddingOnly(top: 16,bottom: 16);
  }
}

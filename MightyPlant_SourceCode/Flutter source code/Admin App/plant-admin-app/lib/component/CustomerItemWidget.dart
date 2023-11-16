import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/CustomerResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/component/AddCustomerDialog.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerItemWidget extends StatefulWidget {
  static String tag = '/CustomerItemWidget';

  final CustomerResponse? data;
  final Function? onUpdate;
  final Function(int?)? onDelete;

  CustomerItemWidget({this.data, this.onUpdate, this.onDelete});

  @override
  CustomerItemWidgetState createState() => CustomerItemWidgetState();
}

class CustomerItemWidgetState extends State<CustomerItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

  Future<void> deleteCustomers() async {
    appStore.setLoading(true);

    await deleteCustomer(customerId: widget.data!.id.validate()).then((res) {
      widget.onDelete?.call(res.id);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      setState(() {});
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cachedImage(widget.data!.avatarUrl, height: 65, width: 65).cornerRadiusWithClipRRect(33),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${widget.data?.firstName.validate()} ${widget.data?.lastName.validate()}', style: boldTextStyle()).expand(),
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
                          return AddCustomerDialog(
                              customerData: widget.data,
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
                        title: "lbl_confirmation_Remove_Customers".translate,
                        onAccept: (_) {
                          deleteCustomers();
                        },
                        dialogType: DialogType.DELETE,
                        positiveText: 'lbl_Delete'.translate,
                        negativeText: 'lbl_cancel'.translate,
                      );
                    }),
              ],
            ),
            widget.data!.username!.isNotEmpty
                ? Text(widget.data!.username.validate(), style: widget.data!.firstName!.isNotEmpty && widget.data!.lastName!.isNotEmpty ? primaryTextStyle() : boldTextStyle())
                : SizedBox(),
            4.height,
            widget.data!.email!.isNotEmpty ? Text(widget.data!.email.validate(), style: secondaryTextStyle()) : SizedBox(),
          ],
        ).expand(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/CategoryResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/screens/SubCategoriesListScreen.dart';
import 'package:mighty_plant_admin/component/AddCategoryDialog.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryItemWidget extends StatefulWidget {
  final List<CategoryResponse>? categoryList;
  final CategoryResponse? data;
  final int? index;
  final Function(int)? onDelete;
  final Function()? onUpdate;

  CategoryItemWidget({this.categoryList, this.data, this.index, this.onDelete, this.onUpdate});

  @override
  _CategoryItemWidgetState createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  Future<void> deleteCategories() async {
    hideKeyboard(context);

    appStore.setLoading(true);

    deleteCategory(categoryId: widget.data!.id).then((res) {
      toast('successfully_deleted'.translate);
      widget.onDelete!.call(widget.data!.id!);
    }).catchError((error) {
      toast(error.toString().validate());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Stack(
        children: [
          cachedImage(widget.data!.image != null ? widget.data!.image!.src.validate() : ic_placeHolder, height: 150, width: context.width(), fit: BoxFit.cover)
              .cornerRadiusWithClipRRect(defaultRadius),
          Container(color: Colors.black.withOpacity(0.5), height: 150, width: context.width()).cornerRadiusWithClipRRect(defaultRadius),
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Text(parseHtmlString(widget.data!.name.validate()), style: primaryTextStyle(color: Colors.white), maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: PopupMenuButton<int>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) {
                return <PopupMenuEntry<int>>[
                  PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20, color: Colors.green),
                          8.width,
                          Text("lbl_Edit".translate),
                        ],
                      ),
                      value: 0,
                      textStyle: primaryTextStyle(color: Colors.green)),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        8.width,
                        Text("lbl_Delete".translate),
                      ],
                    ),
                    value: 1,
                    textStyle: primaryTextStyle(color: Colors.red),
                  ),
                ];
              },
              onSelected: (value) async {
                if (isVendor) {
                  toast("admin_toast".translate);
                  return;
                }
                if (value == 0) {
                  showInDialog(
                    context,
                    backgroundColor: context.cardColor,
                    builder: (p0) {
                      return AddCategoryDialog(
                          categoryData: widget.data,
                          onUpdate: () {
                            widget.onUpdate!.call();
                          });
                    },
                  );
                } else if (value == 1) {
                  showConfirmDialogCustom(
                    context,
                    primaryColor: primaryColor,
                    title: "lbl_confirmation_Delete_Category".translate,
                    onAccept: (_) {
                      deleteCategories();
                    },
                    dialogType: DialogType.DELETE,
                    positiveText: 'lbl_Delete'.translate,
                    negativeText: 'lbl_cancel'.translate,
                  );
                }
              },
            ),
          ),
        ],
      ).onTap(() {
        if (isVendor) {
          toast("admin_toast".translate);
          return;
        }
        SubCategoriesListScreen(
            categoryId: widget.data!.id.validate(),
            categoryName: widget.data!.name.validate(),
            onUpdate: () {
              widget.onUpdate!.call();
            }).launch(context);
      }),
    ).cornerRadiusWithClipRRect(defaultRadius);
  }
}

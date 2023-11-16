import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/CategoryResponse.dart';
import 'package:mighty_plant_admin/models/ProductDetailResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/MediaImageList.dart';

// ignore: must_be_immutable
class AddCategoryDialog extends StatefulWidget {
  static String tag = '/EditCategoryScreen';

  CategoryResponse? categoryData;
  bool isEdit;
  Function? onUpdate;

  AddCategoryDialog({this.categoryData, this.isEdit = true, this.onUpdate});

  @override
  AddCategoryDialogState createState() => AddCategoryDialogState();
}

class AddCategoryDialogState extends State<AddCategoryDialog> {
  TextEditingController categoryNameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  var parentCategoryCont = TextEditingController();

  FocusNode categoryFocus = FocusNode();
  FocusNode parentCategoryFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode displayTypeFocus = FocusNode();

  Images1? image;
  Map<String, dynamic> selectImg = Map<String, dynamic>();

  List<CategoryResponse> categoryList = [];

  CategoryResponse? pCategoryCont;

  int? parent = 0;

  //String displayTypeCont;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> getAllCategoryList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });

    await getAllCategory().then((res) async {
      categoryList.clear();
      categoryList.addAll(res);
      categoryList.forEach((element) {
        print(widget.categoryData!.parent.toString());
        if (element.id == widget.categoryData!.parent) {
          pCategoryCont = element;
          parent = element.id;
        }
      });
      setState(() {});
    }).catchError((e) {
      log(e.toString());
      toast(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> init() async {
    getAllCategoryList();
    if (widget.isEdit) {
      categoryNameCont.text = parseHtmlString(widget.categoryData!.name.validate());
      descriptionCont.text = parseHtmlString(widget.categoryData!.description.validate());
      parent = widget.categoryData!.parent.validate();
    }
  }

  Future<void> updateCategories() async {
    var request = {
      'name': categoryNameCont.text,
      'parent': parent,
      'description': descriptionCont.text,
      'image': selectImg.isNotEmpty ? selectImg : widget.categoryData!.image,
    };

    appStore.setLoading(true);

    updateCategory(widget.categoryData!.id, request).then((res) {
      toast('lbl_update_successfully'.translate);
      widget.categoryData!.name = request['name'] as String?;
      widget.categoryData!.description = request['description'] as String?;
      widget.onUpdate!.call();
    }).catchError((error) {
      log(error.toString());
      toast(error.toString().validate());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  Future<void> addCategories() async {
    var request = {
      'name': categoryNameCont.text,
      'parent': parent,
      'description': descriptionCont.text,
      'image': selectImg,
    };

    appStore.setLoading(true);

    addCategory(request).then((res) {
      toast('lbl_add_category_successfully'.translate);
      categoryList.add(res);
      widget.onUpdate!.call();
    }).catchError((error) {
      toast(error.toString().validate());
    }).whenComplete(() {
      LiveStream().emit(ADD_CATEGORY, true);
      appStore.setLoading(false);
    });
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
              Text('${widget.isEdit ? "lbl_Update_Category".translate : "lbl_Add_Category".translate}', style: boldTextStyle(size: 20)),
              CloseButton(color: Colors.grey),
            ],
          ),
          16.height,
          AppTextField(
            controller: categoryNameCont,
            textFieldType: TextFieldType.NAME,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: "lbl_Category_Name".translate),
          ),
          16.height,
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonFormField<CategoryResponse>(
              dropdownColor: appStore.scaffoldBackground,
              decoration: InputDecoration.collapsed(hintText: null),
              hint: Text("lbl_Select_Parent_Category".translate, style: secondaryTextStyle()),
              isExpanded: true,
              value: pCategoryCont,
              focusNode: parentCategoryFocus,
              items: categoryList.map((CategoryResponse e) {
                return DropdownMenuItem<CategoryResponse>(
                  value: e,
                  child: parent == e.parent ? Text(parseHtmlString(e.name.validate()), style: primaryTextStyle()) : Text(parseHtmlString(e.name.validate()), style: primaryTextStyle()),
                );
              }).toList(),
              onChanged: (CategoryResponse? value) async {
                pCategoryCont = value;
                categoryList.forEach((element) {
                  if (element.name == value!.name) {
                    log('Parent :- ${element.name.validate() + element.id.toString()}');
                    parent = element.id;
                  }
                });
                setState(() {});
              },
            ),
          ),
          16.height,
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: Colors.grey.withOpacity(0.1)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('lbl_product_image'.translate, style: primaryTextStyle()),
                    Icon(Icons.camera_alt).onTap(() async {
                      image = await MediaImageList(isSingleSelection: true).launch(context);
                      selectImg = image!.toJson();
                      setState(() {});
                    }),
                  ],
                ),
                cachedImage(
                  image != null ? image!.src : (widget.categoryData!.image != null ? widget.categoryData!.image!.src.validate() : ""),
                  width: context.width(),
                  height: 100,
                  fit: BoxFit.contain,
                ).cornerRadiusWithClipRRect(6).paddingOnly(top: 16, bottom: 16),
              ],
            ),
          ),
          16.height,
          AppTextField(
            controller: descriptionCont,
            focus: descriptionFocus,
            textFieldType: TextFieldType.NAME,
            cursorColor: appStore.isDarkModeOn ? white : black,
            decoration: commonInputDecoration(context, label: "lbl_Description".translate),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
          16.height,
          AppButton(
            text: widget.isEdit ? "lbl_Update".translate : "lbl_Add".translate,
            color: primaryColor,
            textColor: white,
            width: context.width(),
            onTap: () {
              hideKeyboard(context);
              finish(context);
              if (widget.isEdit) {
                updateCategories();
              } else {
                addCategories();
              }
            },
          ),
          16.height,
        ],
      ),
    );
  }
}

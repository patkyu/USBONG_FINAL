import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/component/AddAttributeDialog.dart';
import 'package:mighty_plant_admin/component/ProductAttributesWidget.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/AttributeModel.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductAttributeScreen extends StatefulWidget {
  static String tag = '/ProductAttributeScreen';

  @override
  ProductAttributeScreenState createState() => ProductAttributeScreenState();
}

class ProductAttributeScreenState extends State<ProductAttributeScreen> {
  int? selectedIndex;
  int page = 1;
  bool mIsLastPage = false;
  List<AttributeModel> attributeList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getAllAttributesList();

    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;
          getAllAttributesList();
          setState(() {});
        }
      }
    });
  }

  Future<void> getAllAttributesList() async {
    appStore.setLoading(true);

    await getAllProductAttributes(page: page).then((res) async {
      if (page == 1) attributeList.clear();

      attributeList.addAll(res);
      mIsLastPage = res.length != perPage;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
      toast(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget("lbl_Product_Attribute".translate, showBack: true, color: primaryColor, textColor: white),
        body: Stack(
          children: [
            if (attributeList.isNotEmpty)
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 0,
                ),
                controller: scrollController,
                itemCount: attributeList.length,
                itemBuilder: (_, i) {
                  AttributeModel data = attributeList[i];

                  return ProductAttributesWidget(
                    data: data,
                    onDelete: (id) {
                      attributeList.removeWhere((element) => element.id == id);

                      setState(() {});
                    },
                    onUpdate: () async {
                      await getAllAttributesList();
                      attributeList.sort((a, b) => a.name!.compareTo(b.name!));

                      setState(() {});
                    },
                  );
                },
              ),
            NoDataFound(
              title: 'no_attribute_available'.translate,
              onPressed: () {
                finish(context);
              },
            ).visible(!appStore.isLoading && attributeList.isEmpty),
            Observer(builder: (_) => loading().visible(appStore.isLoading))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: '1',
          elevation: 5,
          backgroundColor: primaryColor,
          onPressed: () async {
            if (isVendor) {
              toast("admin_toast".translate);
              return;
            }
            showInDialog(
              context,
              backgroundColor: context.cardColor,
              builder: (context) {
                return AddAttributeDialog(
                  isUpdate: false,
                  onUpdate: () async {
                    await getAllAttributesList();
                    attributeList.sort((a, b) => a.name!.compareTo(b.name!));
                    setState(() {});
                  },
                );
              },
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mighty_plant_admin/component/CategoryItemWidget.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/CategoryResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/component/AddCategoryDialog.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryScreen extends StatefulWidget {
  static String tag = '/CategoryScreen';

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  List<CategoryResponse> categoryList = [];
  CategoryResponse data = CategoryResponse();
  ScrollController scrollController = ScrollController();

  int page = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getAllCategoryList();

    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;

          getAllCategoryList();
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getAllCategoryList() async {
    appStore.setLoading(true);

    await getAllCategory(page: page).then((res) async {
      if (page == 1) categoryList.clear();

      categoryList.addAll(res);
      mIsLastPage = res.length != perPage;

      setState(() {});
    }).catchError((e) {
      log(e.toString());
      toast(e.toString());
    }).whenComplete(() =>  appStore.setLoading(false));
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(ADD_CATEGORY);
    scrollController.dispose();
  }

  @override
  void didUpdateWidget(covariant CategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        appBar: appBarWidget("lbl_Category".translate, showBack: true, color: primaryColor, textColor: white),
        body: Stack(
          children: [
            if (categoryList.isNotEmpty)
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    StaggeredGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 0,
                      children: List.generate(
                        categoryList.length,
                            (index) {
                              CategoryResponse data = categoryList[index];
                              return CategoryItemWidget(
                                data: data,
                                index: index,
                                categoryList: categoryList,
                                onDelete: (int id) {
                                  categoryList.removeWhere((element) => element.id == id);
                                  setState(() {});
                                },
                                onUpdate: () {
                                  page = 1;
                                  categoryList.clear();
                                  getAllCategoryList();
                                },
                              );
                        },
                      ),
                    ).paddingAll(16),
                    60.height,
                  ],
                ),
              ),
            NoDataFound(
              title: 'no_attribute_available'.translate,
              onPressed: () {
                init();
              },
            ).visible(!appStore.isLoading && categoryList.isEmpty),
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
              builder: (p0) {
                return AddCategoryDialog(
                    isEdit: false,
                    categoryData: data,
                    onUpdate: () {
                      page = 1;
                      categoryList.clear();
                      getAllCategoryList();
                    });
              },
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

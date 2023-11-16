import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mighty_plant_admin/component/CategoryItemWidget.dart';
import 'package:mighty_plant_admin/models/CategoryResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SubCategoriesListScreen extends StatefulWidget {
  static String tag = '/SubCategoriesListScreen';

  final int? categoryId;
  final String? categoryName;
  final Function()? onUpdate;

  SubCategoriesListScreen({this.categoryId,this.categoryName,this.onUpdate});

  @override
  SubCategoriesListScreenState createState() => SubCategoriesListScreenState();
}

class SubCategoriesListScreenState extends State<SubCategoriesListScreen> {
  List<CategoryResponse>? categoryList = [];
  CategoryResponse data = CategoryResponse();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(widget.categoryName!, showBack: true, color: primaryColor, textColor: white),
        body: Stack(
          children: [
            FutureBuilder<List<CategoryResponse>>(
                future: getSubCategories(widget.categoryId).then((value) => value),
                builder: (_, snap) {
                  if (snap.hasData) {
                    if (snap.data!.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            StaggeredGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 0,
                              children: List.generate(
                                snap.data!.length,
                                    (index) {
                                   data = snap.data![index];
                                  return CategoryItemWidget(
                                    data: data,
                                    index: index,
                                    categoryList: snap.data,
                                    onDelete: (int id) {
                                      setState(() {});
                                      widget.onUpdate!.call();
                                    },
                                    onUpdate: () {
                                      setState(() { });
                                      widget.onUpdate!.call();
                                    },
                                  );
                                },
                              ),
                            ),
                            60.height,
                          ],
                        ),
                      );
                    } else {
                      return NoDataFound(
                          title: 'no_sub_category'.translate,
                          onPressed: () {
                            finish(context);
                          });
                    }
                  }
                  return snapWidgetHelper(
                    snap,
                    errorWidget: Container(
                      child: Text(snap.error.toString().validate(), style: primaryTextStyle()).paddingAll(16).center(),
                      height: context.height(),
                      width: context.width(),
                    ),
                  );
                }),
            Observer(builder: (_) => loading().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/component/AddTermsDialog.dart';
import 'package:mighty_plant_admin/component/ProductTermWidget.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/AttributeModel.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductTermScreen extends StatefulWidget {
  static String tag = '/ProductAttributeTermScreen';

  final int attributeId;
  final String? attributeName;

  ProductTermScreen({this.attributeId = 0, this.attributeName});

  @override
  ProductTermScreenState createState() => ProductTermScreenState();
}

class ProductTermScreenState extends State<ProductTermScreen> {
  int page = 1;
  bool mIsLastPage = false;
  List<AttributeModel> attributeTermList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getAllAttributeTermsList();

    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;
          getAllAttributeTermsList();
          setState(() {});
        }
      }
    });
  }

  Future<void> getAllAttributeTermsList() async {
    afterBuildCreated((){appStore.setLoading(true);});

    await getAllAttributesTerms(id: widget.attributeId, page: page).then((res) async {
      if (page == 1) attributeTermList.clear();

      attributeTermList.addAll(res);
      mIsLastPage = res.length != perPage;

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return SafeArea(
        child: Scaffold(
          appBar: appBarWidget("lbl_Attribute_Terms".translate, showBack: true, color: primaryColor, textColor: white),
          body: Stack(
            children: [
              attributeTermList.isNotEmpty
                  ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.attributeName}', style: boldTextStyle(size: 20)).paddingOnly(left: 16, top: 16, right: 16),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(height: 0),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16),
                      controller: scrollController,
                      itemCount: attributeTermList.length,
                      itemBuilder: (_, i) {
                        AttributeModel data = attributeTermList[i];
                        return ProductTermWidget(
                          data: data,
                          attributeId: widget.attributeId,
                          onDelete: (id) {
                            attributeTermList.removeWhere((element) => element.id == id);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
                  : NoDataFound(
                title: 'no_terms_available'.translate,
                onPressed: () {
                  finish(context);
                },
              ).visible(!appStore.isLoading && attributeTermList.isEmpty),
              loading().visible(appStore.isLoading),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: '1',
            elevation: 5,
            backgroundColor: primaryColor,
            onPressed: () {
              if (isVendor) {
                toast("admin_toast".translate);
                return;
              }
              showInDialog(
                context,
                backgroundColor: context.cardColor,
                builder: (context) {
                  return AddTermDialog(
                      attributeId: widget.attributeId,
                      onUpdate: () async {
                        await getAllAttributeTermsList();
                        attributeTermList.sort((a, b) => a.name!.compareTo(b.name!));
                        setState(() {});
                      });
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      );
    },);
  }
}

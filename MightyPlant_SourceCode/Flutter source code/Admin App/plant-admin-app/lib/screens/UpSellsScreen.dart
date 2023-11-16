import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/ProductDetailResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';

class UpSellsScreen extends StatefulWidget {
  final bool? isGroup;
  final List<ProductDetailResponse1>? grpProduct;

  UpSellsScreen({this.isGroup, this.grpProduct});

  @override
  _UpSellsScreenState createState() => _UpSellsScreenState();
}

class _UpSellsScreenState extends State<UpSellsScreen> {
  TextEditingController search = TextEditingController();
  List<ProductDetailResponse1> productModel = [];
  List<ProductDetailResponse1> searchProductModel = [];
  String mErrorMsg = "";

  int page = 1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  init() async {
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    appStore.setLoading(true);
    await getAllProducts(page).then((res) {
      log(res.length);
      productModel.addAll(res);
      searchProductModel.addAll(res);
      appStore.setLoading(false);
      if (res.isEmpty) {
        mErrorMsg = ('no_data_found'.translate);
      } else {
        mErrorMsg = '';
      }
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      mErrorMsg = error.toString();
      setState(() {});
    });
  }

  onSearchTextChanged(String text) async {
    productModel.clear();
    if (text.isEmpty) {
      productModel.addAll(searchProductModel);
      setState(() {});
      return;
    }
    searchProductModel.forEach((product) {
      if (product.name.toLowerCase().contains(text.toLowerCase())) productModel.add(product);
    });

    setState(() {});
  }

  List<ProductDetailResponse1> getData1() {
    List<ProductDetailResponse1> selected = [];

    productModel.forEach((value) {
      if (value.isCheck == true) {
        selected.add(value);
      }
    });
    setState(() {});
    return selected;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.withOpacity(0.2)),
      child: TextField(
        onChanged: onSearchTextChanged,
        autofocus: false,
        onTap: () {},
        textInputAction: TextInputAction.go,
        controller: search,
        style: TextStyle(fontSize: 20),
        decoration: commonInputDecoration(context,prefixIcon: Icon(Icons.search, color: Colors.grey,size: 24),hintText: 'lbl_search'.translate),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        print(getData1().length);
        finish(context, getData1());
        return false;
      },
      child: Scaffold(
        appBar: appBarWidget(
          "",
          titleWidget: Text(widget.isGroup == true ? "lbl_grp_product".translate : 'lbl_upSell_product'.translate, maxLines: 1, style: boldTextStyle(color: white), overflow: TextOverflow.ellipsis),
          elevation: 10,
          color: primaryColor,
          backWidget: IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back, color: white),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  searchBar,
                  ListView.builder(
                    itemCount: productModel.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        activeColor: primaryColor,
                        value: productModel[index].isCheck,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (v) {
                          log(productModel[index].id);
                          productModel[index].isCheck = !productModel[index].isCheck;

                          setState(() {});
                        },
                        title: Text(productModel[index].name, maxLines: 2, overflow: TextOverflow.ellipsis,style: primaryTextStyle()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Observer(builder: (_) => loading().visible(appStore.isLoading)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.check, color: Colors.white),
          onPressed: () {
            print(getData1().length);
            finish(context, getData1());
          },
        ),
      ),
    );
  }
}

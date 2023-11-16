import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AppLoader.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/model/product/ProductResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/dashboard/component/ProductComponent.dart';
import 'package:plant_flutter/utils/common.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController scrollController = ScrollController();

  int page = 1;

  List<ProductData> mainList = [];

  bool isEnabled = false;
  bool isLastPage = false;

  TextEditingController searchCont = TextEditingController();

  String searchText = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isLastPage) {
          page++;
          loadMoreData();
        }
      }
    });
  }

  Future fetchProductData() async {
    await productApi.getSearchFilterProducts(searchText: searchCont.text.trim()).then((value) {
      if (searchCont.text.trim().isNotEmpty) {
        mainList.clear();
        page = 1;
        isLastPage = false;
      }
      if (searchCont.text.trim().isEmpty) {
        mainList.clear();
      }
      mainList.addAll(value.productData!);
      log(mainList.length);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  Future loadMoreData() async {
    appStore.setLoading(true);
    await productApi.getSearchFilterProducts().then((value) {
      appStore.setLoading(false);
      mainList.addAll(value.productData!);

      isLastPage = false;
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
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
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: appBarWidget(language.search_Plants_and_accessories,
          textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppTextField(
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(context, label: language.search_Plants, prefixIcon: Icon(Ionicons.search_outline)),
                  controller: searchCont,
                  onChanged: (v) {
                    appStore.setLoading(true);
                    fetchProductData();
                  },
                ).expand(),
              ],
            ),
            Observer(builder: (context) {
              return Stack(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(
                      mainList.length,
                      (index) => ProductComponent(
                          itemData: ProductListResponse(
                            average_rating: mainList[index].average_rating.validate(),
                            description: mainList[index].description.validate(),
                            featured: mainList[index].featured.validate(),
                            id: mainList[index].id.validate(),
                            images: mainList[index].images.validate(),
                            in_stock: mainList[index].in_stock.validate(),
                            is_added_cart: mainList[index].is_added_cart.validate(),
                            is_added_wishlist: mainList[index].is_added_wishlist.validate(),
                            manage_stock: mainList[index].manage_stock.validate(),
                            name: mainList[index].name.validate(),
                            on_sale: mainList[index].on_sale.validate(),
                            permalink: mainList[index].permalink.validate(),
                            plant_product_type: mainList[index].plant_product_type.validate(),
                            price: mainList[index].price.validate(),
                            rating_count: mainList[index].rating_count.validate(),
                            regular_price: mainList[index].regular_price.validate(),
                            sale_price: mainList[index].sale_price.validate(),
                            short_description: mainList[index].short_description.validate(),
                            status: mainList[index].status.validate(),
                            stock_quantity: mainList[index].stock_quantity.validate(),
                            type: mainList[index].type.validate(),
                          ),
                          index: index),
                    ),
                  ).paddingTop(30).visible(mainList.isNotEmpty),
                  NoDataWidget(title: language.no_Items_you_have_searched).center().visible(!appStore.isLoading && mainList.isEmpty),
                  AppLoader().center().visible(appStore.isLoading)
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

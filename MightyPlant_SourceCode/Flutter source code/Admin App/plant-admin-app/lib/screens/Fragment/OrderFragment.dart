import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/component/OrderCardWidget.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/OrderResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderFragment extends StatefulWidget {
  static String tag = '/OrderFragment';

  @override
  _OrderFragmentState createState() => _OrderFragmentState();
}

class _OrderFragmentState extends State<OrderFragment> {
  bool mIsLastPage = false;
  int page = 1;
  List<OrderResponse> mOrderList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;

          getOrder();
        }
      }
    });
  }

  init() async {
    getOrder();
  }

  Future<void> getOrder() async {
    appStore.setLoading(true);

    await getOrders(page).then((res) {
      if (page == 1) mOrderList.clear();

      mOrderList.addAll(res);
      mIsLastPage = res.length != perPage;

      setState(() {});
    }).catchError((e) {
      log(e.toString());
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        titleWidget: Row(
          children: [
            cachedImage(app_logo, height: 50, width: 50,color: white),
            8.width,
            Text("lbl_orders".translate, style: boldTextStyle(color: white,size: 20)),
          ],
        ),
        elevation: 0,
        color: primaryColor,
        showBack: false,
        center: false,
      ),
      body: Stack(
        children: [
          mOrderList.isNotEmpty
              ? ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(left: 16,right: 16,top: 16),
                  shrinkWrap: true,
                  itemCount: mOrderList.length,
                  itemBuilder: (context, i) {
                    // OrderResponse data = mOrderList[i];
                    log(mOrderList[i].id);
                    return OrderCardWidget(
                      orderResponse:mOrderList[i],
                      onUpdate: () {
                        mOrderList.clear();
                        getOrder();
                      },
                    );
                  })
              : NoDataFound(
                  title: 'lbl_no_data'.translate,
                  onPressed: () {
                    getOrder();
                  },
                ).center().visible(!appStore.isLoading && mOrderList.isEmpty),
          Observer(builder: (_) => loading().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}

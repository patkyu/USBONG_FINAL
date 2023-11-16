import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/dashboard/ListScreen.dart';
import 'package:plant_flutter/utils/colors.dart';

class DefaultDashboardScreen extends StatefulWidget {
  @override
  _DefaultDashboardScreenState createState() => _DefaultDashboardScreenState();
}

class _DefaultDashboardScreenState extends State<DefaultDashboardScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  Future<ListResponse>? mDashboard;

  List<String> nameList = [
    language.lblBestSelling,
    language.lblSaleProduct,
    language.lblFeatured,
    language.lblNewest,
    language.lblHighestRating,
    language.lblDiscount,
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    mDashboard = dashboardApi.getProductList();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ListResponse>(
      future: mDashboard,
      builder: (context, snap) {
        if (snap.hasData) {
          afterBuildCreated(() {
            if (appStore.isLoading) {
              appStore.setLoading(false);
            }
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                isScrollable: true,
                automaticIndicatorColorAdjustment: true,
                indicatorColor: primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.black,
                onTap: (int) {
                  appStore.setCurrentIndex(int);
                },
                unselectedLabelStyle: secondaryTextStyle(),
                dragStartBehavior: DragStartBehavior.start,
                tabs: List.generate(
                  nameList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(nameList[index], style: boldTextStyle()),
                    );
                  },
                ),
              ),
              16.height,
              Observer(
                builder: (_) {
                  return IndexedStack(
                    sizing: StackFit.loose,
                    children: [
                      ListScreen(data: snap.data!.bestSellingProduct!, heroAnimationUniqueValue: "bestSellingProduct", name: nameList[appStore.currentIndex]),
                      ListScreen(data: snap.data!.saleProduct!, heroAnimationUniqueValue: "saleProduct", name: nameList[appStore.currentIndex]),
                      ListScreen(data: snap.data!.featured!, heroAnimationUniqueValue: "featured", name: nameList[appStore.currentIndex]),
                      ListScreen(data: snap.data!.newest!, heroAnimationUniqueValue: "newest", name: nameList[appStore.currentIndex]),
                      ListScreen(data: snap.data!.highestRating!, heroAnimationUniqueValue: "highestRating", name: nameList[appStore.currentIndex]),
                      ListScreen(data: snap.data!.discount!, heroAnimationUniqueValue: "discount", name: nameList[appStore.currentIndex]),
                    ],
                    index: appStore.currentIndex,
                  ).paddingSymmetric(horizontal: 16);
                },
              ),
            ],
          );
        }
        return snapWidgetHelper(snap, loadingWidget: Offstage());
      },
    );
  }
}

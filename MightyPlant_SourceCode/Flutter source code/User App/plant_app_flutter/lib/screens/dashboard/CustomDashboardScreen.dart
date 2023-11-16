import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/dashboard/DashboardResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/screens/dashboard/ListScreen.dart';
import 'package:plant_flutter/utils/colors.dart';

class CustomDashboardScreen extends StatefulWidget {
  @override
  _CustomDashboardScreenState createState() => _CustomDashboardScreenState();
}

class _CustomDashboardScreenState extends State<CustomDashboardScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DashboardResponse>>(
      future: dashboardApi.getCustomDataList(),
      builder: (context, snap) {
        if (snap.hasData) {
          if (_tabController == null) {
            _tabController = TabController(length: snap.data!.length, vsync: this);
            appStore.setCurrentIndex(_tabController!.index);
          } else {
            if (snap.data!.length <= _tabController!.length || snap.data!.length >= _tabController!.length) {
              _tabController = TabController(length: snap.data!.length, vsync: this);
              appStore.setCurrentIndex(_tabController!.index);
            }
            _tabController!.addListener(() {
              appStore.setCurrentIndex(_tabController!.index);
            });
          }
          afterBuildCreated(() {
            if (appStore.isLoading) {
              appStore.setLoading(false);
            }
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                isScrollable: true,
                automaticIndicatorColorAdjustment: true,
                indicatorColor: primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: secondaryTextStyle(),
                physics: BouncingScrollPhysics(),
                dragStartBehavior: DragStartBehavior.start,
                tabs: List.generate(
                  snap.data!.length,
                  (index) {
                    DashboardResponse data = snap.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${data.title}', style: boldTextStyle()),
                    );
                  },
                ),
              ),
              16.height,
              Observer(
                builder: (_) {
                  return IndexedStack(
                    index: appStore.currentIndex,
                    children: List.generate(
                      snap.data!.length,
                      (index) {
                        DashboardResponse data = snap.data![index];
                        return ListScreen(data: data.productData!, heroAnimationUniqueValue: data.title!, name: data.title!, currentIndex: index).paddingSymmetric(horizontal: 16);
                      },
                    ),
                  );
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

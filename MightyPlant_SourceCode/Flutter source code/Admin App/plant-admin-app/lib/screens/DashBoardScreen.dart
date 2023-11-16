import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/screens/Fragment/ProfileFragment.dart';
import 'package:mighty_plant_admin/screens/Fragment/OrderFragment.dart';
import 'package:mighty_plant_admin/screens/VendorDashboardScreen.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Fragment/HomeFragment.dart';
import 'Fragment/ProductFragment.dart';

class DashBoardScreen extends StatefulWidget {
  static String tag = '/DashBoardScreen';

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  List<Widget> pages = [
    HomeFragment(),
    OrderFragment(),
    ProductFragment(),
    ProfileFragment(),
  ];

  List<Widget> vendorPages = [
    VendorDashboardScreen(),
    OrderFragment(),
    ProductFragment(),
    ProfileFragment(),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(primaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => SafeArea(
        child: Scaffold(
          backgroundColor: appStore.scaffoldBackground,
          body: getStringAsync(USER_ROLE) == 'seller'
              ? vendorPages[currentIndex]
              : pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: appStore.appBarColor,
            currentIndex: currentIndex,
            unselectedItemColor: Colors.grey,
            selectedItemColor: primaryColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedLabelStyle: boldTextStyle(),
            type: BottomNavigationBarType.fixed,
            onTap: (v) {
              currentIndex = v;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                tooltip: "lbl_home".translate,
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.featured_play_list_outlined),
                activeIcon: Icon(Icons.featured_play_list),
                tooltip: "lbl_order".translate,
                label: "Order",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                tooltip: "lbl_product".translate,
                label: "Product",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                tooltip: "lbl_profile".translate,
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

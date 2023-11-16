import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/dashboard/BottomNavModel.dart';
import 'package:plant_flutter/screens/cart/CartScreen.dart';
import 'package:plant_flutter/screens/category/CategoryScreen.dart';
import 'package:plant_flutter/screens/dashboard/HomeScreen.dart';
import 'package:plant_flutter/screens/settings/SettingScreen.dart';
import 'package:plant_flutter/screens/wishlist/WishListScreen.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/images.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BottomNavModel> bottomNavList = [];
  List tab = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    bottomNavList.add(
      BottomNavModel(
        name: language.lblDashboard,
        child: HomeScreen(),
        icon: Ionicons.home_outline,
        alternateIcon: Ionicons.home,
      ),
    );
    bottomNavList.add(
      BottomNavModel(
        name: language.category,
        child: Container(),
        icon: Ionicons.list_outline,
        alternateIcon: Ionicons.list,
      ),
    );
    bottomNavList.add(
      BottomNavModel(
        name: language.cart,
        child: Container(),
        icon: Ionicons.cart_outline,
        alternateIcon: Ionicons.cart,
      ),
    );
    bottomNavList.add(
      BottomNavModel(
        name: language.wishList,
        child: Container(),
        icon: Ionicons.bookmark_outline,
        alternateIcon: Ionicons.bookmark,
      ),
    );
    bottomNavList.add(
      BottomNavModel(name: language.lblSetting, child: Container(), icon: Ionicons.md_settings_outline, alternateIcon: Ionicons.settings),
    );
    tab = [
      HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      WishListScreen(),
      SettingScreen(),
    ];
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String mText() {
    if (currentIndex == 0) {
      return language.lblDashboard;
    } else if (currentIndex == 1) {
      return language.category;
    } else if (currentIndex == 2) {
      return language.cart;
    } else if (currentIndex == 3) {
      return language.wishList;
    } else {
      return language.lblSetting;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        showBack: false,
        titleWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            cachedImage(appImages.appLogo, height: 50, width: 50, color: Colors.white),
            Text(mText(), style: boldTextStyle(size: 22, color: Colors.white)),
          ],
        ),
      ),
      body: tab[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        unselectedItemColor: unSelectedColor,
        selectedItemColor: primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: boldTextStyle(),
        type: BottomNavigationBarType.fixed,
        onTap: (v) {
          currentIndex = v;
          setState(() {});
        },
        items: List.generate(
          bottomNavList.length,
          (index) {
            BottomNavModel data = bottomNavList[index];
            return BottomNavigationBarItem(
              icon: Icon(data.icon),
              label: data.name.validate(),
              activeIcon: Icon(data.alternateIcon, color: primaryColor),
            );
          },
        ),
      ),
    );
  }
}

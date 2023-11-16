import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/screens/SignIn/SignInComponent.dart';
import 'package:plant_flutter/screens/SignIn/SignUpComponent.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/colors.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  TabController? _tabBarController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _tabBarController = new TabController(length: 2, vsync: this);

    _tabBarController!.addListener(() {
      currentIndex = _tabBarController!.index;
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        body: SizedBox(
          height: context.height(),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 320,
                  width: context.width(),
                  color: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 88, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language.welcome,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: boldTextStyle(size: 32, color: secondaryColor),
                      ),
                      SizedBox(height: 4, width: 16),
                      Text(
                        language.lblWelComext,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: secondaryTextStyle(color: secondaryColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 170, left: 16, right: 16),
                  height: context.height(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: context.width(),
                        decoration: boxDecorationDefault(
                          color: context.cardColor,
                          borderRadius: radiusOnly(topLeft: 20, topRight: 20),
                          boxShadow: defaultBoxShadow(spreadRadius: 0, blurRadius: 0),
                        ),
                        child: TabBar(
                          controller: _tabBarController,
                          labelStyle: boldTextStyle(),
                          onTap: (value) {
                            currentIndex = value;
                            setState(() {});
                          },
                          labelColor: primaryColor,
                          isScrollable: true,
                          automaticIndicatorColorAdjustment: true,
                          indicatorColor: primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: appStore.isDarkMode ? Colors.white : Colors.black,
                          unselectedLabelStyle: secondaryTextStyle(),
                          physics: BouncingScrollPhysics(),
                          dragStartBehavior: DragStartBehavior.start,
                          tabs: [
                            Tab(text: language.login),
                            Tab(text: language.signUp),
                          ],
                        ).paddingAll(16),
                      ),
                      [
                        SignInComponent(),
                        SignUpComponent(),
                      ][currentIndex]
                          .expand(),
                    ],
                  ),
                ),
                Positioned(
                    top: context.statusBarHeight + 4,
                    left: 4,
                    child: IconButton(
                        onPressed: () {
                          finish(context);
                        },
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  PackageInfo? package;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    package = await PackageInfo.fromPlatform();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: appBarWidget("lbl_about_us".translate, showBack: true, color: primaryColor, textColor: white),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Image.asset(app_logo,height: 120,width: 120,fit: BoxFit.cover),
                FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return Column(
                          children: [
                            Text('${snap.data!.appName.validate()}', style: boldTextStyle(color: primaryColor, size: 18)),
                            Text('Version ${snap.data!.version.validate()}', style: secondaryTextStyle(size: 14))
                          ],
                        );
                      }
                      return SizedBox();
                    }),
                8.height
              ],
            ).center(),
          ),
        ),
      ),
    );
  }
}

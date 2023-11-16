import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/WebViewScreen.dart';
import 'package:plant_flutter/model/dashboard/AppConfigurationResponse.dart';
import 'package:plant_flutter/utils/colors.dart';

class SliderComponent extends StatefulWidget {
  final AppConfigurationResponse? data;

  SliderComponent({this.data});

  @override
  _SliderComponentState createState() => _SliderComponentState();
}

class _SliderComponentState extends State<SliderComponent> {
  int currentIndex = 0;
  PageController bannerPageController = PageController();
  int selectIndex = 0;

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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 200,
          child: PageView(
            controller: bannerPageController,
            onPageChanged: (i) {
              selectIndex = i;
              setState(() {});
            },
            children: widget.data!.banner!.map((i) {
              return GestureDetector(
                onTap: (){
                  push(WebViewScreen(url: i.url.validate(), name:i.desc.validate()));
                },
                child: Container(
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.4)),backgroundColor: context.cardColor),
                  margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Image.network(i.image.validate(), height: 180, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(18),
                ),
              );
            }).toList(),
          ),
        ),
        DotIndicator(
          pageController: bannerPageController,
          pages: widget.data!.banner!,
          indicatorColor: primaryColor,
          unselectedIndicatorColor: grey.withOpacity(0.4),
          currentBoxShape: BoxShape.rectangle,
          boxShape: BoxShape.rectangle,
          borderRadius: radius(2),
          currentBorderRadius: radius(3),
          currentDotSize: 18,
          currentDotWidth: 6,
          dotSize: 6,
        ),
      ],
    );
  }
}

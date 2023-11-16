import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/constants.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String _getName(ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return language.light;
      case ThemeModes.Dark:
        return language.dark;
      case ThemeModes.SystemDefault:
        return language.system_Default;
    }
  }

  Widget _getIcons(BuildContext context, ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return Icon(LineIcons.sun, color: context.iconColor);
      case ThemeModes.Dark:
        return Icon(LineIcons.moon, color: context.iconColor);
      case ThemeModes.SystemDefault:
        return Icon(LineIcons.sun, color: context.iconColor);
    }
  }

  Color? getSelectedColor(BuildContext context, int index) {
    if (currentIndex == index && appStore.isDarkMode) {
      return Colors.white54;
    } else if (currentIndex == index && !appStore.isDarkMode) {
      return unSelectedColor;
    } else {
      return context.cardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblSelectTheme, showBack: true, elevation: 0, textColor: Colors.white,backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(
            ThemeModes.values.length,
            (index) {
              return Container(
                decoration: boxDecorationDefault(color: getSelectedColor(context, index), border: Border.all(color: context.dividerColor)),
                width: context.width() / 2 - 24,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text('${_getName(ThemeModes.values[index])}', style: boldTextStyle()).expand(),
                    _getIcons(context, ThemeModes.values[index]),
                  ],
                ),
              ).onTap(() async {
                currentIndex = index;
                if (index == appThemeMode.themeModeSystem) {
                  appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                  setValue(sharedPref.appThemeMode, language.system_Default);
                } else if (index == appThemeMode.themeModeLight) {
                  appStore.setDarkMode(false);
                  setValue(sharedPref.appThemeMode, language.light_Mode);
                } else if (index == appThemeMode.themeModeDark) {
                  appStore.setDarkMode(true);
                  setValue(sharedPref.appThemeMode, language.dark);
                }
                setValue(THEME_MODE_INDEX, index);
                setState(() {});
              }, borderRadius: radius(defaultRadius));
            },
          ),
        ),
      ),
    );
  }
}

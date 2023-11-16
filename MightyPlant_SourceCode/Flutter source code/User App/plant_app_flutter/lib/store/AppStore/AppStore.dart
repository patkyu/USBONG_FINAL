import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/language/AppLocalizations.dart';
import 'package:plant_flutter/language/BaseLanguage.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/constants.dart';

part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  int? cancelOrderIndex = 0;

  @observable
  String selectedLanguage = "";

  @observable
  int currentIndex = 0;

  @observable
  bool isFirstTime = false;

  @action
  void setLoading(bool val) => isLoading = val;

  @action
  void setFirstTime(bool val) => isFirstTime = val;

  @action
  void setCancelItemIndex(int i) {
    cancelOrderIndex = i;
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = viewLineColor;

      defaultLoaderBgColorGlobal = Colors.black26;
      defaultLoaderAccentColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = primaryColor;
      shadowColorGlobal = Colors.black12;
    }
  }

  @action
  void setCurrentIndex(int val) {
    currentIndex = val;
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultValues.defaultLanguage);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: defaultValues.defaultLanguage)!.languageCode!;

    if (context != null) language = BaseLanguage.of(context)!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }
}

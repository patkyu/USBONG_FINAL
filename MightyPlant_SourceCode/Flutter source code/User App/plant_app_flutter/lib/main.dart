import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:plant_flutter/AppTheme.dart';
import 'package:plant_flutter/language/AppLocalizations.dart';
import 'package:plant_flutter/language/BaseLanguage.dart';
import 'package:plant_flutter/network/DefaultFirebaseConfig.dart';
import 'package:plant_flutter/screens/NoInternetScreen.dart';
import 'package:plant_flutter/screens/SplashScreen.dart';
import 'package:plant_flutter/screens/product/ProductDetailScreen.dart';
import 'package:plant_flutter/store/AppStore/AppStore.dart';
import 'package:plant_flutter/store/CartStore/CartStore.dart';
import 'package:plant_flutter/store/ProductStore/ProductStore.dart';
import 'package:plant_flutter/store/UserStore/UserStore.dart';
import 'package:plant_flutter/store/WishlistStore/WishCartStore.dart';
import 'package:plant_flutter/utils/common.dart';
import 'package:plant_flutter/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'model/wishlist/WishlistResponse.dart';

AppStore appStore = AppStore();
UserStore userStore = UserStore();
WishCartStore wishCartStore = WishCartStore();
CartStore cartStore = CartStore();
ProductStore productStore = ProductStore();

bool isCurrentlyOnNoInternet = false;
late BaseLanguage language;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isAndroid) {
    await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions).catchError((e) {
      return e;
    });
  }
  await OneSignal.shared.setAppId(mOneSignalAppId);
  OneSignal.shared.consentGranted(true);
  OneSignal.shared.promptUserForPushNotificationPermission();
  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    event.complete(event.notification);
  });
  final status = await OneSignal.shared.getDeviceState();
  print(status!.userId);

  MobileAds.instance.initialize();
  await initialize(aLocaleLanguageList: languageList());
  defaultSetting();

  appStore.setLanguage(getStringAsync(sharedPref.selectedLanguage, defaultValue: defaultValues.defaultLanguage));

  userValueSetForLogin();
  if (!isWeb) {
    int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
    if (themeModeIndex == appThemeMode.themeModeLight) {
      appStore.setDarkMode(false);
    } else if (themeModeIndex == appThemeMode.themeModeDark) {
      appStore.setDarkMode(true);
    }
  }
  if (Platform.isAndroid) WebView.platform = AndroidWebView();
  userStore.init();
  if (userStore.isLoggedIn) {
    cartStore.init();
    wishCartStore.clearWishlist();
    wishCartStore.getWishlistItem();
    String wishListString = getStringAsync(WISHLIST_ITEM_LIST);
    if (wishListString.isNotEmpty) {
      wishCartStore.addAllWishListItem(jsonDecode(wishListString).map<WishlistResponse>((e) => WishlistResponse.fromJson(e)).toList());
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult notification) {
      try {
        var notId = notification.notification.additionalData!.containsKey('id') ? notification.notification.additionalData!['id'] : 0;
        push(ProductDetailScreen(id: notId.toString().toInt()));
        log('notId$notId');
      } catch (e) {
        log(e.toString());
      }
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push(NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast('Internet is connected.');
        }
        log('connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: appName,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        scrollBehavior: SBehavior(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [AppLocalizations(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguage.validate(value: sharedPref.selectedLanguage)),
      ),
    );
  }
}

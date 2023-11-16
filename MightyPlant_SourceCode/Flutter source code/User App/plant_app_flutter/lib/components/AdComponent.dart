import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:plant_flutter/utils/constants.dart';

InterstitialAd? interstitialAd;

adShow() async {
  if (interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd();
    },
  );
  ENABLE_ADS ? interstitialAd!.show() : SizedBox();
}

void createInterstitialAd() {
  InterstitialAd.load(
      adUnitId: kReleaseMode ? getInterstitialAdUnitId()! : InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          interstitialAd = null;
        },
      ));
}

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return BANNER_AD_ID_IOS;
  } else if (Platform.isAndroid) {
    return BANNER_AD_ID_ANDROID;
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return INTERSTITIAL_AD_ID_IOS;
  } else if (Platform.isAndroid) {
    return INTERSTITIAL_AD_ID_ANDROID;
  }
  return null;
}

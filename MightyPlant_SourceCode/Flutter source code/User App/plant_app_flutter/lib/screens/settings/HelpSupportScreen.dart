import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/components/AdComponent.dart';
import 'package:plant_flutter/components/WebViewScreen.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/screens/settings/components/SettingItemCard.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AboutUsScreen.dart';

class HelpSupportScreen extends StatefulWidget {
  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.help_and_Support,
          showBack: true, elevation: 0, textColor: Colors.white, backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SettingItemCard(
                  context: context,
                  title: language.privacy_Policy,
                  icon: FontAwesome.wpforms,
                  subTitle: language.check_our_policies,
                  onTap: () {
                    if (userStore.privacy_policy.isNotEmpty) {
                      push(
                        WebViewScreen(url: userStore.privacy_policy, name: language.privacy_Policy.capitalizeFirstLetter()),
                      );
                    } else {
                      toast(language.url_is_Empty);
                    }
                  },
                ),
                SettingItemCard(
                  context: context,
                  title: language.terms_and_Condition,
                  icon: FontAwesome.wpforms,
                  subTitle: language.read_our_terms,
                  onTap: () {
                    if (userStore.term_condition.isNotEmpty) {
                      push(WebViewScreen(url: userStore.term_condition, name: language.read_our_terms));
                    } else {
                      toast(language.url_is_Empty);
                    }
                  },
                ),
                SettingItemCard(
                  context: context,
                  title: language.refund_Policy,
                  icon: Icons.monetization_on_outlined,
                  subTitle: language.check_our_refund_policies,
                  onTap: () {
                    if (userStore.refund_policy.isNotEmpty) {
                      push(WebViewScreen(url: userStore.refund_policy, name: language.refund_Policy));
                    } else {
                      toast(language.url_is_Empty);
                    }
                  },
                ),
                SettingItemCard(
                  context: context,
                  title: language.shipping_Policy,
                  icon: Icons.local_shipping_outlined,
                  subTitle: language.check_our_shipping_policies,
                  onTap: () {
                    if (userStore.shipping_policy.isNotEmpty) {
                      push(
                        WebViewScreen(url: userStore.shipping_policy, name: language.shipping_Policy),
                      );
                    } else {
                      toast(language.url_is_Empty);
                    }
                  },
                ),
                SettingItemCard(
                  context: context,
                  title: language.website,
                  icon: MaterialCommunityIcons.web,
                  subTitle: language.our_Home_Page,
                  onTap: () {
                    if (userStore.website_url.isNotEmpty) {
                      push(
                        WebViewScreen(url: userStore.website_url, name: language.website),
                      );
                    } else {
                      toast(language.url_is_Empty);
                    }
                  },
                ),
                SettingItemCard(
                  context: context,
                  title: language.contact_Us,
                  icon: LineIcons.phone,
                  subTitle: language.check_our_policies,
                  onTap: () {
                    if (userStore.contact.isNotEmpty) {
                      launch(('tel://${userStore.contact.validate()}'));
                    } else {
                      toast(language.url_is_Empty);
                    }
                  },
                ),
                SettingItemCard(
                  context: context,
                  title: language.lblAboutUs,
                  icon: Icons.info_outline,
                  subTitle: language.lblMoreInfo,
                  onTap: () {
                    AboutUsScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: AdWidget(
          ad: BannerAd(
            adUnitId: kReleaseMode ? getBannerAdUnitId()! : BannerAd.testAdUnitId,
            size: AdSize.banner,
            request: AdRequest(),
            listener: BannerAdListener(),
          )..load(),
        ),
      ),
    );
  }
}

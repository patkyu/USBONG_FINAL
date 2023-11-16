import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPaymentScreen extends StatefulWidget {
  static String tag = '/WebViewPaymentScreen';
  final String? checkoutUrl;

  WebViewPaymentScreen({this.checkoutUrl});

  @override
  WebViewPaymentScreenState createState() => WebViewPaymentScreenState();
}

class WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  bool mIsError = false;
  bool mIsLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.webViewPayment,textColor: Colors.white,color: primaryColor,backWidget: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => finish(context))),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.checkoutUrl,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onPageFinished: (String url) {
              if (mIsError) return;
              if (url.contains('checkout/order-received')) {
                mIsLoading = true;
                toast(language.order_placed_successfully);
                Navigator.pop(context, true);
              } else {
                mIsLoading = false;
              }
            },
            onWebResourceError: (s) {
              mIsError = true;
            },
          ),
        ],
      ),
    );
  }
}

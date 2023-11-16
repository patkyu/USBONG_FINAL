import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/ProductDetailResponse.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppColors.dart';

// ignore: must_be_immutable
class PriceWidget extends StatefulWidget {
  static String tag = '/PriceWidget';
  var price;
  double? size = 16.0;
  Color? color;
  var isLineThroughEnabled = false;

  PriceWidget({Key? key, this.price, this.color, this.size, this.isLineThroughEnabled = false}) : super(key: key);

  @override
  PriceWidgetState createState() => PriceWidgetState();
}

class PriceWidgetState extends State<PriceWidget> {
  String currency = '₹';
  Color? primaryColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLineThroughEnabled) {
      return Text('$currency ${widget.price.toString().replaceAll(".00", "")}', style: boldTextStyle(size: widget.size!.toInt(), color: widget.color != null ? widget.color : primaryColor));
    } else {
      return widget.price.toString().isNotEmpty
          ? Text('$currency${widget.price.toString().replaceAll(".00", "")}', style: TextStyle(fontSize: widget.size, color: widget.color ?? textPrimaryColor, decoration: TextDecoration.lineThrough))
          : Text('');
    }
  }
}

// ignore: must_be_immutable
class CustomTheme extends StatelessWidget {
  Widget? child;

  CustomTheme({this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appStore.isDarkModeOn
          ? ThemeData.dark().copyWith(
              backgroundColor: appStore.scaffoldBackground,
            )
          : ThemeData.light(),
      child: child!,
    );
  }
}

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius, Color? color}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center, color: color).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('images/place_holder.png', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

// ignore: must_be_immutable
class NoDataFound extends StatelessWidget {
  String? title;
  Function? onPressed;

  NoDataFound({this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.asset('images/app_logo.png', height: 70, width: 70),
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), shape: BoxShape.circle),
              ),
            ],
          ),
          8.height,
          Text(title.validate(), style: boldTextStyle()),
          20.height,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              textStyle: secondaryTextStyle(color: white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: onPressed as void Function()?,
            child: Text('Retry', style: primaryTextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

Widget productDetailCard(BuildContext context, {String? productName, String? name, bool isShowDivider = true}) {
  return Container(
    width: context.width(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name!, style: boldTextStyle()),
        10.height,
        Text(productName!.trim(), style: primaryTextStyle(color: appStore.textSecondaryColor), textAlign: TextAlign.justify),
        Divider(height: 24).visible(isShowDivider),
      ],
    ),
  );
}

Widget mSale(ProductDetailResponse1 product) {
  return Positioned(
    right: 0,
    top: 0,
    child: Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.red, borderRadius: radiusOnly(bottomLeft: 8, topRight: 8)),
      child: Text("Sale", style: secondaryTextStyle(color: white, size: 12)),
      padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
    ),
  ).visible(product.onSale == true && product.type != 'variable' && product.type != 'variation'&&product.type != 'grouped');
}

Widget cardWidget(BuildContext context, {String? orderName, int? total, double? width, Color? color, String? image}) {
  return Container(
    decoration: boxDecorationDefault(color: color != null ? color.withOpacity(0.2) : statusColor(orderName!.toLowerCase()).withOpacity(0.2), boxShadow: <BoxShadow>[]),
    padding: EdgeInsets.all(10),
    width: width ?? context.width() * 0.5 - 40,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$total", style: primaryTextStyle(size: 30, color: color ?? statusColor(orderName!.toLowerCase()))),
            image != null && image.isNotEmpty
                ? Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.cardColor,
                    ),
                    child: cachedImage(image, color: color, width: 24, height: 24),
                  )
                : SizedBox(),
          ],
        ),
        16.height,
        Text(orderName.validate(), style: boldTextStyle(size: 14, color: color ?? statusColor(orderName!.toLowerCase())), maxLines: 2, overflow: TextOverflow.ellipsis),
      ],
    ),
  );
}

Widget cardWidget1(BuildContext context, {String? orderName, int? total, double? width}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(orderName.validate(), style: primaryTextStyle(size: 16, color: statusColor(orderName!.toLowerCase())), maxLines: 2, overflow: TextOverflow.ellipsis),
      10.height,
      Text("$total", style: primaryTextStyle(size: 16, color: statusColor(orderName.toLowerCase()))),
    ],
  );
}

Widget commonEditButtonComponent({IconData? icon, Color? color, Function? onCall}) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: boxDecorationWithRoundedCorners(backgroundColor: color!.withOpacity(0.2), border: Border.all(color: color)),
    child: Icon(icon!, size: 20, color: color),
  ).onTap(() async {
    onCall!();
  });
}

Widget loading() {
  return Loader(color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white);
}

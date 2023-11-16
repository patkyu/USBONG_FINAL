import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/dashboard/VendorResponse.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';

import '../../../main.dart';
import '../../VendorDetailScreen.dart';
import '../../VendorListScreen.dart';

Widget getVendorWidget(VendorsResponse vendor, BuildContext context, {double width = 260}) {
  String img = vendor.banner!.isNotEmpty ? vendor.banner.validate() : '';

  String? addressText = "";
  if (vendor.address != null) {
    if (vendor.address!.street1 != null) {
      if (vendor.address!.street1!.isNotEmpty && addressText.isEmpty) {
        addressText = vendor.address!.street1;
      }
    }
    if (vendor.address!.street2 != null) {
      if (vendor.address!.street2!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.street2;
        } else {
          addressText += ", " + vendor.address!.street2!;
        }
      }
    }
    if (vendor.address!.city != null) {
      if (vendor.address!.city!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.city;
        } else {
          addressText += ", " + vendor.address!.city!;
        }
      }
    }

    if (vendor.address!.zip != null) {
      if (vendor.address!.zip!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.zip;
        } else {
          addressText += " - " + vendor.address!.zip!;
        }
      }
    }
    if (vendor.address!.state != null) {
      if (vendor.address!.state!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.state;
        } else {
          addressText += ", " + vendor.address!.state!;
        }
      }
    }
    if (vendor.address!.country != null) {
      if (!vendor.address!.country!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.country;
        } else {
          addressText += ", " + vendor.address!.country!;
        }
      }
    }
  }

  return Container(
    width: context.width() * 0.8,
    height: 170,
    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    decoration: boxDecorationWithRoundedCorners(border: Border.all(width: 0.4), backgroundColor: context.cardColor),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vendor.storeName!, style: boldTextStyle(size: 18)),
            8.height,
            Text(addressText!.trim(), maxLines: 4, style: secondaryTextStyle()),
            12.height,
            Row(
              children: [
                Icon(Icons.add, size: 12, color: textSecondaryColor.withOpacity(0.6)),
                4.width,
                Text("Explore", style: secondaryTextStyle(color: textSecondaryColor.withOpacity(0.6))),
              ],
            )
          ],
        ).paddingOnly(right: 8, left: 16).expand(),
        Container(
          alignment: Alignment.center,
          decoration: boxDecorationWithShadow(borderRadius: radius(), backgroundColor: context.cardColor),
          child: cachedImage(img, fit: BoxFit.cover, width: context.width() * 0.8 / 2, height: 200).cornerRadiusWithClipRRectOnly(bottomRight: defaultRadius.toInt(),topRight:defaultRadius.toInt() ),
        ),
      ],
    ),
  );
}

Widget vendorListComponent(List<VendorsResponse> product) {
  return HorizontalList(
    itemCount: product.length,
    padding: EdgeInsets.only(left: 8, right: 8),
    itemBuilder: (context, i) {
      return GestureDetector(
        onTap: () {
          VendorDetailScreen(product[i].id).launch(context);
        },
        child: Column(
          children: [
            getVendorWidget(product[i], context),
          ],
        ),
      );
    },
  );
}

Widget mVendorWidget(BuildContext context, List<VendorsResponse> mVendorModel, {var title, var all, size: 16}) {
  return mVendorModel.isNotEmpty
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.lblVendor, style: boldTextStyle(size: 20)).paddingOnly(left: 16, right: 16).visible(mVendorModel.isNotEmpty),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(language.view_All, style: boldTextStyle(size: 14, color: primaryColor)), Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: 14)],
                ).paddingOnly(right: 8).onTap(() {
                  push(VendorListScreen());
                }),
              ],
            ),
            8.height,
            vendorListComponent(mVendorModel)
          ],
        )
      : SizedBox();
}

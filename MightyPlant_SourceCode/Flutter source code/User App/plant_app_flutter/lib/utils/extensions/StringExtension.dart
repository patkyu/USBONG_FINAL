import 'package:flutter/material.dart';
import 'package:plant_flutter/utils/images.dart';

extension strEtx on String {
  Widget iconImage({double? size, Color? color}) {
    return Image.asset(this, height: size ?? 24, width: size ?? 24, color: color ?? null);
  }

  String get getImageString {
    switch (this) {
      case "pending":
        return appImages.icPending;
      case "processing":
        return appImages.icProcess;
      case "on-hold":
        return appImages.icPause;
      case "completed":
        return appImages.icChecked;
      case "cancelled":
        return appImages.icError;
      case "refunded":
        return appImages.icRefund;
      case "failed":
        return appImages.icFailed;
      default:
        return appImages.icPending;
    }
  }
}

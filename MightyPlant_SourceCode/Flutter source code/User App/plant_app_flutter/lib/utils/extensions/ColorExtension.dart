import 'package:flutter/material.dart';

extension colorExt on String {
  //{background:#c8d7e1;color:#2e4453}
  Color get getPaymentStatusBackgroundColor {
    switch (this) {
      case "pending":
        return Color(0xFFe5e5e5);
      case "processing":
        return Color(0xFFc6e1c6);
      case "on-hold":
        return Color(0xFFf8dda7);
      case "completed":
        return Color(0xFFc8d7e1);
      case "cancelled":
        return Color(0xFFe5e5e5);
      case "refunded":
        return Color(0xffeba3a3);
      case "failed":
        return Color(0xFFeba3a3);
      default:
        return Color(0xFFe5e5e5);
    }
  }

  Color get getPaymentStatusColor {
    switch (this) {
      case "pending":
        return Color(0xff797979);
      case "processing":
        return Color(0xFF5b841b);
      case "on-hold":
        return Color(0xFF94660c);
      case "completed":
        return Color(0xFF2e4453);
      case "cancelled":
        return Color(0xff797979);
      case "refunded":
        return Color(0xFFaa0000);
      case "failed":
        return Color(0xFF761919);
      default:
        return Color(0xff797979);
    }
  }
}

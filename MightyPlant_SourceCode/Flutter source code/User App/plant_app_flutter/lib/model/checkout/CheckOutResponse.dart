import 'package:plant_flutter/model/auth/UserResponse.dart';

class CheckOutResponse {
  Billing? billing;
  String? coupon_lines;
  String? customer_id;
  List<LineItem>? line_items;
  String? payment_method;
  bool? set_paid;
  Billing? shipping;
  String? status;
  String? transaction_id;

  CheckOutResponse({this.billing, this.coupon_lines, this.customer_id, this.line_items, this.payment_method, this.set_paid, this.shipping, this.status, this.transaction_id});

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) {
    return CheckOutResponse(
      billing: json['billing'] != null ? Billing.fromJson(json['billing']) : null,
      coupon_lines: json['coupon_lines'],
      customer_id: json['customer_id'],
      line_items: json['line_items'] != null ? (json['line_items'] as List).map((i) => LineItem.fromJson(i)).toList() : null,
      payment_method: json['payment_method'],
      set_paid: json['set_paid'],
      shipping: json['shipping'] != null ? Billing.fromJson(json['shipping']) : null,
      status: json['status'],
      transaction_id: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_lines'] = this.coupon_lines;
    data['customer_id'] = this.customer_id;
    data['payment_method'] = this.payment_method;
    data['set_paid'] = this.set_paid;
    data['status'] = this.status;
    data['transaction_id'] = this.transaction_id;
    if (this.billing != null) {
      data['billing'] = this.billing!.toJson();
    }
    if (this.line_items != null) {
      data['line_items'] = this.line_items!.map((v) => v.toJson()).toList();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    return data;
  }
}

class LineItem {
  int? product_id;
  String? quantity;

  LineItem({this.product_id, this.quantity});

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      product_id: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.product_id;
    data['quantity'] = this.quantity;
    return data;
  }
}

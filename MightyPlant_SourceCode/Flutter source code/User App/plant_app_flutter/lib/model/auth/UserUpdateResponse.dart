import 'package:plant_flutter/model/auth/UserResponse.dart';

class UserUpdateResponse {
  Billing? billing;
  String? first_name;
  String? last_name;
  Billing? shipping;

  UserUpdateResponse({
    this.billing,
    this.first_name,
    this.last_name,
    this.shipping,
  });

  factory UserUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserUpdateResponse(
      billing: json['billing'] != null ? Billing.fromJson(json['billing']) : null,
      first_name: json['first_name'],
      last_name: json['last_name'],
      shipping: json['shipping'] != null ? Billing.fromJson(json['shipping']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    if (this.billing != null) {
      data['billing'] = this.billing!.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    return data;
  }
}

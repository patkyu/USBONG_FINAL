import 'package:plant_flutter/model/auth/UserResponse.dart';

class LoginResponse {
  String? avatar;
  Billing? billing;
  String? first_name;
  String? last_name;
  String? plantapp_profile_image;
  Billing? shipping;
  String? token;
  String? user_display_name;
  String? user_email;
  int? user_id;
  String? user_nicename;
  List<String>? user_role;

  LoginResponse({this.avatar, this.billing, this.first_name, this.last_name, this.plantapp_profile_image, this.shipping, this.token, this.user_display_name, this.user_email, this.user_id, this.user_nicename, this.user_role});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      avatar: json['avatar'],
      billing: json['billing'] != null ? Billing.fromJson(json['billing']) : null,
      first_name: json['first_name'],
      last_name: json['last_name'],
      plantapp_profile_image: json['plantapp_profile_image'],
      shipping: json['shipping'] != null ? Billing.fromJson(json['shipping']) : null,
      token: json['token'],
      user_display_name: json['user_display_name'],
      user_email: json['user_email'],
      user_id: json['user_id'],
      user_nicename: json['user_nicename'],
      user_role: json['user_role'] != null ? new List<String>.from(json['user_role']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['plantapp_profile_image'] = this.plantapp_profile_image;
    data['token'] = this.token;
    data['user_display_name'] = this.user_display_name;
    data['user_email'] = this.user_email;
    data['user_id'] = this.user_id;
    data['user_nicename'] = this.user_nicename;
    if (this.billing != null) {
      data['billing'] = this.billing!.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    if (this.user_role != null) {
      data['user_role'] = this.user_role;
    }
    return data;
  }
}


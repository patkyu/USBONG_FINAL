import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';

class Array {
  String? name;
  String? price;
  String? image;
  String? description;

  Array({this.name, this.price, this.image, this.description});

  factory Array.fromJson(Map<String, dynamic> json) {
    return Array(
      name: json['name'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}

class DashboardResponse {
  List<ProductListResponse>? productData;
  List<String>? category;
  String? orderby;
  String? title;
  String? type;
  bool? view_all;

  DashboardResponse({this.productData, this.category, this.orderby, this.title, this.type, this.view_all});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      productData: json['data'] != null ? (json['data'] as List).map((i) => ProductListResponse.fromJson(i)).toList() : null,
      category: json['category'] != null ? new List<String>.from(json['category']) : null,
      orderby: json['orderby'],
      title: json['title'],
      type: json['type'],
      view_all: json['view_all'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderby'] = this.orderby;
    data['title'] = this.title;
    data['type'] = this.type;
    data['view_all'] = this.view_all;
    if (this.productData != null) {
      data['data'] = this.productData!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category;
    }
    return data;
  }
}

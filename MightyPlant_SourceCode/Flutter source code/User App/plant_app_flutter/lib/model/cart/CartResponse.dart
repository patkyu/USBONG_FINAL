import 'dart:core';

import 'package:nb_utils/nb_utils.dart';

class CartResponse {
  List<CartData>? cartData;
  int? total_quantity;

  CartResponse({this.cartData, this.total_quantity});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cartData: json['data'] != null ? (json['data'] as List).map((i) => CartData.fromJson(i)).toList() : null,
      total_quantity: json['total_quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_quantity'] = this.total_quantity;
    if (this.cartData != null) {
      data['data'] = this.cartData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartData {
  String? cart_id;
  String? created_at;
  String? description;
  String? full;
  List<String>? gallery;
  String? name;
  bool? on_sale;
  String? plant_product_type;
  String? price;
  int? pro_id;
  String? quantity;
  String? regular_price;
  String? sale_price;
  String? shipping_class;
  int? shipping_class_id;
  String? sku;
  int? stock_quantity;
  String? stock_status;
  String? thumbnail;
  double get discountPrice => (sale_price!.isNotEmpty && on_sale.validate()) ? (regular_price.validate().toDouble() - sale_price.validate().toDouble()) : 0;
  double get itemCalculatedPrice => (sale_price!.isNotEmpty && on_sale.validate()) ? (sale_price.validate().toDouble() * quantity.toDouble()) : regular_price.validate().toDouble() * quantity.toDouble();

  CartData({
    this.cart_id,
    this.created_at,
    this.description,
    this.full,
    this.gallery,
    this.name,
    this.on_sale,
    this.plant_product_type,
    this.price,
    this.pro_id,
    this.quantity,
    this.regular_price,
    this.sale_price,
    this.shipping_class,
    this.shipping_class_id,
    this.sku,
    this.stock_quantity,
    this.stock_status,
    this.thumbnail,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cart_id: json['cart_id'],
      created_at: json['created_at'],
      description: json['description'],
      full: json['full'],
      gallery: json['gallery'] != null ? new List<String>.from(json['gallery']) : null,
      name: json['name'],
      on_sale: json['on_sale'],
      plant_product_type: json['plant_product_type'],
      price: json['price'],
      pro_id: json['pro_id'],
      quantity: json['quantity'],
      regular_price: json['regular_price'],
      sale_price: json['sale_price'],
      shipping_class: json['shipping_class'],
      shipping_class_id: json['shipping_class_id'],
      sku: json['sku'],
      stock_quantity: json['stock_quantity'],
      stock_status: json['stock_status'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cart_id;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['full'] = this.full;
    data['name'] = this.name;
    data['on_sale'] = this.on_sale;
    data['plant_product_type'] = this.plant_product_type;
    data['price'] = this.price;
    data['pro_id'] = this.pro_id;
    data['quantity'] = this.quantity;
    data['regular_price'] = this.regular_price;
    data['sale_price'] = this.sale_price;
    data['shipping_class'] = this.shipping_class;
    data['shipping_class_id'] = this.shipping_class_id;
    data['sku'] = this.sku;
    data['stock_status'] = this.stock_status;
    data['thumbnail'] = this.thumbnail;
    data['stock_quantity'] = this.stock_quantity;
    if (this.gallery != null) {
      data['gallery'] = this.gallery;
    }

    return data;
  }
}

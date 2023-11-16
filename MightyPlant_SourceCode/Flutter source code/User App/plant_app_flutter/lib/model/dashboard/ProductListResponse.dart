import 'package:plant_flutter/model/product/ProductResponse.dart';

class ProductListResponse {
  String? average_rating;
  String? description;
  bool? featured;
  int? id;
  List<Images>? images;
  bool? in_stock;
  bool? is_added_cart;
  bool? is_added_wishlist;
  bool? manage_stock;
  String? name;
  bool? on_sale;
  String? permalink;
  String? plant_product_type;
  String? price;
  int? rating_count;
  String? regular_price;
  String? sale_price;
  String? short_description;
  String? status;
  String? stock_quantity;
  String? type;

  ProductListResponse({
    this.average_rating,
    this.description,
    this.featured,
    this.id,
    this.images,
    this.in_stock,
    this.is_added_cart,
    this.is_added_wishlist,
    this.manage_stock,
    this.name,
    this.on_sale,
    this.permalink,
    this.plant_product_type,
    this.price,
    this.rating_count,
    this.regular_price,
    this.sale_price,
    this.short_description,
    this.status,
    this.stock_quantity,
    this.type,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      average_rating: json['average_rating'],
      description: json['description'],
      featured: json['featured'],
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => Images.fromJson(i)).toList() : null,
      in_stock: json['in_stock'],
      is_added_cart: json['is_added_cart'],
      is_added_wishlist: json['is_added_wishlist'],
      manage_stock: json['manage_stock'],
      name: json['name'],
      on_sale: json['on_sale'],
      permalink: json['permalink'],
      plant_product_type: json['plant_product_type'],
      price: json['price'],
      rating_count: json['rating_count'],
      regular_price: json['regular_price'],
      sale_price: json['sale_price'],
      short_description: json['short_description'],
      status: json['status'],
      stock_quantity: json['stock_quantity'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.average_rating;
    data['description'] = this.description;
    data['featured'] = this.featured;
    data['id'] = this.id;
    data['in_stock'] = this.in_stock;
    data['is_added_cart'] = this.is_added_cart;
    data['is_added_wishlist'] = this.is_added_wishlist;
    data['manage_stock'] = this.manage_stock;
    data['name'] = this.name;
    data['on_sale'] = this.on_sale;
    data['permalink'] = this.permalink;
    data['plant_product_type'] = this.plant_product_type;
    data['price'] = this.price;
    data['rating_count'] = this.rating_count;
    data['regular_price'] = this.regular_price;
    data['sale_price'] = this.sale_price;
    data['short_description'] = this.short_description;
    data['status'] = this.status;
    data['stock_quantity'] = this.stock_quantity;
    data['type'] = this.type;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListResponse {
  List<ProductListResponse>? bestSellingProduct;
  List<ProductListResponse>? saleProduct;
  List<ProductListResponse>? featured;
  List<ProductListResponse>? newest;
  List<ProductListResponse>? highestRating;
  List<ProductListResponse>? discount;

  ListResponse({this.bestSellingProduct, this.saleProduct, this.featured, this.newest, this.highestRating, this.discount});

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    return ListResponse(
      bestSellingProduct: json['best_selling_product'] != null ? (json['best_selling_product'] as List).map((i) => ProductListResponse.fromJson(i)).toList() : null,
      saleProduct: json['sale_product'] != null ? (json['sale_product'] as List).map((i) => ProductListResponse.fromJson(i)).toList() : null,
      featured: json['featured'] != null ? (json['featured'] as List).map((i) => ProductListResponse.fromJson(i)).toList() : null,
      newest: json['newest'] != null ? (json['newest'] as List).map((i) => ProductListResponse.fromJson(i)).toList() : null,
      highestRating: json['highest_rating'] != null ? (json['highest_rating'] as List).map((i) => ProductListResponse.fromJson(i)).toList() : null,
      discount: json['discount'] != null ? (json['discount'] as List).map((i) => ProductListResponse.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.bestSellingProduct != null) {
      data['best_selling_product'] = this.bestSellingProduct!.map((v) => v.toJson()).toList();
    }
    if (this.saleProduct != null) {
      data['sale_product'] = this.saleProduct!.map((v) => v.toJson()).toList();
    }
    if (this.featured != null) {
      data['featured'] = this.featured!.map((v) => v.toJson()).toList();
    }
    if (this.newest != null) {
      data['newest'] = this.newest!.map((v) => v.toJson()).toList();
    }
    if (this.highestRating != null) {
      data['highest_rating'] = this.highestRating!.map((v) => v.toJson()).toList();
    }
    if (this.discount != null) {
      data['discount'] = this.discount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

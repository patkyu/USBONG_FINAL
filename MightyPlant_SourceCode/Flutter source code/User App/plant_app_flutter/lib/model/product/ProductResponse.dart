class ProductResponse {
  List<ProductData>? productData;
  int? num_of_pages;

  ProductResponse({this.productData, this.num_of_pages});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      productData: json['data'] != null ? (json['data'] as List).map((i) => ProductData.fromJson(i)).toList() : null,
      num_of_pages: json['num_of_pages'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_of_pages'] = this.num_of_pages;
    if (this.productData != null) {
      data['data'] = this.productData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductData {
  String? average_rating;
  String? description;
  num? discount_percentage;
  int? discount_price;
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

  ProductData(
      {this.average_rating,
      this.description,
      this.discount_percentage,
      this.discount_price,
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
      this.type});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      average_rating: json['average_rating'],
      description: json['description'],
      discount_percentage: json['discount_percentage'],
      discount_price: json['discount_price'],
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
    data['discount_percentage'] = this.discount_percentage;
    data['discount_price'] = this.discount_price;
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

class Images {
  String? alt;
  String? date_created;
  String? date_modified;
  int? id;
  String? name;
  int? position;
  String? src;

  Images({this.alt, this.date_created, this.date_modified, this.id, this.name, this.position, this.src});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      alt: json['alt'],
      date_created: json['date_created'],
      date_modified: json['date_modified'],
      id: json['id'],
      name: json['name'],
      position: json['position'],
      src: json['src'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alt'] = this.alt;
    data['date_created'] = this.date_created;
    data['date_modified'] = this.date_modified;
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['src'] = this.src;
    return data;
  }
}

class WishlistResponse {
  String? created_at;
  String? description;
  String? full;
  List<String>? gallery;
  bool? in_stock;
  String? name;
  String? plant_product_type;
  String? price;
  int? pro_id;
  String? regular_price;
  String? sale_price;
  String? sku;
  String? stock_quantity;
  String? thumbnail;

  WishlistResponse({this.created_at, this.description, this.full, this.gallery, this.in_stock, this.name, this.plant_product_type, this.price, this.pro_id, this.regular_price, this.sale_price, this.sku, this.stock_quantity, this.thumbnail});

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      created_at: json['created_at'],
      description: json['description'],
      full: json['full'],
      gallery: json['gallery'] != null ? new List<String>.from(json['gallery']) : null,
      in_stock: json['in_stock'],
      name: json['name'],
      plant_product_type: json['plant_product_type'],
      price: json['price'],
      pro_id: json['pro_id'],
      regular_price: json['regular_price'],
      sale_price: json['sale_price'],
      sku: json['sku'],
      stock_quantity: json['stock_quantity'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['full'] = this.full;
    data['in_stock'] = this.in_stock;
    data['name'] = this.name;
    data['plant_product_type'] = this.plant_product_type;
    data['price'] = this.price;
    data['pro_id'] = this.pro_id;
    data['regular_price'] = this.regular_price;
    data['sale_price'] = this.sale_price;
    data['sku'] = this.sku;
    data['stock_quantity'] = this.stock_quantity;
    data['thumbnail'] = this.thumbnail;
    if (this.gallery != null) {
      data['gallery'] = this.gallery;
    }
    return data;
  }
}

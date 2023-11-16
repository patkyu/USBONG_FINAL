import 'package:plant_flutter/model/dashboard/VendorResponse.dart';
import 'package:plant_flutter/model/product/ProductResponse.dart';

class ProductDetailResponse {
  List<Attributes>? attributes;
  String? average_rating;
  bool? backordered;
  String? backorders;
  bool? backorders_allowed;
  String? button_text;
  String? catalog_visibility;
  List<Category>? categories;

  String? date_created;
  String? date_modified;
  String? date_on_sale_from;
  String? date_on_sale_to;

  String? description;
  Dimensions? dimensions;
  int? download_expiry;
  int? download_limit;
  String? download_type;
  bool? downloadable;

  String? external_url;
  bool? featured;

  int? id;
  List<Images>? imagess;
  bool? in_stock;
  bool? is_added_cart;
  bool? is_added_wishlist;
  bool? manage_stock;
  int? menu_order;
  String? name;
  bool? on_sale;
  int? parent_id;
  String? permalink;
  String? plant_product_type;
  String? price;
  String? price_html;
  bool? purchasable;
  String? purchase_note;
  int? rating_count;
  String? regular_price;
  List<int>? related_ids;
  bool? reviews_allowed;
  String? sale_price;
  String? shipping_class;
  int? shipping_class_id;
  bool? shipping_required;
  bool? shipping_taxable;
  String? short_description;
  String? sku;
  String? slug;
  bool? sold_individually;
  String? status;
  String? stock_quantity;
  Store? store;

  String? tax_class;
  String? tax_status;
  int? total_sales;
  String? type;

  List<UpSells>? upsell_id;
  num? discount_percentage;
  num? discount_price;

  List<int>? variations;
  bool? virtual;
  String? weight;
  WoofvVideoEmbed? woofv_video_embed;
  String? plant_app_fertile;
  String? plant_app_life;
  String? plant_app_light;
  String? plant_app_plant_type;
  String? plant_app_temprature;
  String? plantApp_water;

  ProductDetailResponse(
      {this.attributes,
      this.average_rating,
      this.backordered,
      this.backorders,
      this.backorders_allowed,
      this.button_text,
      this.catalog_visibility,
      this.categories,
      this.date_created,
      this.date_modified,
      this.date_on_sale_from,
      this.date_on_sale_to,
      this.description,
      this.dimensions,
      this.download_expiry,
      this.download_limit,
      this.download_type,
      this.downloadable,
      this.external_url,
      this.featured,
      this.id,
      this.imagess,
      this.in_stock,
      this.is_added_cart,
      this.is_added_wishlist,
      this.manage_stock,
      this.menu_order,
      this.name,
      this.on_sale,
      this.parent_id,
      this.permalink,
      this.plant_product_type,
      this.price,
      this.price_html,
      this.purchasable,
      this.purchase_note,
      this.rating_count,
      this.regular_price,
      this.related_ids,
      this.reviews_allowed,
      this.sale_price,
      this.shipping_class,
      this.shipping_class_id,
      this.shipping_required,
      this.shipping_taxable,
      this.short_description,
      this.sku,
      this.slug,
      this.sold_individually,
      this.status,
      this.stock_quantity,
      this.tax_class,
      this.tax_status,
      this.total_sales,
      this.type,
      this.upsell_id,
      this.variations,
      this.virtual,
      this.weight,
      this.woofv_video_embed,
      this.plant_app_fertile,
      this.plant_app_life,
      this.plant_app_light,
      this.plant_app_plant_type,
      this.plant_app_temprature,
      this.plantApp_water,
      this.discount_percentage,
      this.discount_price,
      this.store});

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      attributes: json['attributes'] != null ? (json['attributes'] as List).map((i) => Attributes.fromJson(i)).toList() : null,
      average_rating: json['average_rating'],
      backordered: json['backordered'],
      backorders: json['backorders'],
      backorders_allowed: json['backorders_allowed'],
      button_text: json['button_text'],
      catalog_visibility: json['catalog_visibility'],
      categories: json['categories'] != null ? (json['categories'] as List).map((i) => Category.fromJson(i)).toList() : null,
      date_created: json['date_created'],
      date_modified: json['date_modified'],
      plant_product_type: json['plant_product_type'],
      plant_app_fertile: json['plantapp_fertile'],
      plant_app_life: json['plantapp_life'],
      plant_app_light: json['plantapp_light'],
      plant_app_plant_type: json['plantapp_plant_type'],
      plant_app_temprature: json['plantapp_temperature'],
      plantApp_water: json['plantapp_water'],
      date_on_sale_from: json['date_on_sale_from'],
      date_on_sale_to: json['date_on_sale_to'],
      description: json['description'],
      dimensions: json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null,
      download_expiry: json['download_expiry'],
      download_limit: json['download_limit'],
      download_type: json['download_type'],
      downloadable: json['downloadable'],
      external_url: json['external_url'], featured: json['featured'],
      id: json['id'],
      imagess: json['images'] != null ? (json['images'] as List).map((i) => Images.fromJson(i)).toList() : null,
      in_stock: json['in_stock'],
      is_added_cart: json['is_added_cart'],
      is_added_wishlist: json['is_added_wishlist'],
       manage_stock: json['manage_stock'],
       menu_order: json['menu_order'],
      name: json['name'],
      on_sale: json['on_sale'],
      parent_id: json['parent_id'],
      permalink: json['permalink'],
      price: json['price'],
      price_html: json['price_html'],
      // purchasable: json['purchasable'],
      // purchase_note: json['purchase_note'],
      rating_count: json['rating_count'],
      regular_price: json['regular_price'],
      related_ids: json['related_ids'] != null ? new List<int>.from(json['related_ids']) : null,
      reviews_allowed: json['reviews_allowed'],
      sale_price: json['sale_price'],
      shipping_class: json['shipping_class'],
      // shipping_class_id: json['shipping_class_id'],
      // shipping_required: json['shipping_required'],
      // shipping_taxable: json['shipping_taxable'],
      short_description: json['short_description'],
      // sku: json['sku'],
      // slug: json['slug'],
      // sold_individually: json['sold_individually'],
      // discount_percentage: json['discount_percentage'],
      discount_price: json['discount_price'],
      status: json['status'],
      stock_quantity: json['stock_quantity'],
      store: json['store'] != null ? new Store.fromJson(json['store']) : null,
       tax_class: json['tax_class'],
       tax_status: json['tax_status'],
      // total_sales: json['total_sales'],
      type: json['type'],
      upsell_id: json['upsell_id'] != null ? (json['upsell_id'] as List).map((i) => UpSells.fromJson(i)).toList() : null,
      variations: json['variations'] != null ? new List<int>.from(json['variations']) : null,
      virtual: json['virtual'],
       weight: json['weight'],
      woofv_video_embed: json['woofv_video_embed'] != null ? WoofvVideoEmbed.fromJson(json['woofv_video_embed']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.average_rating;
    data['backordered'] = this.backordered;
    data['backorders'] = this.backorders;
    data['backorders_allowed'] = this.backorders_allowed;
    data['button_text'] = this.button_text;
    data['catalog_visibility'] = this.catalog_visibility;
    data['date_created'] = this.date_created;
    data['date_modified'] = this.date_modified;
    data['date_on_sale_from'] = this.date_on_sale_from;
    data['date_on_sale_to'] = this.date_on_sale_to;
    data['description'] = this.description;
    data['download_expiry'] = this.download_expiry;
    data['download_limit'] = this.download_limit;
    data['download_type'] = this.download_type;
    data['downloadable'] = this.downloadable;
    data['external_url'] = this.external_url;
    data['featured'] = this.featured;
    data['id'] = this.id;
    data['in_stock'] = this.in_stock;
    data['is_added_cart'] = this.is_added_cart;
    data['is_added_wishlist'] = this.is_added_wishlist;
    data['manage_stock'] = this.manage_stock;
    data['menu_order'] = this.menu_order;
    data['name'] = this.name;
    data['on_sale'] = this.on_sale;
    data['parent_id'] = this.parent_id;
    data['permalink'] = this.permalink;
    data['price'] = this.price;
    data['price_html'] = this.price_html;
    data['purchasable'] = this.purchasable;
    data['purchase_note'] = this.purchase_note;
    data['rating_count'] = this.rating_count;
    data['regular_price'] = this.regular_price;
    data['reviews_allowed'] = this.reviews_allowed;
    data['sale_price'] = this.sale_price;
    data['shipping_class'] = this.shipping_class;
    data['shipping_class_id'] = this.shipping_class_id;
    data['shipping_required'] = this.shipping_required;
    data['shipping_taxable'] = this.shipping_taxable;
    data['short_description'] = this.short_description;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['sold_individually'] = this.sold_individually;
    data['status'] = this.status;
    data['stock_quantity'] = this.stock_quantity;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    data['tax_class'] = this.tax_class;
    data['tax_status'] = this.tax_status;
    data['total_sales'] = this.total_sales;
    data['type'] = this.type;
    data['virtual'] = this.virtual;
    data['weight'] = this.weight;
    data['plant_product_type'] = this.plant_product_type;
    data['plantapp_fertile'] = this.plant_app_fertile;
    data['plantapp_life'] = this.plant_app_life;
    data['plantapp_light'] = this.plant_app_light;
    data['plantapp_plant_type'] = this.plant_app_plant_type;
    data['plantapp_temperature'] = this.plant_app_temprature;
    data['plantapp_water'] = this.plantApp_water;
    data['discount_percentage'] = this.discount_percentage;
    data['discount_price'] = this.discount_price;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    /*if (this.cross_sell_ids != null) {
      data['cross_sell_ids'] = this.cross_sell_ids.map((v) => v.toJson()).toList();
    }*/
    /* if (this.default_attributes != null) {
      data['default_attributes'] = this.default_attributes.map((v) => v.toJson()).toList();
    }*/
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions!.toJson();
    }
    /* if (this.downloads != null) {
      data['downloads'] = this.downloads.map((v) => v.toJson()).toList();
    }*/
    /*if (this.grouped_products != null) {
      data['grouped_products'] = this.grouped_products.map((v) => v.toJson()).toList();
    }*/
    if (this.imagess != null) {
      data['images'] = this.imagess!.map((v) => v.toJson()).toList();
    }
    if (this.related_ids != null) {
      data['related_ids'] = this.related_ids;
    }
    /* if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }*/
    if (this.upsell_id != null) {
      data['upsell_id'] = this.upsell_id!.map((v) => v.toJson()).toList();
    }
    /*   if (this.upsell_ids != null) {
      data['upsell_ids'] = this.upsell_ids.map((v) => v.toJson()).toList();
    }*/
    data['variations'] = this.variations;
    if (this.woofv_video_embed != null) {
      data['woofv_video_embed'] = this.woofv_video_embed!.toJson();
    }
    return data;
  }
}

class Attributes {
  int? id;
  String? name;
  int? position;
  bool? visible;
  bool? variation;
  List<String>? options;
  String? option;

  Attributes({this.id, this.name, this.position, this.visible,this.option, this.variation,this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options'] != null ? new List<String>.from(json['options']) : null;

     option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['option'] = this.option;
    data['options'] = this.options;
    return data;
  }
}

class WoofvVideoEmbed {
  bool? autoplay;
  String? poster;
  String? thumbnail;
  String? url;

  WoofvVideoEmbed({this.autoplay, this.poster, this.thumbnail, this.url});

  factory WoofvVideoEmbed.fromJson(Map<String, dynamic> json) {
    return WoofvVideoEmbed(
      autoplay: json['autoplay'],
      poster: json['poster'],
      thumbnail: json['thumbnail'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoplay'] = this.autoplay;
    data['poster'] = this.poster;
    data['thumbnail'] = this.thumbnail;
    data['url'] = this.url;
    return data;
  }
}

class Dimensions {
  String? height;
  String? length;
  String? width;

  Dimensions({this.height, this.length, this.width});

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      height: json['height'],
      length: json['length'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['length'] = this.length;
    data['width'] = this.width;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;
  String? image;

  Category({this.id, this.name, this.slug, this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class UpSells {
  int? id;
  List<Images>? images;
  String? name;
  String? price;
  String? regular_price;
  String? sale_price;
  String? slug;

  UpSells({this.id, this.images, this.name, this.price, this.regular_price, this.sale_price, this.slug});

  factory UpSells.fromJson(Map<String, dynamic> json) {
    return UpSells(
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => Images.fromJson(i)).toList() : null,
      name: json['name'],
      price: json['price'],
      regular_price: json['regular_price'],
      sale_price: json['sale_price'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['regular_price'] = this.regular_price;
    data['sale_price'] = this.sale_price;
    data['slug'] = this.slug;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? shopName;
  String? url;
  Address? address;
  String? location;
  StoreOpenClose? storeOpenClose;

  Store({this.id, this.name, this.shopName, this.url, this.address, this.location, this.storeOpenClose});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shopName = json['shop_name'];
    url = json['url'];
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    location = json['location'];
    storeOpenClose = json['store_open_close'] != null ? new StoreOpenClose.fromJson(json['store_open_close']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shop_name'] = this.shopName;
    data['url'] = this.url;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['location'] = this.location;
    if (this.storeOpenClose != null) {
      data['store_open_close'] = this.storeOpenClose!.toJson();
    }
    return data;
  }
}

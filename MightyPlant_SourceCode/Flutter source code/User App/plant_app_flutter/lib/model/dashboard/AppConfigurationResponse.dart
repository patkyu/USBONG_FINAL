import 'package:plant_flutter/model/category/CategoryResponse.dart';

import 'VendorResponse.dart';

class AppConfigurationResponse {
  String? app_lang;
  List<Banner>? banner;
  List<Blog>? blog;
  List<CategoryResponse>? category;
  CurrencySymbol? currency_symbol;
  bool? enable_coupons;
  bool? enable_custom_dashboard;
  bool? exclude_outstock;
  bool? is_dokan_active;
  String? payment_method;
  SocialLink? social_link;
  List<VendorsResponse>? vendors;

  AppConfigurationResponse(
      {this.app_lang,
      this.banner,
      this.blog,
      this.category,
      this.currency_symbol,
      this.enable_coupons,
      this.enable_custom_dashboard,
      this.exclude_outstock,
      this.is_dokan_active,
      this.payment_method,
      this.social_link,
      this.vendors});

  factory AppConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return AppConfigurationResponse(
      app_lang: json['app_lang'],
      banner: json['banner'] != null ? (json['banner'] as List).map((i) => Banner.fromJson(i)).toList() : null,
      blog: json['blog'] != null ? (json['blog'] as List).map((i) => Blog.fromJson(i)).toList() : null,
      category: json['category'] != null ? (json['category'] as List).map((i) => CategoryResponse.fromJson(i)).toList() : null,
      currency_symbol: json['currency_symbol'] != null ? CurrencySymbol.fromJson(json['currency_symbol']) : null,
      enable_coupons: json['enable_coupons'],
      enable_custom_dashboard: json['enable_custom_dashboard'],
      exclude_outstock: json['exclude_outstock'],
      is_dokan_active: json['is_dokan_active'],
      payment_method: json['payment_method'],
      social_link: json['social_link'] != null ? SocialLink.fromJson(json['social_link']) : null,
      vendors: json['vendors'] != null ? (json['vendors'] as List).map((i) => VendorsResponse.fromJson(i)).toList() : null,

      // vendors: json['vendors'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_lang'] = this.app_lang;
    data['enable_coupons'] = this.enable_coupons;
    data['enable_custom_dashboard'] = this.enable_custom_dashboard;
    data['exclude_outstock'] = this.exclude_outstock;
    data['is_dokan_active'] = this.is_dokan_active;
    data['payment_method'] = this.payment_method;
    data['vendors'] = this.vendors;
    if (this.blog != null) {
      data['blog'] = this.blog!.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.currency_symbol != null) {
      data['currency_symbol'] = this.currency_symbol!.toJson();
    }
    if (this.social_link != null) {
      data['social_link'] = this.social_link!.toJson();
    }
    if (this.vendors != null) {
      data['vendors'] = this.vendors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  String? image;
  String? thumb;
  String? url;
  String? desc;

  Banner({this.image, this.thumb, this.url, this.desc});

  Banner.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    thumb = json['thumb'];
    url = json['url'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['url'] = this.url;
    data['desc'] = this.desc;
    return data;
  }
}

class SocialLink {
  String? contact;
  String? copyright_text;
  String? facebook;
  String? instagram;
  String? privacy_policy;
  String? refund_policy;
  String? shipping_policy;
  String? term_condition;
  String? twitter;
  String? website_url;
  String? whatsapp;

  SocialLink(
      {this.contact,
      this.copyright_text,
      this.facebook,
      this.instagram,
      this.privacy_policy,
      this.refund_policy,
      this.shipping_policy,
      this.term_condition,
      this.twitter,
      this.website_url,
      this.whatsapp});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      contact: json['contact'],
      copyright_text: json['copyright_text'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      privacy_policy: json['privacy_policy'],
      refund_policy: json['refund_policy'],
      shipping_policy: json['shipping_policy'],
      term_condition: json['term_condition'],
      twitter: json['twitter'],
      website_url: json['website_url'],
      whatsapp: json['whatsapp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    data['copyright_text'] = this.copyright_text;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['privacy_policy'] = this.privacy_policy;
    data['refund_policy'] = this.refund_policy;
    data['shipping_policy'] = this.shipping_policy;
    data['term_condition'] = this.term_condition;
    data['twitter'] = this.twitter;
    data['website_url'] = this.website_url;
    data['whatsapp'] = this.whatsapp;
    return data;
  }
}

class CurrencySymbol {
  String? currency;
  String? currency_symbol;

  CurrencySymbol({this.currency, this.currency_symbol});

  factory CurrencySymbol.fromJson(Map<String, dynamic> json) {
    return CurrencySymbol(
      currency: json['currency'],
      currency_symbol: json['currency_symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['currency_symbol'] = this.currency_symbol;
    return data;
  }
}

class Blog {
  List<CategoryResponse>? category;
  String? human_time_diff;
  int? iD;
  Object? image;
  String? no_of_comments;
  String? post_author_name;
  String? post_content;
  String? post_date;
  String? post_date_gmt;
  String? post_excerpt;
  String? post_title;
  String? readable_date;
  String? share_url;

  Blog(
      {this.category,
      this.human_time_diff,
      this.iD,
      this.image,
      this.no_of_comments,
      this.post_author_name,
      this.post_content,
      this.post_date,
      this.post_date_gmt,
      this.post_excerpt,
      this.post_title,
      this.readable_date,
      this.share_url});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      category: json['category'] != null ? (json['category'] as List).map((i) => CategoryResponse.fromJson(i)).toList() : null,
      human_time_diff: json['human_time_diff'],
      iD: json['iD'],
      // image: json['image'] != null ? Object.fromJson(json['image']) : null,
      no_of_comments: json['no_of_comments'],
      post_author_name: json['post_author_name'],
      post_content: json['post_content'],
      post_date: json['post_date'],
      post_date_gmt: json['post_date_gmt'],
      post_excerpt: json['post_excerpt'],
      post_title: json['post_title'],
      readable_date: json['readable_date'],
      share_url: json['share_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['human_time_diff'] = this.human_time_diff;
    data['iD'] = this.iD;
    data['no_of_comments'] = this.no_of_comments;
    data['post_author_name'] = this.post_author_name;
    data['post_content'] = this.post_content;
    data['post_date'] = this.post_date;
    data['post_date_gmt'] = this.post_date_gmt;
    data['post_excerpt'] = this.post_excerpt;
    data['post_title'] = this.post_title;
    data['readable_date'] = this.readable_date;
    data['share_url'] = this.share_url;
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    /*if (this.image != null) {
      data['image'] = this.image.toJson();
    }*/
    return data;
  }
}

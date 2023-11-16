class VendorsResponse {
  Address? address;
  String? banner;
  int? bannerId;
  bool? enabled;
  bool? featured;
  String? firstName;
  String? avatar;
  int? avatarId;
  int? id;
  String? lastName;
  String? location;
  String? payment;
  String? phone;
  int? productsPerPage;
  Rating? rating;
  String? registered;
  String? shopUrl;
  bool? showEmail;
  bool? showMoreProductTab;
  Social? social;
  String? storeName;
  StoreOpenClose? storeOpenClose;
  String? storeToc;
  bool? tocEnabled;
  bool? trusted;

  VendorsResponse({this.address, this.banner, this.bannerId, this.enabled, this.featured, this.firstName, this.avatar, this.avatarId, this.id, this.lastName, this.location, this.payment, this.phone, this.productsPerPage, this.rating, this.registered, this.shopUrl, this.showEmail, this.showMoreProductTab, this.social, this.storeName, this.storeOpenClose, this.storeToc, this.tocEnabled, this.trusted});

  factory VendorsResponse.fromJson(Map<String, dynamic> json) {
    return VendorsResponse(
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      banner: json['banner'],
      bannerId: json['banner_id'],
      enabled: json['enabled'],
      featured: json['featured'],
      firstName: json['first_name'],
      avatar: json['gravatar'],
      avatarId: json['gravatar_id'],
      id: json['id'],
      lastName: json['last_name'],
      location: json['location'],
      payment: json['payment'],
      phone: json['phone'],
      productsPerPage: json['products_per_page'],
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
      registered: json['registered'],
      shopUrl: json['shop_url'],
      showEmail: json['show_email'],
      showMoreProductTab: json['show_more_product_tab'],
      social: json['social'] != null ? Social.fromJson(json['social']) : null,
      storeName: json['store_name'],
      storeOpenClose: json['store_open_close'] != null ? StoreOpenClose.fromJson(json['store_open_close']) : null,
      storeToc: json['store_toc'],
      tocEnabled: json['toc_enabled'],
      trusted: json['trusted'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner'] = this.banner;
    data['banner_id'] = this.bannerId;
    data['enabled'] = this.enabled;
    data['featured'] = this.featured;
    data['first_name'] = this.firstName;
    data['gravatar'] = this.avatar;
    data['gravatar_id'] = this.avatarId;
    data['id'] = this.id;
    data['last_name'] = this.lastName;
    data['location'] = this.location;
    data['payment'] = this.payment;
    data['phone'] = this.phone;
    data['products_per_page'] = this.productsPerPage;
    data['registered'] = this.registered;
    data['shop_url'] = this.shopUrl;
    data['show_email'] = this.showEmail;
    data['show_more_product_tab'] = this.showMoreProductTab;
    data['store_name'] = this.storeName;
    data['store_toc'] = this.storeToc;
    data['toc_enabled'] = this.tocEnabled;
    data['trusted'] = this.trusted;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    if (this.social != null) {
      data['social'] = this.social!.toJson();
    }
    if (this.storeOpenClose != null) {
      data['store_open_close'] = this.storeOpenClose!.toJson();
    }
    return data;
  }
}

class Rating {
  int? count;
  String? rating;

  Rating({this.count, this.rating});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      count: json['count'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['rating'] = this.rating;
    return data;
  }
}

class StoreOpenClose {
  String? closeNotice;
  bool? enabled;
  String? openNotice;

  StoreOpenClose({this.closeNotice, this.enabled, this.openNotice});

  factory StoreOpenClose.fromJson(Map<String, dynamic> json) {
    return StoreOpenClose(
      closeNotice: json['close_notice'],
      enabled: json['enabled'],
      openNotice: json['open_notice'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['close_notice'] = this.closeNotice;
    data['enabled'] = this.enabled;
    data['open_notice'] = this.openNotice;
    return data;
  }
}

class Social {
  String? fb;
  String? flicker;
  String? gPlus;
  String? instagram;
  String? linkDin;
  String? pinterest;
  String? twitter;
  String? youtube;

  Social({this.fb, this.flicker, this.gPlus, this.instagram, this.linkDin, this.pinterest, this.twitter, this.youtube});

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      fb: json['fb'],
      flicker: json['flickr'],
      gPlus: json['gplus'],
      instagram: json['instagram'],
      linkDin: json['linkedin'],
      pinterest: json['pinterest'],
      twitter: json['twitter'],
      youtube: json['youtube'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fb'] = this.fb;
    data['flickr'] = this.flicker;
    data['gplus'] = this.gPlus;
    data['instagram'] = this.instagram;
    data['linkedin'] = this.linkDin;
    data['pinterest'] = this.pinterest;
    data['twitter'] = this.twitter;
    data['youtube'] = this.youtube;
    return data;
  }
}

class Address {
  String? street1;
  String? street2;
  String? city;
  String? zip;
  String? country;
  String? state;

  Address({this.street1, this.street2, this.city, this.zip, this.country, this.state});

  Address.fromJson(Map<String, dynamic> json) {
    street1 = json['street_1'];
    street2 = json['street_2'];
    city = json['city'];
    zip = json['zip'];
    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_1'] = this.street1;
    data['street_2'] = this.street2;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['state'] = this.state;
    return data;
  }
}

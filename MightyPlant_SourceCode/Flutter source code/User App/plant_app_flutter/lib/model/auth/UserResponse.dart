class UserResponse {
  String? avatar_url;
  Billing? billing;
  String? date_created;
  String? date_created_gmt;
  String? date_modified;
  String? date_modified_gmt;
  String? email;
  String? first_name;
  int? id;
  bool? is_paying_customer;
  String? last_name;
  String? role;
  Billing? shipping;
  String? username;
  List<MetaData>? meta_data;

  UserResponse(
      {this.avatar_url, this.billing, this.date_created, this.date_created_gmt, this.date_modified, this.date_modified_gmt, this.email, this.first_name, this.id, this.is_paying_customer, this.last_name, this.role, this.shipping, this.username,this.meta_data});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      avatar_url: json['avatar_url'],
      billing: json['billing'] != null ? Billing.fromJson(json['billing']) : null,
      date_created: json['date_created'],
      date_created_gmt: json['date_created_gmt'],
      date_modified: json['date_modified'],
      date_modified_gmt: json['date_modified_gmt'],
      email: json['email'],
      first_name: json['first_name'],
      id: json['id'],
      is_paying_customer: json['is_paying_customer'],
      last_name: json['last_name'],
      role: json['role'],
      shipping: json['shipping'] != null ? Billing.fromJson(json['shipping']) : null,
      username: json['username'],
      meta_data: json['meta_data'] != null ? (json['meta_data'] as List).map((i) => MetaData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar_url'] = this.avatar_url;
    data['date_created'] = this.date_created;
    data['date_created_gmt'] = this.date_created_gmt;
    data['date_modified'] = this.date_modified;
    data['date_modified_gmt'] = this.date_modified_gmt;
    data['email'] = this.email;
    data['first_name'] = this.first_name;
    data['id'] = this.id;
    data['is_paying_customer'] = this.is_paying_customer;
    data['last_name'] = this.last_name;
    data['role'] = this.role;
    data['username'] = this.username;
    if (this.billing != null) {
      data['billing'] = this.billing!.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    if (this.meta_data != null) {
      data['meta_data'] = this.meta_data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Billing {
  String? address_1;
  String? address_2;
  String? city;
  String? company;
  String? country;
  String? email;
  String? first_name;
  String? last_name;
  String? phone;
  String? postcode;
  String? state;

  Billing({this.address_1, this.address_2, this.city, this.company, this.country, this.email, this.first_name, this.last_name, this.phone, this.postcode, this.state});

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      address_1: json['address_1'],
      address_2: json['address_2'],
      city: json['city'],
      company: json['company'],
      country: json['country'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      phone: json['phone'],
      postcode: json['postcode'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_1'] = this.address_1;
    data['address_2'] = this.address_2;
    data['city'] = this.city;
    data['company'] = this.company;
    data['country'] = this.country;
    data['email'] = this.email;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['phone'] = this.phone;
    data['postcode'] = this.postcode;
    data['state'] = this.state;
    return data;
  }
}
class MetaData {
  int? id;
  String? key;
  String? value;

  MetaData({this.id, this.key, this.value});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      id: json['id'],
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }

}

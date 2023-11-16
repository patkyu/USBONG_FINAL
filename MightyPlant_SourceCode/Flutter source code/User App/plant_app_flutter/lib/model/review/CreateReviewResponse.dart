import 'package:plant_flutter/model/review/ReviewResponse.dart';

class CreateReviewResponse {
  Links? links;
  String? date_created;
  String? date_created_gmt;
  int? id;
  int? product_id;
  int? rating;
  String? review;
  String? reviewer;
  String? reviewer_email;
  String? status;
  bool? verified;

  CreateReviewResponse({this.links, this.date_created, this.date_created_gmt, this.id, this.product_id, this.rating, this.review, this.reviewer, this.reviewer_email, this.status, this.verified});

  factory CreateReviewResponse.fromJson(Map<String, dynamic> json) {
    return CreateReviewResponse(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      date_created: json['date_created'],
      date_created_gmt: json['date_created_gmt'],
      id: json['id'],
      product_id: json['product_id'],
      rating: json['rating'],
      review: json['review'],
      reviewer: json['reviewer'],
      reviewer_email: json['reviewer_email'],
      status: json['status'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_created'] = this.date_created;
    data['date_created_gmt'] = this.date_created_gmt;
    data['id'] = this.id;
    data['product_id'] = this.product_id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['reviewer'] = this.reviewer;
    data['reviewer_email'] = this.reviewer_email;
    data['status'] = this.status;
    data['verified'] = this.verified;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    return data;
  }
}

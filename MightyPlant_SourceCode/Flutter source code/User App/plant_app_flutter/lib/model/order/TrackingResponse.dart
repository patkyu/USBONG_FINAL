class TrackingResponse {
  String? message;
  String? status;

  TrackingResponse({this.message, this.status});

  factory TrackingResponse.fromJson(Map<String, dynamic> json) {
    return TrackingResponse(
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

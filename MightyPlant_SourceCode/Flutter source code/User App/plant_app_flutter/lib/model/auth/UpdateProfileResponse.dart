class UpdateProfileResponse {
  String? message;
  String? plantApp_profile_image;

  UpdateProfileResponse({this.message, this.plantApp_profile_image});

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      message: json['message'],
      plantApp_profile_image: json['plantapp_profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['plantapp_profile_image'] = this.plantApp_profile_image;
    return data;
  }
}

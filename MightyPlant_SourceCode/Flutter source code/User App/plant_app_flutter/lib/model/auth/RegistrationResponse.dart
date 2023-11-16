class RegistrationResponse {
  RegistrationData? registrationData;
  String? message;

  RegistrationResponse({this.registrationData, this.message});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      registrationData: json['data'] != null ? RegistrationData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.registrationData != null) {
      data['data'] = this.registrationData!.toJson();
    }
    return data;
  }
}

class RegistrationData {
  String? firstName;
  String? lastName;
  String? userEmail;
  String? userLogin;

  RegistrationData({this.firstName, this.lastName, this.userEmail, this.userLogin});

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      firstName: json['first_name'],
      lastName: json['last_name'],
      userEmail: json['user_email'],
      userLogin: json['user_login'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_email'] = this.userEmail;
    data['user_login'] = this.userLogin;
    return data;
  }
}

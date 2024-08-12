class SigninModel {
  int? statusCode;
  String? message;
  String? error;
  LoginData? data;

  SigninModel({this.statusCode, this.message, this.error, this.data});

  SigninModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    error = json['error'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? token;
  String? refreshToken;
  bool? isProfileInit;
  bool? isEmailVerified;

  LoginData({
    this.token,
    this.isProfileInit,
    this.refreshToken,
    this.isEmailVerified,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
    isProfileInit = json['isProfileInit'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['isProfileInit'] = isProfileInit;
    data['isEmailVerified'] = isEmailVerified;
    return data;
  }
}

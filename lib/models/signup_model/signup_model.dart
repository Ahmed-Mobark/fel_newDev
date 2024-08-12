class SignupModel {
  int? statusCode;
  String? message;
  String? error;
  String? data;

  SignupModel({this.statusCode, this.message, this.error, this.data});

  SignupModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    error = json['error'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['error'] = error;
    return data;
  }
}

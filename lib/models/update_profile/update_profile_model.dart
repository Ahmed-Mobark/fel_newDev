class UpdateProfileModel {
  int? statusCode;
  String? message;
  String? error;
  bool? data;

  UpdateProfileModel({this.statusCode, this.message, this.error});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
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
    data['data'] = data;
    return data;
  }
}

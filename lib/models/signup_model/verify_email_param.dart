class VerifyEmailParam {
  String? userId;
  String? code;

  VerifyEmailParam({this.userId, this.code});

  VerifyEmailParam.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['code'] = code;
    return data;
  }
}

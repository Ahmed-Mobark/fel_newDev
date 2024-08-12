class Forgetpassparam {
  String? email;

  Forgetpassparam({this.email});

  factory Forgetpassparam.fromJson(Map<String, dynamic> json) {
    return Forgetpassparam(email: json['email']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

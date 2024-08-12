class Answerparam {
  String? answer;

  Answerparam({this.answer});

  Answerparam.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    return data;
  }
}


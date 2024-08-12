class UserModel {
  int? statusCode;
  String? message;
  String? error;
  Data? data;

  UserModel({this.statusCode, this.message, this.error, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? birthDate;
  String? shirtName;
  String? email;
  int? shirtNumber;
  String? shirtPhoto;
  String? shirtTextColor;
  String? shirtBGColor;
  int? gender;
  String? profilePhoto;
  int? coinsBalance;
  int? pointsEarned;
  int? bonus;
  int? countryId;
  String? joinDate;
  bool? isGuest;
  List<Items>? items;
  List<Questions>? questions;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.userName,
      this.birthDate,
      this.shirtName,
      this.shirtNumber,
      this.shirtPhoto,
      this.shirtTextColor,
      this.shirtBGColor,
      this.gender,
      this.profilePhoto,
      this.coinsBalance,
      this.pointsEarned,
      this.bonus,
      this.joinDate,
      this.isGuest,
      this.email,
      this.items,
      this.questions});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['owner']['email'];
    userName = json['userName'];
    shirtName = json['shirtName'];
    birthDate = json['birthDate'];
    countryId = json['countryId'];

    // shirtName = json['shirtName'];
    shirtNumber = json['shirtNumber'];
    shirtPhoto = json['shirtPhoto'];
    shirtTextColor = json['shirtTextColor'];
    shirtBGColor = json['shirtBGColor'];
    gender = json['gender'];
    profilePhoto = json['profilePhoto'];
    coinsBalance = json['coinsBalance'];
    pointsEarned = json['pointsEarned'];
    bonus = json['bonus'];
    joinDate = json['joinDate'];
    isGuest = json['isGuest'];

    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['userName'] = this.userName;
    data['birthDate'] = this.birthDate;
    data['shirtName'] = this.shirtName;
    data['shirtNumber'] = this.shirtNumber;
    data['shirtPhoto'] = this.shirtPhoto;
    data['shirtTextColor'] = this.shirtTextColor;
    data['shirtBGColor'] = this.shirtBGColor;
    data['gender'] = this.gender;
    data['profilePhoto'] = this.profilePhoto;
    data['coinsBalance'] = this.coinsBalance;
    data['pointsEarned'] = this.pointsEarned;
    data['bonus'] = this.bonus;
    data['joinDate'] = this.joinDate;
    data['isGuest'] = this.isGuest;

    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? itemId;

  Items({this.itemId});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    return data;
  }
}

class Questions {
  String? id;
  String? answer;

  Questions({this.id, this.answer});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['answer'] = answer;
    return data;
  }
}

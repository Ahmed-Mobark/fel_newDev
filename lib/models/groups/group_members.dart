import 'dart:convert';

class GroupsMembersModel {
  int? id;
  String? username;
  int? roundPoints;
  int? totalPoints;
  int? totalRight;
  int? totalWrong;
  int? groupBonus;
  int? rank;
  User? user;
  String? userId;

  GroupsMembersModel({
    this.id,
    this.username,
    this.roundPoints,
    this.totalPoints,
    this.totalRight,
    this.totalWrong,
    this.groupBonus,
    this.rank,
    this.user,
    this.userId,
  });

  factory GroupsMembersModel.fromJson(Map json) {
    return GroupsMembersModel(
        id: json['id'],
        username: json['username'],
        roundPoints: json['roundPoints'],
        totalPoints: json['totalPoints'],
        totalRight: json['totalRight'],
        totalWrong: json['totalWrong'],
        groupBonus: json['groupBonus'],
        rank: json['rank'],
        userId: json['userId'],
        user: json['user'] != null ? User.fromJson(json['user']) : null);
  }
  static List<GroupsMembersModel> fromJsonStringListToGroupsMembersModelList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<GroupsMembersModel> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(GroupsMembersModel.fromJson(element));
    }
    return listOfUsers;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['totalPoints'] = totalPoints;
    data['totalRight'] = totalRight;
    data['totalWrong'] = totalWrong;
    data['groupBonus'] = groupBonus;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? firstName;
  String? lastName;
  String? profilePhoto;

  User(
      {required this.firstName,
      required this.lastName,
      required this.profilePhoto});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePhoto: json['profilePhoto'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['profilePhoto'] = profilePhoto;
    return data;
  }
}

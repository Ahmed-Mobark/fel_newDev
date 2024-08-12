import 'dart:convert';

class CountryModel {
  int? id;
  String? name;
  String? arName;
  String? code;
  String? flag;

  CountryModel({this.id, this.name, this.arName, this.code, this.flag});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['arName'];
    code = json['code'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['arName'] = arName;
    data['code'] = code;
    data['flag'] = flag;
    return data;
  }

  static List<CountryModel> fromJsonStringListToCountryModelList(
      String ListOfJsonString) {
    Map mapOfJson = jsonDecode(ListOfJsonString);

    List listOfJson = mapOfJson["items"];
    List<CountryModel> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(CountryModel.fromJson(element));
    }
    return listOfUsers;
  }

  static List<CountryModel> fromJsonStringListToStoreModeleList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<CountryModel> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(CountryModel.fromJson(element));
    }
    return listOfUsers;
  }
}

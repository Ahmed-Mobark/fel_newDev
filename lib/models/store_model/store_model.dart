import 'dart:convert';

class StoreModel {
  final String id;
  final String name;
  final String arName;
  final String poName;
  final String esName;
  String photo;
  String? bgColor;
  final int price;
  final int category;

  StoreModel({
    required this.id,
    required this.name,
    required this.poName,
    required this.esName,
    required this.arName,
    required this.photo,
    required this.price,
    this.bgColor,
    required this.category,
  });
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      arName: json['arName'],
      poName: json['poName'],
      esName: json['esName'],
      photo: json['photo'],
      bgColor: json['bgColor'],
      price: json['price'] ?? 0,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['arName'] = arName;
    data['poName'] = poName;
    data['esName'] = esName;
    data['photo'] = photo;
    data['price'] = price;
    data['category'] = category;

    return data;
  }

  static List<StoreModel> fromJsonStringListToStoreModeleList(
    String ListOfJsonString,
  ) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<StoreModel> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(StoreModel.fromJson(element));
    }
    return listOfUsers;
  }

  static List<StoreModel>
      fromJsonStringListToStoreModelListThatContainPurchasedItems(
    String ListOfJsonString,
  ) {
    Map mapOfJson = jsonDecode(ListOfJsonString);
    List listOfJson = mapOfJson["items"];
    List<StoreModel> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(StoreModel.fromJson(element["item"]));
    }
    return listOfUsers;
  }

  static fromStoreModeleListToJsonList(List<StoreModel> ListOfStoreModele) {
    List listOfUsers = [];

    for (var element in ListOfStoreModele) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromStoreModeleListToJsonListString(
    List<StoreModel> ListOfStoreModele,
  ) {
    List listOfStoreModele = [];

    for (var element in ListOfStoreModele) {
      listOfStoreModele.add(element.toJson());
    }
    return jsonEncode(listOfStoreModele);
  }
}

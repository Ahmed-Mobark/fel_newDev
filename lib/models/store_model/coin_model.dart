import 'dart:convert';

import 'package:in_app_purchase/in_app_purchase.dart';

class Coin {
  final String id;
  final String logo;
  final num coinsAmount;
  ProductDetails? productDetails;

  Coin({
    required this.id,
    required this.logo,
    required this.coinsAmount,
    this.productDetails,
  });
  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      coinsAmount: json['coinsAmount'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo'] = logo;
    data['productDetails'] =
        productDetails == null ? {} : getProductDetailsMap(productDetails!);

    return data;
  }

  @override
  String toString() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['logo'] = logo;
    data['productDetails'] =
        productDetails == null ? {} : getProductDetailsMap(productDetails!);

    return data.toString();
  }

  static List getSetOfIds(List<Coin> coinList) {
    Set<String> ids = {};
    Map idsIndex = {};

    for (int i = 0; i < coinList.length; i++) {
      ids.add(coinList[i].id);
      idsIndex[coinList[i].id] = i;
    }
    return [ids, idsIndex];
  }

  static Map getProductDetailsMap(ProductDetails productDetails) {
    return {
      "productId": productDetails.id,
      "productPrice": productDetails.price
    };
  }

  static List<Coin> fromJsonStringListToCoinList(String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<Coin> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(Coin.fromJson(element));
    }
    return listOfUsers;
  }

  static fromCoineListToJsonList(List<Coin> ListOfCoine) {
    List listOfUsers = [];

    for (var element in ListOfCoine) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromCoineListToJsonListString(List<Coin> ListOfCoine) {
    List listOfCoine = [];

    for (var element in ListOfCoine) {
      listOfCoine.add(element.toJson());
    }
    return jsonEncode(listOfCoine);
  }
}

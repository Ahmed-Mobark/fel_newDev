// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football_app/main.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../data_layer/api/api_provider.dart';
import '../../models/store_model/coin_model.dart';
import '../../models/store_model/store_model.dart';
import '../../models/store_model/store_param.dart';

class StoreNotifier extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();
  ScrollController purchaseController = ScrollController();
  ScrollController purchasedGroupPictureController = ScrollController();
  ScrollController storeController = ScrollController();
  StoreParam itemsFilter =
      StoreParam(searchText: "", category: 1, skip: 0, take: 30);
  StoreParam itemsPurchasedFilter =
      StoreParam(searchText: "", category: 1, skip: 0, take: 30);
  StoreParam groupPicturesPurchasedFilter =
      StoreParam(searchText: "", category: 3, skip: 0, take: 30);
  List<StoreModel> products = [];
  List<StoreModel> purchasedItems = [];
  List<StoreModel> purchasedGroupPicture = [];
  List<Coin> coinsList = [];
  Map purschasedIds = {};
  String? profilePic;
  String? tshirtPic;

  setCategoryIndex(int newValue, bool isStore) async {
    if (isStore) {
      itemsFilter.category = newValue + 1;
      itemsFilter.skip = 0;
      getStoreItems(itemsFilter);
    } else {
      itemsPurchasedFilter.category = newValue + 1;
      itemsPurchasedFilter.skip = 0;
      getPurchasedItems(itemsPurchasedFilter);
    }
    notifyListeners();
  }

  searchFilterChange(String newValue) async {
    itemsFilter.searchText = newValue;
    itemsFilter.skip = 0;
    getStoreItems(itemsFilter);
    notifyListeners();
  }

  editeGroupImage(String imageURL, int index) async {
    notifyListeners();
  }

  bool _purchashedPageLoading = true;
  bool get purchashedLoading => _purchashedPageLoading;
  //get all leagues
  bool _storeLoading = true;
  bool get leagueLoading => _storeLoading;

  Future<void> getStoreItems(StoreParam getItems) async {
    log(">>>>>${getItems.toJson()}");
    _storeLoading = true;
    products.clear();
    notifyListeners();
    try {
      products = await ApiProvider(httpClient: Dio()).getStoreItems(getItems);
      _storeLoading = false;
      log(">>>>products>>>${products.last.toJson()}");
      notifyListeners();
    } catch (e) {
      _storeLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPurchasedItems(StoreParam getItems) async {
    _purchashedPageLoading = true;
    notifyListeners();
    try {
      purchasedItems =
          await ApiProvider(httpClient: Dio()).getPurchasedItems(getItems);

      notifyListeners();
      _purchashedPageLoading = false;
      notifyListeners();
    } catch (e) {
      _purchashedPageLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPurchasedGroupPicture(StoreParam getItems) async {
    _purchashedPageLoading = true;
    notifyListeners();
    try {
      purchasedGroupPicture =
          await ApiProvider(httpClient: Dio()).getPurchasedItems(getItems);
      notifyListeners();
      _purchashedPageLoading = false;
      notifyListeners();
    } catch (e) {
      _purchashedPageLoading = false;
      notifyListeners();
    }
  }

  Future<void> buyTheItem(
    String itemId,
    Function(int price) parsedFunction,
  ) async {
    StoreModel response = await ApiProvider(httpClient: Dio()).buyItem(itemId);
    parsedFunction(response.price);
    getPurchasedItemsIds();
    notifyListeners();
  }

  Future<void> setItem(String itemId, bool isTshirt) async {
    if (isTshirt) {
      tshirtPic =
          await ApiProvider(httpClient: Dio()).setItem(itemId, isTshirt);
    } else {
      profilePic =
          await ApiProvider(httpClient: Dio()).setItem(itemId, isTshirt);
    }
    notifyListeners();
  }

  Future<void> updatePurchasedItemsData() async {
    _purchashedPageLoading = true;
    notifyListeners();
    try {
      if (purchasedItems.length > itemsPurchasedFilter.skip + 29 &&
          purchaseController.offset >
              purchaseController.position.maxScrollExtent - 50) {
        itemsPurchasedFilter.skip = purchasedItems.length;
        List<StoreModel> restOfItems = await ApiProvider(httpClient: Dio())
            .getPurchasedItems(itemsPurchasedFilter);
        purchasedItems.addAll(restOfItems);
      }
      _purchashedPageLoading = false;
      notifyListeners();
    } catch (e) {
      _purchashedPageLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePurchasedGroupPictures() async {
    _purchashedPageLoading = true;
    notifyListeners();
    try {
      if (purchasedGroupPicture.length >
              groupPicturesPurchasedFilter.skip + 29 &&
          purchasedGroupPictureController.offset >
              purchasedGroupPictureController.position.maxScrollExtent - 50) {
        groupPicturesPurchasedFilter.skip = purchasedGroupPicture.length;
        List<StoreModel> restOfItems = await ApiProvider(httpClient: Dio())
            .getPurchasedItems(groupPicturesPurchasedFilter);
        purchasedGroupPicture.addAll(restOfItems);
      }
      _purchashedPageLoading = false;
      notifyListeners();
    } catch (e) {
      _purchashedPageLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStoreItemsData() async {
    _storeLoading = true;
    notifyListeners();
    try {
      if (products.length > itemsFilter.skip + 29 &&
          storeController.offset >
              storeController.position.maxScrollExtent - 50) {
        itemsFilter.skip = products.length;
        List<StoreModel> restOfItems =
            await ApiProvider(httpClient: Dio()).getStoreItems(itemsFilter);
        products.addAll(restOfItems);
      }
      _storeLoading = false;
      notifyListeners();
    } catch (e) {
      _storeLoading = false;
      notifyListeners();
    }
  }

  /// Coin related data for purchases

  Future<void> getCoins() async {
    try {
      if (coinsList.isEmpty) {
        coinsList = await ApiProvider(httpClient: Dio()).getCoinsItems();
        InAppPurchase inAppPurchase = InAppPurchase.instance;
        if (await inAppPurchase.isAvailable()) {
          List idsData = Coin.getSetOfIds(coinsList);
          ProductDetailsResponse response =
              await inAppPurchase.queryProductDetails(idsData[0]);
          for (ProductDetails product in response.productDetails) {
            coinsList[idsData[1][product.id]].productDetails = product;
          }
        }
      }
      notifyListeners();
    } catch (e, s) {}
  }

  Future<void> coinsPurchased(
    PurchaseDetails purchaseDetail,
    BuildContext context,
  ) async {
    try {
      Map data = {
        "productId": purchaseDetail.productID,
        "purchaseId": purchaseDetail.purchaseID,
        "transactionDate": purchaseDetail.transactionDate,
        "verificationDateSource": purchaseDetail.verificationData.source,
        "serverVerificationData":
            purchaseDetail.verificationData.serverVerificationData,
        "localVerificationData":
            purchaseDetail.verificationData.localVerificationData,
        'isIos': Platform.isIOS,
      };
      await ApiProvider(httpClient: Dio()).coinsPurchased(data);
      AuthNotifier authNotifier =

          ///TODO: put context
          //context
          Provider.of<AuthNotifier>(
        navigatorKey.currentContext!,
        listen: false,
      );
      await authNotifier.getUserData();
      notifyListeners();
    } catch (e) {
      // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      //   errorSnackBar(e.toString()),
      // );
    }
  }

  void getPurchasedItemsIds() async {
    purschasedIds = await ApiProvider(httpClient: Dio()).getPurchasedItemsIds();
    notifyListeners();
  }

  Future<List> setGroupImage(String id, String groupID) async {
    _purchashedPageLoading = true;
    notifyListeners();
    // try {
    Map data = {"itemId": id, "groupId": groupID};
    List didSucceed =
        await ApiProvider(httpClient: Dio()).setMyGroupImage(data);
    _purchashedPageLoading = false;
    notifyListeners();
    return didSucceed;
    // } catch (e) {
    //   _purchashedPageLoading = false;
    //   // notifyListeners();
    //   return false;
    // }
  }
}

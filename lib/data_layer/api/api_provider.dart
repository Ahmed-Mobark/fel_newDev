// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unused_local_variable, unused_catch_stack
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:football_app/data_layer/dio_interceptor.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/helpers/vars.dart';
import 'package:football_app/main.dart';
import 'package:football_app/models/groups/answerofchallengeparam.dart';
import 'package:football_app/models/groups/explore_groups_model.dart';
import 'package:football_app/models/groups/get_group_by_id_model.dart';
import 'package:football_app/models/groups/group_matches_model.dart';
import 'package:football_app/models/groups/group_members.dart';
import 'package:football_app/models/groups/my_groups_model.dart';
import 'package:football_app/models/groups/predict_group_match_param.dart';
import 'package:football_app/models/groups/upsert_group_param.dart';
import 'package:football_app/models/groups/user_group_model.dart';
import 'package:football_app/models/groups/user_groups_ids_model.dart';
import 'package:football_app/models/home/admin_challenges_model.dart';
import 'package:football_app/models/home/home_page_model.dart';
import 'package:football_app/models/home/user_model.dart';
import 'package:football_app/models/leagues/league_lookup_model.dart';
import 'package:football_app/models/signin/apple_signin_param.dart';
import 'package:football_app/models/signin/country_model.dart';
import 'package:football_app/models/signin/guest_model.dart';
import 'package:football_app/models/signin/signin_model.dart';
import 'package:football_app/models/signin/singin_param.dart';
import 'package:football_app/models/signin/socail_param.dart';
import 'package:football_app/models/signup_model/signup_model.dart';
import 'package:football_app/models/signup_model/signup_param.dart';
import 'package:football_app/models/signup_model/verify_email_param.dart';
import 'package:football_app/models/transactions/transactions_model.dart';
import 'package:football_app/models/update_profile/update_profile_model.dart';
import 'package:football_app/models/update_profile/update_profile_param.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart' as getx;
import 'package:get/state_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../models/answerquestion/answerquetions_param.dart';
import '../../models/forgetpassword/forgetpass_param.dart';
import '../../models/groups/answerofadminchallengeparam.dart';
import '../../models/store_model/coin_model.dart';
import '../../models/store_model/store_model.dart';
import '../../models/store_model/store_param.dart';
import '../../presentation/notifiers/bottom_nav_notifier.dart';
import '../../presentation/screens/groups/group_details_screen.dart';

class ApiProvider {
  ApiProvider({required this.httpClient}) {
    httpClient.interceptors.add(DioInterceptors(httpClient));
    context = Get.context!;
    options = Options(
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': context.locale.languageCode,
      },
    );
    if (kDebugMode) httpClient.interceptors.add(_logger);
  }

  // Logger
  final PrettyDioLogger _logger = PrettyDioLogger(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    error: true,
  );

  String baseUrl = Connection.API_URL;
  final Dio httpClient;

  late BuildContext context;

  late Options options;

  Future<String?> getToken() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    String? token = await rxPrefs.getString('token');
    String? guestToken = await rxPrefs.getString('guestToken');

    if (token == null) {
      return guestToken.toString();
    } else {
      return token.toString();
    }
  }

  Future<String?> getFCMToken() async {
    String? fcmToken;
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.getToken().then((token) {
      fcmToken = token;
    });
    return fcmToken;
  }

//updateFcmToken
  Future<void> updateFcmToken(String fcm) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/fcmtoken',
        data: {
          'fcmToken': fcm,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );

      log('signup status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {}
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

//signup
  Future<SignupModel> signup(SignupParam param) async {
    try {
      final fcm = await getFCMToken();
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/signup/credential',
        options: options,
        data: {
          ...param.toJson(),
          'fcmToken': fcm,
        },
      );
      log('signup status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        SignupModel resp = SignupModel.fromJson(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(
          e.response?.data['message'] is List
              ? e.response?.data['message'].first
              : e.response?.data['message'],
        ),
      );

      return e.response?.data['message'];
    }
  }

//signin
  Future<SigninModel> signin(SigninParam param) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    try {
      final fcm = await getFCMToken();
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/login/credential',
        options: options,
        data: {
          ...param.toJson(),
          'fcmToken': fcm,
        },
      );
      log('signin status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );

        final validMap = json.decode(json.encode(response.data));

        SigninModel resp = SigninModel.fromJson(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

//logout
  Future<String> logout() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}profile/logout',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('logout status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.remove('token');
        rxPrefs.remove('guestToken');
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

//logout
  Future<String> testLinks() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}group/sharegroup',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('logout status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.remove('token');
        rxPrefs.remove('guestToken');
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

//removeAccount
  Future<String> removeAccount() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      Response<dynamic> response = await httpClient.delete(
        '${baseUrl}profile/removeaccount',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('removeAccount status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.remove('token');
        rxPrefs.remove('guestToken');
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //Change Groub
  Future<UserGroupModel> changeGroub(String leagueId, id) async {
    log(leagueId);
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/changeleague',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: jsonEncode({
          "leagueId": int.parse(leagueId),
          "groupId": id,
        }),
      );
      log('resend status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        //handel Navigator
        log("mobbbbbb>>${response.data}");
        final validMap = json.decode(json.encode(response.data));

        UserGroupModel resp = UserGroupModel.fromJson(validMap);
        GroupNotifier? groupNotifier;

        groupNotifier = Provider.of<GroupNotifier>(context, listen: false);
        groupNotifier.groupMatches(validMap['groupId']);
        groupNotifier.getGroupMembers(validMap['groupId']);
        groupNotifier.getRoundGroupMembers(validMap['groupId']);
        groupNotifier.setLeagueIdForGroupScreen(int.parse(validMap['groupId']));
        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //signin
  Future<SigninModel> resendCode(String userId) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/signup/resendcode',
        options: options,
        data: {"userId": userId},
      );
      log('resend status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );

        final validMap = json.decode(json.encode(response.data));

        SigninModel resp = SigninModel.fromJson(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

// //logout
  Future<String> logoutt() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}profile/logout',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('logout status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.remove('token');
        rxPrefs.remove('guestToken');
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message'][0]),
      );

      return e.response?.data['message'];
    }
  }

  //signin
  Future<SigninModel> resendCodee(String userId) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/signup/resendcode',
        options: options,
        data: {"userId": userId},
      );

      log('resend status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );

        final validMap = json.decode(json.encode(response.data));

        SigninModel resp = SigninModel.fromJson(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message'][0]),
      );

      return e.response?.data['message'];
    }
  }

  Future anwerquestion(Answerparam param) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}mainpage/answer',
        options: options,
        data: param,
      );

      log('signin status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );

        final validMap = json.decode(json.encode(response.data));

        SigninModel resp = SigninModel.fromJson(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //signin
  Future forgetpassword(Forgetpassparam param) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/forgetpassword',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: param,
      );

      log('signin status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          errorSnackBar(tr("check_email_change_password")),
        );
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar("something go wrong"),
      );
      return e.response?.data['message'];
    }
  }

  Future<List<CountryModel>> getCountries() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}country/all',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // response.data;
        final validMap = json.encode(response.data);

        List<CountryModel> listOfUsers = [];

        for (var element in response.data) {
          listOfUsers.add(CountryModel.fromJson(element));
        }
        return listOfUsers;

        // return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return [];
    }
  }

//signin

  // this API is responsible for getting the items available for purschase
  // as shirts , logos and backGround image
  //
  Future<List<StoreModel>> getStoreItems(StoreParam param) async {
    log(">>>>$param");
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}Item/all',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: param,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.encode(response.data);
        List<StoreModel> resp =
            StoreModel.fromJsonStringListToStoreModeleList(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return [
        StoreModel(
          id: "",
          name: "",
          arName: "",
          poName: "",
          esName: "",
          photo: "",
          bgColor: "",
          price: 0,
          category: 0,
        ),
      ];
    }
  }

  Future<List<StoreModel>> getPurchasedItems(StoreParam param) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}profile/items',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: param,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        response.data;
        final validMap = json.encode(response.data);
        List<StoreModel> resp = StoreModel
            .fromJsonStringListToStoreModelListThatContainPurchasedItems(
          validMap,
        );

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      log(">>>>>>$e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return [];
    }
  }

  Future<MyGroupModel> getMyGroups() async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}profile/groups',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "skip": 0,
          "take": 10,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        MyGroupModel resp = MyGroupModel.fromJson(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return e.response?.data['message'];
    }
  }

  Future<List> setMyGroupImage(Map data) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/updategroupphoto',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return [true, response.data];
      }
      return [false, ""];
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return [false, ""];
    }
  }

  Future<MyTransactionsModel> getTransactions() async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}profile/transactions',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "skip": 0,
          "take": 10,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        MyTransactionsModel resp = MyTransactionsModel.fromJson(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return e.response?.data['message'];
    }
  }

  Future<List<Coin>> getCoinsItems() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}coinoffer/all',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        response.data;
        final validMap = json.encode(response.data);
        List<Coin> resp = Coin.fromJsonStringListToCoinList(validMap);

        return resp;
      }
      return response.data;
    } on DioError catch (e, s) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return [];
    } catch (e, s) {
      return [];
    }
  }

  Future<void> coinsPurchased(Map data) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}coinoffer/buy',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar(tr('Coins Purchased')),
        );
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
    }
  }

  Future<Map> getPurchasedItemsIds() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}item/useritemsids',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        response.data;
        final validMap = json.encode(response.data);
        List itemsIdsList = jsonDecode(validMap);
        Map itemIds = {};

        for (Map itemId in itemsIdsList) {
          itemIds[itemId["id"]] = true;
        }
        // List<Coin> resp = Coin.fromJsonStringListToCoinList(validMap);
        return itemIds;
      }
      return response.data;
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return {};
    }
  }

  Future<StoreModel> buyItem(String itemId) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}Item/purchase',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {"itemId": itemId},
      );
      debugPrint(response.data.toString());
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   final validMap = json.encode(response.data);
      //   debugPrint(validMap);
      //   // List<StoreModel> resp = StoreModel.fromJsonStringListToStoreModeleList(validMap);

      //   // return resp;
      // }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        successSnackBar("تم شراء المنتج"),
      );
      return StoreModel.fromJson(response.data);
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      // return [StoreModel(id: "", name: "", arName: "", photo: "", price: 0, category: 0)];
      return StoreModel(
        id: "id",
        name: "name",
        arName: "arName",
        poName: "poName",
        esName: "esName",
        photo: "photo",
        bgColor: null,
        price: 0,
        category: 0,
      );
    }
  }

  Future<String?> changeLang(String lang) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}profile/changelanguage',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {"language": lang},
      );
      log("response.data.language>>>");
      log(response.data.toString());
      log(response.toString());

      // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      //   successSnackBar("تم التغير"),
      // );
      return response.data.toString();
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      // return [StoreModel(id: "", name: "", arName: "", photo: "", price: 0, category: 0)];
    }
    return null;
  }

  Future<String?> setItem(String itemId, bool isTshirt) async {
    try {
      Response<dynamic> response = await httpClient.post(
        isTshirt
            ? '${baseUrl}profile/updateshirtphoto'
            : '${baseUrl}profile/updateprofilephoto',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {"itemId": itemId},
      );
      debugPrint("response.data.toString()");
      debugPrint(response.data.toString());

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        successSnackBar("تم التغير"),
      );
      return response.data.toString();
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      // return [StoreModel(id: "", name: "", arName: "", photo: "", price: 0, category: 0)];
    }
    return null;
  }

//kick ost the user
  kickOsto() {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    rxPrefs.remove('token');
    rxPrefs.remove('guestToken');
    // rxPrefs.remove('refreshToken');
    getx.Get.offAndToNamed('/login');
  }

//refresh token
  Future<SigninModel> refreshToken() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    String? refreshToken = await rxPrefs.getString('refreshToken');
    try {
      final fcm = await getFCMToken();
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/refreshtoken',
        data: {
          "refreshToken": refreshToken,
          'fcmToken': fcm,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $refreshToken',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('refresh token status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        SigninModel resp = SigninModel.fromJson(validMap);
        await rxPrefs.setString('token', resp.data?.token);
        await rxPrefs.setString('refreshToken', resp.data?.refreshToken);
        return resp;
      } else if (response.statusCode == 401) {
        kickOsto();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        kickOsto();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return e.response?.data['message'];
    }
  }

//home page data
  Future<MainPageModel> getHomePageData() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}mainpage/detail',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      //  log('getHomePageData status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        MainPageModel resp = MainPageModel.fromJson(validMap);

        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getHomePageData();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getHomePageData();
      }
      final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());

      bool isVisteror = (await rxPrefs.getBool('isVis'))!;

      if (isVisteror == false) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          errorSnackBar(e.response?.data['message']),
        );
      }
      return e.response?.data['message'];
    }
  }

//get user data
  Future<UserModel> getUserData() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    final String? token = await rxPrefs.getString('token');
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}profile/detail',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('get user data status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        UserModel resp = UserModel.fromJson(validMap);

        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getUserData();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getUserData();
      }

      return e.response?.data['message'];
    }
  }

  //update user photo
  Future<void> updateUserPhoto(String path) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    final String? token = await rxPrefs.getString('token');
    var headers = {
      'Authorization': 'Bearer ${await getToken()}',
      'Accept-Language': context.locale.languageCode,
    };
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${baseUrl}profile/update/userphoto'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          '/Users/nadsoft-macbook-air/Downloads/have_button.png',
        ),
      );
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      log('update user photo =${response.statusCode}');
      if (response.statusCode == 401) {
        await refreshToken();
        updateUserPhoto(path);
      }
    } on DioError catch (e) {
      return e.response?.data['message'];
    }
  }

//update profile photo
  Future<void> updateProfilePhoto(String path) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    final String? token = await rxPrefs.getString('token');
    var headers = {
      'Authorization': 'Bearer ${await getToken()}',
      'Accept-Language': context.locale.languageCode,
    };
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${baseUrl}profile/update/profilephoto'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          path,
        ),
      );
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      log('update profile photo =${response.statusCode}');
      if (response.statusCode == 401) {
        await refreshToken();
        updateProfilePhoto(path);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // updateProfile
  Future<UpdateProfileModel> updateProfile(UpdateProfileParam param) async {
    try {
      Response<dynamic> response = await httpClient.put(
        '${baseUrl}profile/update/data',
        data: {
          "firstName": "${param.firstName}",
          "lastName": "${param.lastName}",
          "birthDate": "${param.birthDate}",
          "shirtName": "${param.shirtName}",
          "shirtNumber": param.shirtNumber,
          "gender": param.gender,
          "countryId": param.countryId,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('update profile status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        UpdateProfileModel resp = UpdateProfileModel.fromJson(validMap);

        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getAllLeagues();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getAllLeagues();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

//get all leagues
  Future<List<LeagueLookupModel>> getAllLeagues() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}league/lookups',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('leagues status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> validMap = json.decode(json.encode(response.data));
        final resp =
            validMap.map((json) => LeagueLookupModel.fromJson(json)).toList();
        log(resp.toString());
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getAllLeagues();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getAllLeagues();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

//answer question
  Future<void> answerQuestion(String myAnwser) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}mainpage/answer',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'answer': myAnwser,
        },
      );
      log('answer question status code = ${response.statusCode}');
      if (response.statusCode == 401) {
        await refreshToken();
        answerQuestion(myAnwser);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        answerQuestion(myAnwser);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return e.response?.data['message'];
    }
  }

  Future<GetGroupByIdModel> getGroupById(String id) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/detail',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'id': id,
        },
      );
      log('getGroupById status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        GetGroupByIdModel resp = GetGroupByIdModel.fromJson(validMap);

        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getGroupById(id);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getGroupById(id);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //get all groups
  Future<ExploreGroupModel> getExploreGroups(GroupFilter groupFilter) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/all',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: groupFilter.toJson(),
      );

      log('getExploreGroups status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final validMap = json.decode(json.encode(response.data));
        ExploreGroupModel resp = ExploreGroupModel.fromJson(validMap);
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getExploreGroups(groupFilter);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getExploreGroups(groupFilter);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //get all groups
  Future<bool> leaveGroups(String id) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/leave',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
          },
        ),
        data: {"groupId": id},
      );
      log('leaveGroups status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            successSnackBar(tr("you have left")),
          );
        } catch (e) {
          return true;
        }
        return true;
      } else if (response.statusCode == 401) {
        await refreshToken();
        return await leaveGroups(id);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        return await leaveGroups(id);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      return false;
    }
  }

  //get group members
  Future<List<GroupsMembersModel>> getGroupMembers(String id) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/members',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "groupId": id,
        },
      );
      log('get all members status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final resp =
            GroupsMembersModel.fromJsonStringListToGroupsMembersModelList(
          json.encode(response.data),
        );
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getGroupMembers(id);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getGroupMembers(id);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  Future<List<GroupsMembersModel>> getGroupRoundMembers(String id) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/roundmembers',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "groupId": id,
        },
      );
      log('get all members status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> validMap = json.decode(json.encode(response.data));
        final resp =
            GroupsMembersModel.fromJsonStringListToGroupsMembersModelList(
          json.encode(response.data),
        );
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getGroupRoundMembers(id);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getGroupRoundMembers(id);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //visitor signin
  Future<GuestModel> visitorSignIn() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}authentication/login/visitor',
        options: options,
      );
      log('visitor signin status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );
        rxPrefs.setBool(
          'isVis',
          true,
        );
        final validMap = json.decode(json.encode(response.data));
        GuestModel resp = GuestModel.fromJson(validMap);

        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        visitorSignIn();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        visitorSignIn();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //get group members
  Future<List<UserGroupModel>> getUserGroups(
    GroupFilter groupFilterPramater,
  ) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/usergroups',
        options: Options(
          headers: {
            // 'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: groupFilterPramater,
      );

      log('getUserGroups status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> validMap = jsonDecode(jsonEncode(response.data))["data"];
        List<UserGroupModel> resp =
            UserGroupModel.fromUserGroupJsonToUserGroupModel(validMap);

        log("userrrrrrrGroubbbb>>>${resp.toString()}");
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getUserGroups(groupFilterPramater);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getUserGroups(groupFilterPramater);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(errorSnackBar('${e.response?.statusMessage}'));

      return e.response?.data['message'];
    }
  }

  Future<List<UserGroupIdsModel>> getUserGroupsIds() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}group/usergroupsids',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('getUserGroupsIds status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> validMap = json.decode(json.encode(response.data));
        final resp =
            validMap.map((json) => UserGroupIdsModel.fromJson(json)).toList();
        log("redddddfffffss>>>>>${resp.toList().toString()}");
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getUserGroupsIds();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getUserGroupsIds();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/join',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "groupId": groupId,
        },
      );
      log('joinGroup status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("mobarkkkkk>>>>>>${response.data.toString()}");
        var groupData = UserGroupModel.fromJson(response.data);

        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar(tr('Group Joined successfully')),
        );
        Get.to(
          () => ShowCaseWidget(
            builder: Builder(
              builder: (context) => UserGroupDetailsScreen(
                group: groupData,
                groupIndex: 0,
              ),
            ),
          ),
        );
        
      } else if (response.statusCode == 401) {
        await refreshToken();
        joinGroup(groupId);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        joinGroup(groupId);
      }
      // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      //   errorSnackBar('${e.response?.statusMessage}'),
      // );
      Fluttertoast.showToast(msg: e.response?.data['message'] ?? '');

      return e.response?.data['message'];
    }
  }

  Future<List> getAllUserGroups() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}group/usergroupsids',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
          },
        ),
      );
      log('joinGroup status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List groupIDSList = response.data;

        return groupIDSList;
      }

      return [];
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response?.data}'),
      );

      return [];
    }
  }

  Future<void> joinPrivateGroup(String groupCode) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/join/private',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "groupCode": groupCode,
        },
      );
      log('JoinPrivateGroupModel status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar(tr('Group Joined successfully')),
        );
        Provider.of<BottomNavigationBarNotifier>(context, listen: true)
            .setNavbarIndex(2);
      } else if (response.statusCode == 401) {
        await refreshToken();
        joinPrivateGroup(groupCode);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        joinPrivateGroup(groupCode);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  Future<bool> upsertGroup(UpsertGroupParam param) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "id": param.id,
          "name": param.name,
          "description": param.description,
          "isPrivate": param.isPrivate,
          "maxMembers": param.maxMembers,
          "leagueId": param.leagueId,
        },
      );
      log('upsertGroup status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        await refreshToken();
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          errorSnackBar('${response.data['message']}'),
        );
        return false;
      }
      return false;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          errorSnackBar('${e.response!.data['message']}'),
        );
        return await upsertGroup(param);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return false;
      // return e.response?.data['message'];
    }
  }

  //adminChallenges
  Future<List<AdminChallengesModel>> adminChallenges() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}adminchallenge/allweek',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> validMap = json.decode(json.encode(response.data));
        final resp = validMap
            .map((json) => AdminChallengesModel.fromJson(json))
            .toList();
        log('admin challenges status code = ${response.statusCode}');
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        adminChallenges();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        adminChallenges();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    } catch (e, s) {
      return [];
    }
  }

  //group matches
  Future<List<GroupMatchesModel>> getGroupMatches(String groupId) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/matches',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "groupId": groupId,
        },
      );
      log('group matches status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> validMap = json.decode(json.encode(response.data));
        final resp =
            validMap.map((json) => GroupMatchesModel.fromJson(json)).toList();
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getGroupMatches(groupId);
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getGroupMatches(groupId);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  Future<void> predictGroupMatch(PredictGroupMatchParam param) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/predict',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'groupId': param.groupId,
          'matchId': param.matchId,
          'bouns': param.bouns,
          'homeGoals': param.homeGoals,
          'awayGoals': param.awayGoals,
        },
      );
      log('predictGroupMatch status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar(tr('Prediction Sent')),
        );
      } else if (response.statusCode == 401) {
        await refreshToken();
        predictGroupMatch(param);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        predictGroupMatch(param);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return e.response?.data['message'];
    }
  }

//verify email
  Future<dynamic> verifyEmail(VerifyEmailParam param) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/signup/verifyemail',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: param.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        //   successSnackBar(kCheckMail),
        // );

        final validMap = json.decode(json.encode(response.data));
        return validMap;
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {}
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return e.response?.data['message'];
    }
  }

  //answer challenge
  Future<void> answersofadminchallenge(
    AnswersofadminchallengeParam param,
    GroupNotifier groupsNotifier,
  ) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}adminchallenge/useranswer',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'challengeId': param.challengeId,
          'answers': param.answers,
          'homeGoals': param.homeGoals,
          'awayGoals': param.awayGoals,
          'bonus': param.bonus,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        groupsNotifier.resetValues();
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar(tr('Prediction Sent')),
        );

        // Get.offAndToNamed('/welcome');
        Get.back();
      } else if (response.statusCode == 401) {
        await refreshToken();
        answersofadminchallenge(param, groupsNotifier);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        answersofadminchallenge(param, groupsNotifier);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return e.response?.data['message'];
    }
  }

  //answer challenge
  Future<bool> answerChallenge(
    AnswersofchallengeParam param, {
    bool fromChallenges = false,
    GroupMatchesModel? groupMatchModel,
    UserGroupModel? userGroupModel,
  }) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}group/predict',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'groupId': param.groupId,
          'matchId': param.matchId,
          'homeGoals': param.homeGoals,
          'awayGoals': param.awayGoals,
          'bouns': param.bonus,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar(tr('Prediction Sent')),
        );
        if (fromChallenges) {
          // Navigator.pop(navigatorKey.currentContext!);
        } else {
          Get.offAndToNamed('/welcome');
        }
        return true;
      } else if (response.statusCode == 401) {
        await refreshToken();
        answerChallenge(param);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        answerChallenge(param);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return false;
    }
    return false;
  }

//forget password
  Future<void> forgetPassword(String email) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/forgetpassword',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'email': email,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar(kCheckMail),
        );
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {}
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return e.response?.data['message'];
    }
  }

//google sign in
  Future<SigninModel> googleSignIn(SocialParam param) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      final fcm = await getFCMToken();
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/login/google',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'token': param.token,
          'isIos': Platform.isIOS,
          'fcmToken': fcm,
        },
      );
      // print('google sign in  status code = ${response.statusCode}');
      // log(response.data);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      //     successSnackBar('login Done'),
      //   );
      // } else if (response.statusCode == 401) {
      //   await refreshToken();
      //   // googleSignIn(param);
      // }
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );

        final validMap = json.decode(json.encode(response.data));
        SigninModel resp = SigninModel.fromJson(validMap);
        return resp;
      }
      return response.data;
    } on DioError catch (e, s) {
      if (e.response?.statusCode == 401) {
        // await refreshToken();
        // googleSignIn(param);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return e.response?.data['message'];
    }
  }

//facebook login
  Future<SigninModel> facebookLogin(SocialParam param) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      final fcm = await getFCMToken();
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/login/facebook',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'accessToken': param.token,
          'fcmToken': fcm,
        },
      );
      log('facebook sign in  status code = ${response.statusCode}');
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      //     successSnackBar('login Done'),
      //   );
      // } else if (response.statusCode == 401) {
      //   await refreshToken();
      //   //  facebookLogin(param);
      // }
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );

        final validMap = json.decode(json.encode(response.data));
        SigninModel resp = SigninModel.fromJson(validMap);
        return resp;
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        //facebookLogin(param);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return e.response?.data['message'];
    }
  }

//apple sign in
  Future<SigninModel> appleSignin(AppleSigninParam param) async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();

    try {
      final fcm = await getFCMToken();
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}authentication/login/apple',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          'IdentityToken': param.identityToken,
          'UserIdentifier': param.userIdentifier,
          'Email': param.email,
          'FamilyName': param.familyName,
          'GivenName': param.givenName,
          'fcmToken': fcm,
        },
      );
      log('apple sign in  status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        rxPrefs.setString(
          'expDate',
          DateTime.now().add(const Duration(hours: 24)).toString(),
        );

        final validMap = json.decode(json.encode(response.data));
        SigninModel resp = SigninModel.fromJson(validMap);
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar('login Done'),
        );
        return resp;
      } else if (response.statusCode == 401) {
        await refreshToken();
        // appleSignin(param);
        return response.data;
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        // appleSignin(param);
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar('${e.response!.data['message']}'),
      );
      return e.response?.data['message'];
    }
  }

  Future<String?> sendSupport(String title, String desc, int type) async {
    try {
      Response<dynamic> response = await httpClient.post(
        '${baseUrl}support',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            //'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
        data: {
          "title": title,
          "description": desc,
          "type": type,
        },
      );
      debugPrint("response.data.toString()");
      debugPrint(response.data.toString());

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        successSnackBar(tr("done")),
      );
      return response.data.toString();
    } on DioError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );
      // return [StoreModel(id: "", name: "", arName: "", photo: "", price: 0, category: 0)];
    }
    return null;
  }

  //App Terms
  Future<String> getAppTerms() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}mainpage/termofuse',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('App Terms status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getAppTerms();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getAppTerms();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }

  //Privacy Policy
  Future<String> getPrivacyPolicy() async {
    try {
      Response<dynamic> response = await httpClient.get(
        '${baseUrl}mainpage/privacypolicy',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            'Accept-Language': context.locale.languageCode,
          },
        ),
      );
      log('Privacy Policy status code = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 401) {
        await refreshToken();
        getPrivacyPolicy();
      }
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await refreshToken();
        getPrivacyPolicy();
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.response?.data['message']),
      );

      return e.response?.data['message'];
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football_app/data_layer/api/api_provider.dart';
import 'package:football_app/models/home/admin_challenges_model.dart';
import 'package:football_app/models/home/home_page_model.dart';

class HomeNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  MainPageModel mainPageModel = MainPageModel();
  getHomePageData() async {
    try {
      _isLoading = true;
      await ApiProvider(httpClient: Dio())
          .getHomePageData()
          .then((MainPageModel value) {
        mainPageModel = value;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

//answer questons
  bool _answerLoading = false;
  bool get answerLoading => _answerLoading;
  answerQues(String answer) async {
    try {
      _answerLoading = true;
      notifyListeners();
      await ApiProvider(httpClient: Dio()).answerQuestion(answer).then((value) {
        getHomePageData();
        log('question deleted...');
        _answerLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _answerLoading = false;
      notifyListeners();
    }
  }

  //admin challenges
  //answer questons
  bool _adminChallengesLoading = false;
  bool get adminChallengesLoading => _adminChallengesLoading;
  List<AdminChallengesModel> adminChallengesModel = [];
  getAdminChallenges() async {
    try {
      _adminChallengesLoading = true;
      await ApiProvider(httpClient: Dio()).adminChallenges().then((value) {
        adminChallengesModel = value;
        _adminChallengesLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _adminChallengesLoading = false;
      notifyListeners();
    }
  }
}

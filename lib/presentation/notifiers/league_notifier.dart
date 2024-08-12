import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football_app/data_layer/api/api_provider.dart';
import 'package:football_app/models/leagues/league_lookup_model.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';

import '../../models/groups/answerofadminchallengeparam.dart';

class LeagueNotifier extends ChangeNotifier {
  int? leagueIndex = 1;

  //get all leagues
  bool _leagueLoading = false;
  bool get leagueLoading => _leagueLoading;
  List<LeagueLookupModel> leaguesModel = [];
  List<LeagueLookupModel> leaguesModelForGroupScreen = [];
  getLeagueData(String logoURL) async {
    LeagueLookupModel leagueLookupModel =
        LeagueLookupModel(arName: "الكل", name: "all", id: 0, logo: logoURL);
    try {
      _leagueLoading = true;
      notifyListeners();
      await ApiProvider(httpClient: Dio())
          .getAllLeagues()
          .then((List<LeagueLookupModel> value) {
        leaguesModel = value;
        leaguesModelForGroupScreen = [leagueLookupModel];
        leaguesModelForGroupScreen.addAll(value);
        _leagueLoading = false;
        notifyListeners();
        log(leaguesModel[0].id.toString());
      });
    } catch (e) {
      _leagueLoading = false;
      notifyListeners();
    }
  }

  List<LeagueLookupModel> leaguesModelForChangGroupScreen = [];
  getChangeLeagueData(String logoURL) async {
    try {
      _leagueLoading = true;
      notifyListeners();
      await ApiProvider(httpClient: Dio())
          .getAllLeagues()
          .then((List<LeagueLookupModel> value) {
        leaguesModel = value;
        leaguesModelForChangGroupScreen = [];
        leaguesModelForChangGroupScreen.addAll(value);
        _leagueLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _leagueLoading = false;
      notifyListeners();
    }
  }

  answerofadmin(
    AnswersofadminchallengeParam param,
    GroupNotifier groupsNotifier,
  ) async {
    try {
      _leagueLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio())
          .answersofadminchallenge(param, groupsNotifier)
          .then((value) async {
        _leagueLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _leagueLoading = false;
      notifyListeners();
    }
  }
}

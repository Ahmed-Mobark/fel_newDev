import 'dart:ui';

import 'package:football_app/models/groups/match_prediction_model.dart';

class GroupMatchesModel {
  int? id;
  String? startDate;
  String? status;
  String? homeTeam;
  String? arHomeTeam;
  String? homeLogo;
  String? homeColor;
  int? homeGoals;
  String? awayTeam;
  String? arAwayTeam;
  String? awayLogo;
  String? awayColor;
  int? awayGoals;
  String? leagueLogo;
  int? leagueId;
  String? timezone;
  String? round;
  bool? isCompleted;
  List<MatchPredictionModel>? predictions;

  GroupMatchesModel({
    this.id,
    this.startDate,
    this.status,
    this.homeTeam,
    this.arHomeTeam,
    this.homeLogo,
    this.homeColor,
    this.homeGoals,
    this.awayTeam,
    this.arAwayTeam,
    this.awayLogo,
    this.awayColor,
    this.awayGoals,
    this.leagueLogo,
    this.leagueId,
    this.timezone,
    this.round,
    this.isCompleted,
    this.predictions,
  });

  GroupMatchesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    status = json['status'];
    homeTeam = json['homeTeam'];
    arHomeTeam = json['arHomeTeam'];
    homeLogo = json['homeLogo'];
    homeColor = json['homeColor'];
    homeGoals = json['homeGoals'];
    awayTeam = json['awayTeam'];
    arAwayTeam = json['arAwayTeam'];
    awayLogo = json['awayLogo'];
    awayColor = json['awayColor'];
    awayGoals = json['awayGoals'];
    leagueLogo = json['leagueLogo'];
    leagueId = json['leagueId'];
    timezone = json['timezone'];
    round = json['round'];
    isCompleted = json['isCompleted'];
    if (json['predictions'] != null) {
      predictions = <MatchPredictionModel>[];
      json['predictions'].forEach((v) {
        predictions!.add(MatchPredictionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startDate'] = startDate;
    data['status'] = status;
    data['homeTeam'] = homeTeam;
    data['homeLogo'] = homeLogo;
    data['homeGoals'] = homeGoals;
    data['awayTeam'] = awayTeam;
    data['awayLogo'] = awayLogo;
    data['awayGoals'] = awayGoals;
    data['leagueLogo'] = leagueLogo;
    data['leagueId'] = leagueId;
    data['isCompleted'] = isCompleted;
    if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  DateTime stringToDate(String dateString) {
    // Split the input string into year, month, and day components
    final dateComponents = dateString.split('-');

    // Check if there are exactly three components (year, month, and day)
    if (dateComponents.length == 3) {
      try {
        // Parse the components and create a DateTime object
        final year = int.parse(dateComponents[0]);
        final month = int.parse(dateComponents[1]);
        final day = int.parse(dateComponents[2].split('T').first.toString());

        // Check if the values are within valid ranges
        if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
          return DateTime(year, month, day);
        } else {
          throw Exception("Invalid month or day value");
        }
      } catch (e) {
        throw Exception("Invalid date format");
      }
    } else {
      throw Exception("Invalid date format");
    }
  }

  static Color toColor(String color) {
    color = color.replaceAll('#', '');
    color = "0xFF$color";
    return Color(int.parse(color));
  }
}

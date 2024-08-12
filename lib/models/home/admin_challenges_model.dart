import 'package:flutter/material.dart';

class AdminChallengesModel {
  String? id;
  List<Questions>? questions;
  bool? isWinLoseQuestion;
  Matchgoal? match;
  List<UserAnswer>? usersAnswers;

  AdminChallengesModel({
    this.id,
    this.questions,
    this.isWinLoseQuestion,
    this.match,
    this.usersAnswers,
  });
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

  AdminChallengesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    isWinLoseQuestion = json['isWinLoseQuestion'];
    match = json['match'] != null ? Matchgoal.fromJson(json['match']) : null;
    if (json['usersAnswers'] != null) {
      usersAnswers = <UserAnswer>[];
      json['usersAnswers'].forEach((v) {
        usersAnswers!.add(UserAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    data['isWinLoseQuestion'] = isWinLoseQuestion;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    if (usersAnswers != null) {
      data['usersAnswers'] = usersAnswers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Matchgoal {
  int? id;
  String? startDate;
  String? status;
  String? homeTeam;
  String? homeColor;
  String? homeLogo;
  int? homeGoals;
  String? awayTeam;
  String? awayColor;
  String? awayLogo;
  int? awayGoals;
  String? leagueLogo;
  int? leagueId;
  bool? isCompleted;

  Matchgoal({
    this.id,
    this.startDate,
    this.status,
    this.homeTeam,
    this.homeColor,
    this.homeLogo,
    this.homeGoals,
    this.awayTeam,
    this.awayColor,
    this.awayLogo,
    this.awayGoals,
    this.leagueLogo,
    this.leagueId,
    this.isCompleted,
  });

  Matchgoal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    status = json['status'];

    homeTeam = json['homeTeam'];

    homeColor = json['homeColor'];
    homeLogo = json['homeLogo'];
    homeGoals = json['homeGoals'] ?? 0;

    awayTeam = json['awayTeam'];

    awayColor = json['awayColor'];

    awayLogo = json['awayLogo'];

    awayGoals = json['awayGoals'] ?? 0;

    leagueLogo = json['leagueLogo'];
    leagueId = json['leagueId'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startDate'] = startDate;
    data['status'] = status;
    data['homeTeam'] = homeTeam;
    data['homeColor'] = homeColor;
    data['homeLogo'] = homeLogo;
    data['homeGoals'] = homeGoals;
    data['awayTeam'] = awayTeam;
    data['awayColor'] = awayColor;
    data['awayLogo'] = awayLogo;
    data['awayGoals'] = awayGoals;
    data['leagueLogo'] = leagueLogo;
    data['leagueId'] = leagueId;
    data['isCompleted'] = isCompleted;
    return data;
  }

  static Color toColor(String color) {
    color = color.replaceAll('#', '');
    color = "0xFF$color";
    return Color(int.parse(color));
  }
}

class Questions {
  List<String>? answers;
  String? questionText;
  String? id;

  Questions({this.answers, this.questionText, this.id});

  Questions.fromJson(Map<String, dynamic> json) {
    answers = json['answers'].cast<String>();
    questionText = json['questionText'];
    id = json['id'] ?? json['questionText'] + "1";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answers'] = answers;
    data['questionText'] = questionText;
    return data;
  }
}

class UserAnswer {
  String? id;
  List<String>? answers;
  int? homeGoals;
  int? awayGoals;
  int? bonus;
  String? createdAt;
  String? challengeId;
  String? userId;

  UserAnswer({
    this.id,
    this.answers,
    this.homeGoals,
    this.awayGoals,
    this.bonus,
    this.createdAt,
    this.challengeId,
    this.userId,
  });

  UserAnswer.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    answers = json['answers'].cast<String>();
    homeGoals = json['homeGoals'] ?? 0;
    awayGoals = json['awayGoals'] ?? 0;
    bonus = json['bonus'] ?? 0;
    createdAt = json['createdAt'];
    challengeId = json['challengeId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['answers'] = answers;
    data['homeGoals'] = homeGoals;
    data['awayGoals'] = awayGoals;
    data['bonus'] = bonus;
    data['createdAt'] = createdAt;
    data['challengeId'] = challengeId;
    data['userId'] = userId;
    return data;
  }
}

import 'package:football_app/models/home/admin_challenges_model.dart';

class MainPageModel {
  bool? isQuestionActive;
  bool? isSponsorActive;
  String? groupBGImage;
  String? groupHLImage;
  List<Advertisements>? advertisements;
  List<Sponsors>? sponsors;
  Question? question;
  List<Top10Challengers>? top10Challengers;
  List<AdminChallenges>? adminChallenges;
  List<Groups>? groups;
  bool? hasAnsweredQuestion;

  MainPageModel({
    this.isQuestionActive,
    this.isSponsorActive,
    this.groupBGImage,
    this.groupHLImage,
    this.advertisements,
    this.sponsors,
    this.question,
    this.top10Challengers,
    this.adminChallenges,
    this.groups,
    this.hasAnsweredQuestion,
  });

  MainPageModel.fromJson(Map<String, dynamic> json) {
    isQuestionActive = json['isQuestionActive'];
    isSponsorActive = json['isSponsorActive'];
    groupBGImage = json['groupBGImage'];
    groupHLImage = json['groupHLImage'];
    if (json['advertisements'] != null) {
      advertisements = <Advertisements>[];
      json['advertisements'].forEach((v) {
        advertisements!.add(Advertisements.fromJson(v));
      });
    }
    if (json['sponsors'] != null) {
      sponsors = <Sponsors>[];
      json['sponsors'].forEach((v) {
        sponsors!.add(Sponsors.fromJson(v));
      });
    }
    question =
        json['question'] != null ? Question.fromJson(json['question']) : null;
    if (json['top10Challengers'] != null) {
      top10Challengers = <Top10Challengers>[];
      json['top10Challengers'].forEach((v) {
        top10Challengers!.add(Top10Challengers.fromJson(v));
      });
    }
    if (json['adminChallenges'] != null) {
      adminChallenges = <AdminChallenges>[];
      json['adminChallenges'].forEach((v) {
        adminChallenges!.add(AdminChallenges.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(Groups.fromJson(v));
      });
    }
    hasAnsweredQuestion = json['hasAnsweredQuestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isQuestionActive'] = isQuestionActive;
    data['isSponsorActive'] = isSponsorActive;
    data['groupBGImage'] = groupBGImage;
    data['groupHLImage'] = groupHLImage;
    if (advertisements != null) {
      data['advertisements'] = advertisements!.map((v) => v.toJson()).toList();
    }
    if (sponsors != null) {
      data['sponsors'] = sponsors!.map((v) => v.toJson()).toList();
    }
    if (question != null) {
      data['question'] = question!.toJson();
    }
    if (top10Challengers != null) {
      data['top10Challengers'] =
          top10Challengers!.map((v) => v.toJson()).toList();
    }
    if (adminChallenges != null) {
      data['adminChallenges'] =
          adminChallenges!.map((v) => v.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['hasAnsweredQuestion'] = hasAnsweredQuestion;
    return data;
  }
}

class Advertisements {
  String? companyName;
  String? arCompanyName;
  String? poCompanyName;
  String? esCompanyName;
  String? description;
  String? arDescription;
  String? esDescription;
  String? poDescription;

  String? adsPhoto;
  String? companyUrl;

  Advertisements({
    this.companyName,
    this.arCompanyName,
    this.poCompanyName,
    this.poDescription,
    this.esDescription,
    this.esCompanyName,
    this.description,
    this.arDescription,
    this.adsPhoto,
    this.companyUrl,
  });

  Advertisements.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    arCompanyName = json['arCompanyName'];
    esCompanyName = json['esCompanyName'];
    poCompanyName = json['poCompanyName'];
    description = json['description'];
    arDescription = json['arDescription'];
    esDescription = json['esDescription'];
    poDescription = json['poDescription'];
    adsPhoto = json['adsPhoto'];
    companyUrl = json['companyUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['arCompanyName'] = arCompanyName;
    data['esCompanyName'] = esCompanyName;
    data['poCompanyName'] = poCompanyName;
    data['poDescription'] = poDescription;
    data['esDescription'] = esDescription;
    data['description'] = description;
    data['arDescription'] = arDescription;
    data['adsPhoto'] = adsPhoto;
    data['companyUrl'] = companyUrl;
    return data;
  }
}

class Sponsors {
  String? name;
  String? arName;
  String? poName;
  String? esName;
  String? logo;
  String? url;

  Sponsors({
    this.name,
    this.arName,
    this.logo,
    this.url,
    this.poName,
    this.esName,
  });

  Sponsors.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    arName = json['arName'];
    poName = json['poName'];
    esName = json['esName'];
    logo = json['logo'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['logo'] = logo;
    data['url'] = url;
    return data;
  }
}

class Question {
  String? id;
  String? question;
  String? photo;
  List<String>? answers;
  String? endDate;

  Question({this.id, this.question, this.photo, this.answers, this.endDate});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    photo = json['photo'];
    answers = json['answers'].cast<String>();
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['photo'] = photo;
    data['answers'] = answers;
    data['endDate'] = endDate;
    return data;
  }
}

class Top10Challengers {
  String? id;
  String? username;
  String? shirtName;
  String? shirtTextColor;
  String? shirtBGColor;
  int? shirtNumber;
  int? pointsEarned;
  String? photo;

  Top10Challengers({
    this.id,
    this.username,
    this.shirtName,
    this.shirtNumber,
    this.shirtTextColor,
    this.shirtBGColor,
    this.pointsEarned,
    this.photo,
  });

  Top10Challengers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    shirtName = json['shirtName'];
    shirtNumber = json['shirtNumber'];
    shirtTextColor = json['shirtTextColor'];
    shirtBGColor = json['shirtBGColor'];
    pointsEarned = json['pointsEarned'];
    photo = json['shirtPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['shirtName'] = shirtName;
    data['shirtNumber'] = shirtNumber;
    data['shirtTextColor'] = shirtTextColor;
    data['pointsEarned'] = pointsEarned;
    data['photo'] = photo;
    return data;
  }
}

class AdminChallenges {
  String? id;
  List<Questions>? questions;
  bool? isWinLoseQuestion;
  Match? match;

  AdminChallenges({
    this.id,
    this.questions,
    this.isWinLoseQuestion,
    this.match,
  });

  AdminChallenges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    isWinLoseQuestion = json['isWinLoseQuestion'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;
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
    return data;
  }
}

class Match {
  int? id;
  String? startDate;
  String? status;
  String? homeTeam;
  String? homeLogo;
  String? homeGoals;
  String? awayTeam;
  String? awayLogo;
  String? awayGoals;
  String? leagueLogo;
  int? leagueId;
  bool? isCompleted;

  Match({
    this.id,
    this.startDate,
    this.status,
    this.homeTeam,
    this.homeLogo,
    this.homeGoals,
    this.awayTeam,
    this.awayLogo,
    this.awayGoals,
    this.leagueLogo,
    this.leagueId,
    this.isCompleted,
  });

  Match.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    status = json['status'];
    homeTeam = json['homeTeam'];
    homeLogo = json['homeLogo'];
    homeGoals = json['homeGoals'];
    awayTeam = json['awayTeam'];
    awayLogo = json['awayLogo'];
    awayGoals = json['awayGoals'];
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
    data['homeLogo'] = homeLogo;
    data['homeGoals'] = homeGoals;
    data['awayTeam'] = awayTeam;
    data['awayLogo'] = awayLogo;
    data['awayGoals'] = awayGoals;
    data['leagueLogo'] = leagueLogo;
    data['leagueId'] = leagueId;
    data['isCompleted'] = isCompleted;
    return data;
  }
}

class Groups {
  String? id;
  String? name, arName, esName, poName;
  String? logo;
  int? maxMembers;
  int? membersCount;
  int? leagueId;

  Groups({
    this.id,
    this.name,
    this.poName,
    this.arName,
    this.esName,
    this.logo,
    this.maxMembers,
    this.membersCount,
    this.leagueId,
  });

  Groups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['arName'];
    esName = json['esName'];
    poName = json['poName'];
    logo = json['logo'];
    maxMembers = json['maxMembers'];
    membersCount = json['membersCount'];
    leagueId = json['leagueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['arName'] = arName;
    data['esName'] = esName;
    data['poName'] = poName;
    data['logo'] = logo;
    data['maxMembers'] = maxMembers;
    data['membersCount'] = membersCount;
    data['leagueId'] = leagueId;
    return data;
  }
}

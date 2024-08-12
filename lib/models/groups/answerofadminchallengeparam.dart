class AnswersofadminchallengeParam {
  String? challengeId;
  List<String>? answers;
  int? homeGoals;
  int? awayGoals;
  int? bonus;

  AnswersofadminchallengeParam(
      {this.challengeId,
      this.answers,
      this.homeGoals,
      this.awayGoals,
      this.bonus});

  AnswersofadminchallengeParam.fromJson(Map<String, dynamic> json) {
    challengeId = json['challengeId'];
    answers = json['answers'].cast<String>();
    homeGoals = json['homeGoals'];
    awayGoals = json['awayGoals'];
    bonus = json['bonus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challengeId'] = this.challengeId;
    data['answers'] = this.answers;
    data['homeGoals'] = this.homeGoals;
    data['awayGoals'] = this.awayGoals;
    data['bonus'] = this.bonus;
    return data;
  }
}

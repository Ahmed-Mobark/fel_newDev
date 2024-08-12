class AnswersofchallengeParam {
  String? groupId;
  int? matchId;
  int? homeGoals;
  int? awayGoals;
  int? bonus;

  AnswersofchallengeParam(
      {this.groupId, this.matchId, this.homeGoals, this.awayGoals, this.bonus});

  AnswersofchallengeParam.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    matchId = json['matchId'];
    homeGoals = json['homeGoals'];
    awayGoals = json['awayGoals'];
    bonus = json['bonus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['matchId'] = this.matchId;
    data['homeGoals'] = this.homeGoals;
    data['awayGoals'] = this.awayGoals;
    data['bonus'] = this.bonus;
    return data;
  }
}

class PredictGroupMatchParam {
  String? groupId;
  int? matchId;
  int? bouns;
  int? homeGoals;
  int? awayGoals;

  PredictGroupMatchParam({
    this.groupId,
    this.matchId,
    this.bouns,
    this.homeGoals,
    this.awayGoals,
  });

  PredictGroupMatchParam.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    matchId = json['matchId'];
    bouns = json['bouns'];
    homeGoals = json['homeGoals'];
    awayGoals = json['awayGoals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupId'] = groupId;
    data['matchId'] = matchId;
    data['bouns'] = bouns;
    data['homeGoals'] = homeGoals;
    data['awayGoals'] = awayGoals;
    return data;
  }
}

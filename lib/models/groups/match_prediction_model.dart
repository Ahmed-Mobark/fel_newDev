class MatchPredictionModel {
  String? id;
  int? homeGoals;
  int? awayGoals;
  int? bonus;
  String? createdAt;
  int? matchId;
  String? groupId;
  String? userId;

  MatchPredictionModel({
    this.id,
    this.homeGoals,
    this.awayGoals,
    this.bonus,
    this.createdAt,
    this.matchId,
    this.groupId,
    this.userId,
  });

  MatchPredictionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    homeGoals = json['homeGoals'];
    awayGoals = json['awayGoals'];
    bonus = json['bonus'];
    createdAt = json['createdAt'];
    matchId = json['matchId'];
    groupId = json['groupId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['homeGoals'] = homeGoals;
    data['awayGoals'] = awayGoals;
    data['bonus'] = bonus;
    data['createdAt'] = createdAt;
    data['matchId'] = matchId;
    data['groupId'] = groupId;
    data['userId'] = userId;
    return data;
  }
}

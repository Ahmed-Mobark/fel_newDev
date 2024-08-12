class UserGroupIdsModel {
  String? groupId;

  UserGroupIdsModel({this.groupId});

  UserGroupIdsModel.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupId'] = groupId;
    return data;
  }

  @override
  String toString() => 'UserGroupIdsModel($groupId)';
}

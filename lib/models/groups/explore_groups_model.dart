import 'my_groups_model.dart';

class ExploreGroupModel {
  List<GroupModel>? data;
  int? count;

  ExploreGroupModel({this.data, this.count});

  ExploreGroupModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GroupModel>[];
      json['data'].forEach((v) {
        data!.add(GroupModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

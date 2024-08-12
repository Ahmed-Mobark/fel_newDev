class StoreParam {
  String searchText;
  int category;
  int take;
  int skip;

  StoreParam({
    required this.searchText,
    required this.category,
    required this.take,
    required this.skip,
  });

  factory StoreParam.fromJson(Map<String, dynamic> json) {
    return StoreParam(
      searchText: json['searchText'],
      category: json['category'],
      take: json['take'],
      skip: json['skip'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['searchText'] = searchText;
    data['category'] = category;
    data['take'] = take;
    data['skip'] = skip;
    return data;
  }
}

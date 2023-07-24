class StatisticsModel {
  String? title;
  int? count;

  StatisticsModel({this.title, this.count});

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    count = json['count'];
  }
}
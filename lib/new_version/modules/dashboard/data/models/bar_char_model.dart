import 'package:equatable/equatable.dart';

class BarChartModel extends Equatable {
  final String? title;
  final int? count;

  const BarChartModel({
    this.title,
    this.count,
  });

  factory BarChartModel.fromJson(Map<String, dynamic> json) =>
      BarChartModel(title: json['title'], count: json['count']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['count'] = count;
    return data;
  }

  @override
  List<Object?> get props => [
        title,
        count,
      ];
}

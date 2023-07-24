import 'package:equatable/equatable.dart';
import '../../data/models/bar_char_model.dart';

class DashboardEntity extends Equatable {
  final String? userImage;
  final String? userFullName;
  final List<BarChartModel>? barChart;


  const DashboardEntity({
    required this.userImage,
    required this.userFullName,
    required this.barChart,

  });

  @override
  List<Object?> get props => [
        userImage,
        userFullName,
        barChart,
    
      ];
}

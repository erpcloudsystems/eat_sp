import 'package:NextApp/new_version/modules/dashboard/data/models/bar_char_model.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.userImage,
    required super.userFullName,
    required super.barChart,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        userFullName: json['user_full_name'] ?? 'none',
        userImage: json['user_image'] ?? 'none',
        barChart: List.from(
          (json['bar_chart'] as List).map(
            (e) => BarChartModel.fromJson(e),
          ),
        ),
        
      );
}

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../../data/models/bar_char_model.dart';
import '../../../../../core/cloud_system_widgets.dart';

class ChartDashboardWidget extends StatelessWidget {
  const ChartDashboardWidget({
    Key? key,
    required this.data,
  }) : super(key: key);
  final List<BarChartModel> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, ),
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: SfCartesianChart(
        plotAreaBorderColor: Colors.white,
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(color: Colors.transparent),
          minorGridLines: const MinorGridLines(color: Colors.transparent),
        ),
        primaryYAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(color: Colors.transparent),
          minorGridLines: const MinorGridLines(color: Colors.transparent),
        ),
        enableAxisAnimation: true,
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<BarChartModel, String>>[
          ColumnSeries<BarChartModel, String>(
            spacing: 1.6,
            isVisibleInLegend: false,
            dataSource: data,
            xValueMapper: (BarChartModel barChartModel, _) => barChartModel.title,
            yValueMapper: (BarChartModel barChartModel, _) => barChartModel.count,
            pointColorMapper: (BarChartModel barChartModel, _) => statusColor(barChartModel.title!),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
          ),
        ],
      ),
    );
  }
}

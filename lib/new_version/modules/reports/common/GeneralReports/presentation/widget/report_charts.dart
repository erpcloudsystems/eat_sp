import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportCharts extends StatelessWidget {
  const ReportCharts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<_SalesData> data = [
      _SalesData('Jan', 35, Colors.red),
      _SalesData('Feb', 28, Colors.green),
      _SalesData('Mar', 34, Colors.teal),
      _SalesData('Apr', 32, Colors.indigo),
      _SalesData('May', 40, Colors.black87)
    ];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                ColumnSeries<_SalesData, String>(
                  dataSource: data,
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  name: 'Sales',
                  width: .4,
                  spacing: .4,
                  pointColorMapper: (_SalesData data, _) => data.color,
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales, this.color);

  final String year;
  final double sales;
  final Color? color;
}

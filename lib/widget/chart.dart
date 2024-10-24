import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatelessWidget {
  final List<SalesData> chartData;

  ChartWidget({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<SalesData, String>>[
          SplineSeries<SalesData, String>(
            color: Color.fromARGB(255, 47, 125, 121),
            width: 3,
            dataSource: chartData,
            xValueMapper: (SalesData sales, _) => sales.xValue,
            yValueMapper: (SalesData sales, _) => sales.amount,
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.xValue, this.amount);
  final String xValue; // This can represent the hour, day, or month
  final int amount; // This represents the total amount for that xValue
}

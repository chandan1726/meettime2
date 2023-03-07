import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class TestFlutter extends StatefulWidget {
  TestFlutter({Key key}) : super(key: key);
  @override
  State<TestFlutter> createState() => _TestFlutterState();
}

class _TestFlutterState extends State<TestFlutter> {
  @override
  Widget build(BuildContext context) {
    LabelLayoutStrategy xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    chartOptions = const ChartOptions.noLabels();
    chartData = ChartData(
      dataRows: const [
        [10.0, 20.0, 5.0, 30.0, 5.0, 20.0],
        [30.0, 60.0, 16.0, 100.0, 12.0, 120.0],
        [25.0, 40.0, 20.0, 80.0, 12.0, 90.0],
        [12.0, 30.0, 18.0, 40.0, 10.0, 30.0],
      ],
      xUserLabels: const ['Wolf', 'Deer', 'Owl', 'Mouse', 'Hawk', 'Vole'],
      dataRowsLegends: const [
        'Spring',
        'Summer',
        'Fall',
        'Winter',
      ],
      chartOptions: chartOptions,
    );
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }
}

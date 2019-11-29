import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:student_agenda/Utilities/util.dart';

class PerformanceTab extends StatefulWidget {
  PerformanceTab(this.dataMap, this.months, {Key key, this.title}) : super(key: key);

  final String title;
  final Map<String, dynamic> dataMap;
  final months;

  @override
  _PerformanceTabState createState() => _PerformanceTabState(this.dataMap, this.months);
}

//TODO: Add a line or bar graph that shows how many goals have been completed
//TODO: during particular days in the give time period (might be more trouble than it is worth due to the amount of days involved in some of the periods)
class _PerformanceTabState extends State<PerformanceTab> {
  Map<String, dynamic> data;
  List<charts.Series<PieDatum, String>> pieChartDataSeries;
  List<charts.Series<TimeSeriesValue, int>> lineChartDataSeries;
  charts.PieChart pChart;
  charts.LineChart tChart;
  int months;

  _PerformanceTabState(this.data, this.months);

  @override
  void initState() {
    pieChartDataSeries = createPieData(this.data);
    pChart = buildPieChart(pieChartDataSeries);
    lineChartDataSeries = createTimeLineData(this.data, months);
    tChart = buildLineChart(lineChartDataSeries);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
          child: Column(
              children: buildPerformanceScreen(data, pChart, tChart)
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:student_agenda/Utilities/util.dart';

class FourMonthsPerformanceTab extends StatefulWidget {
  FourMonthsPerformanceTab(this.dataMap, {Key key, this.title}) : super(key: key);

  final String title;
  final Map<String, num> dataMap;

  @override
  _FourMonthsPerformanceTabState createState() => _FourMonthsPerformanceTabState(this.dataMap);
}

//TODO: Add a table that shows the actual number for each goal
//TODO: Add a line or bar graph that shows how many goals have been completed
//TODO: during particular days in the give time period (might be more trouble than it is worth due to the amount of days involved in some of the periods)
class _FourMonthsPerformanceTabState extends State<FourMonthsPerformanceTab> {
  Map<String, num> data;
  List<charts.Series<PieDatum, String>> chartDataSeries;
  charts.PieChart pChart;

  _FourMonthsPerformanceTabState(this.data);

  @override
  void initState() {
    chartDataSeries = createPieData(this.data);
    pChart = buildPieChart(chartDataSeries);
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Task Breakdown by Completion Time"),
            SizedBox(height: 10.0),
            Expanded(
              child: pChart
            ),
          ]
        ),
      ),
    );
  }
}
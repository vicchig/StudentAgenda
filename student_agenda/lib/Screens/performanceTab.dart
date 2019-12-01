import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:student_agenda/FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/Utilities/goal.dart';
import 'package:student_agenda/Utilities/graphingUtilities.dart';
import 'package:student_agenda/Utilities/selectionCallbackChart.dart';

class PerformanceTab extends StatefulWidget {
  PerformanceTab(this.months, {Key key, this.title}) : super(key: key);

  final String title;
  final months;

  @override
  _PerformanceTabState createState() => _PerformanceTabState(this.months);
}

class _PerformanceTabState extends State<PerformanceTab> {
  Map<String, Map<String, dynamic>> data = {
    "4 Months": {"completedOnTime": 0, "completedLate": 0, "incomplete": 0,
      "tasksCreated": 0, "onTime%": 0.0, "late%": 0.0, "incomplete%": 0.0,
      "goalCompletions": []},
    "8 Months": {"completedOnTime": 0, "completedLate": 0, "incomplete": 0,
      "tasksCreated": 0, "onTime%": 0.0, "late%": 0.0, "incomplete%": 0.0,
      "goalCompletions": []},
    "12 Months": {"completedOnTime": 0, "completedLate": 0, "incomplete": 0,
      "tasksCreated": 0, "onTime%": 0.0, "late%": 0.0, "incomplete%": 0.0,
      "goalCompletions": []}
  };
  List<charts.Series<PieDatum, String>> pieChartDataSeries;
  List<charts.Series<LineSeriesValue, int>> lineChartDataSeries;
  charts.PieChart pChart;
  SelectionCallbackChart tChart;
  int months;
  List<Goal> _goals;

  _PerformanceTabState(this.months);

  Future goalsFuture;

  Future<List<Goal>> _getCourseWorkGoals() async {
    return await pullGoals(firebaseUser, "CourseWorkGoalObjects");
  }

  Future<List<Goal>> _getCourseGoals() async {
    return await pullGoals(firebaseUser, "CourseGoalObjects");
  }

  @override
  void initState() {
    super.initState();
    goalsFuture = _getCourseWorkGoals();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime _getDateMonthsAgo(int ago, DateTime date){
    String dateStr = date.toIso8601String();

    if(ago < 12){
      String month = "";
      int newMonth = date.month - ago;

      if(newMonth < 10){
        month = "0" + newMonth.toString();
      }else{
        month = newMonth.toString();
      }
      return DateTime.parse(dateStr.substring(0, 4) + "-" + month + "-" +
          dateStr.substring(8, 10) + dateStr.substring(10, 19));
    }

    return DateTime.parse((date.year.toInt() - (ago ~/ 12)).toString() +
        dateStr.substring(4, dateStr.length));
  }

  @override
  Widget build(BuildContext context){
    return Center(
        child: FutureBuilder(
          future: Future.wait([_getCourseGoals(), _getCourseWorkGoals()]),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            _goals = snapshot.data[0];
            _goals.addAll(snapshot.data[1]);

            DateTime currDate = DateTime.now();
            DateTime fourMonthsAgo = _getDateMonthsAgo(4, currDate);
            DateTime eightMonthsAgo = _getDateMonthsAgo(8, currDate);
            DateTime twelveMonthsAgo = _getDateMonthsAgo(12, currDate);

            data["4 Months"]["goalCompletions"].add(fourMonthsAgo);
            data["4 Months"]["goalCompletions"].add(currDate);
            data["8 Months"]["goalCompletions"].add(eightMonthsAgo);
            data["8 Months"]["goalCompletions"].add(currDate);
            data["12 Months"]["goalCompletions"].add(twelveMonthsAgo);
            data["12 Months"]["goalCompletions"].add(currDate);

            for(Goal g in _goals){
              if(g.dueDate.isAfter(fourMonthsAgo) &&
                  g.dueDate.isBefore(currDate.add(new Duration(days: 1)))){

                if (g.getStatus() == S_COMPLETED) {
                  data["4 Months"]["completedOnTime"]++;
                  data["8 Months"]["completedOnTime"]++;
                  data["12 Months"]["completedOnTime"]++;
                } else if (g.getStatus() == S_COMPLETED_LATE) {
                  data["4 Months"]["completedLate"]++;
                  data["8 Months"]["completedLate"]++;
                  data["12 Months"]["completedLate"]++;
                } else {
                  data["4 Months"]["incomplete"]++;
                  data["8 Months"]["incomplete"]++;
                  data["12 Months"]["incomplete"]++;
                }

                if(g.getStatus() == S_COMPLETED_LATE || g.getStatus() == S_COMPLETED && g.getDateCompleted().isAfter(fourMonthsAgo) && g.getDateCompleted().isBefore(currDate.add(new Duration(days: 1)))){
                  data["4 Months"]["goalCompletions"].add(g.getDateCompleted());
                  data["8 Months"]["goalCompletions"].add(g.getDateCompleted());
                  data["12 Months"]["goalCompletions"].add(g.getDateCompleted());
                }
              }
              else if(g.dueDate.isAfter(eightMonthsAgo) &&
                  g.dueDate.isBefore(currDate.add(new Duration(days: 1)))){

                if (g.getStatus() == S_COMPLETED) {
                  data["8 Months"]["completedOnTime"]++;
                  data["12 Months"]["completedOnTime"]++;
                } else if (g.getStatus() == S_COMPLETED_LATE) {
                  data["8 Months"]["completedLate"]++;
                  data["12 Months"]["completedLate"]++;
                } else {
                  data["8 Months"]["incomplete"]++;
                  data["12 Months"]["incomplete"]++;
                }

                if(g.getStatus() == S_COMPLETED_LATE || g.getStatus() == S_COMPLETED && g.getDateCompleted().isAfter(eightMonthsAgo) && g.getDateCompleted().isBefore(currDate.add(new Duration(days: 1)))){
                  data["8 Months"]["goalCompletions"].add(g.getDateCompleted());
                  data["12 Months"]["goalCompletions"].add(g.getDateCompleted());
                }
              }

              else if(g.dueDate.isAfter(twelveMonthsAgo) &&
                  g.dueDate.isBefore(currDate.add(new Duration(days: 1)))){

                if (g.getStatus() == S_COMPLETED) {
                  data["12 Months"]["completedOnTime"]++;
                } else if (g.getStatus() == S_COMPLETED_LATE) {
                  data["12 Months"]["completedLate"]++;
                } else {
                  data["12 Months"]["incomplete"]++;
                }

                if(g.getStatus() == S_COMPLETED_LATE || g.getStatus() == S_COMPLETED && g.getDateCompleted().isAfter(twelveMonthsAgo) && g.getDateCompleted().isBefore(currDate.add(new Duration(days: 1)))){
                  data["12 Months"]["goalCompletions"].add(g.getDateCompleted());
                }
              }
            }

            for(String period in data.keys){
              data[period]["tasksCreated"] = data[period]["completedOnTime"] +
                  data[period]["completedLate"] + data[period]["incomplete"];

              data[period]["onTime%"] = num.parse(((data[period]["completedOnTime"] *
                  1.0 / data[period]["tasksCreated"]) * 100).toStringAsFixed(2));

              data[period]["late%"] = num.parse(((data[period]["completedLate"] * 1.0 /
                  data[period]["tasksCreated"]) * 100).toStringAsFixed(2));

              data[period]["incomplete%"] = num.parse(((data[period]["incomplete"] * 1.0
                  / data[period]["tasksCreated"]) * 100).toStringAsFixed(2));
            }

            if(this.months == 4){
              pieChartDataSeries = createPieData(this.data["4 Months"]);
              pChart = buildPieChart(pieChartDataSeries);
              lineChartDataSeries = createTimeLineData(this.data["4 Months"], months);
              tChart = new SelectionCallbackChart(lineChartDataSeries);
            }
            else if(this.months == 8){
              pieChartDataSeries = createPieData(this.data["8 Months"]);
              pChart = buildPieChart(pieChartDataSeries);
              lineChartDataSeries = createTimeLineData(this.data["8 Months"], months);
              tChart = new SelectionCallbackChart(lineChartDataSeries);
            }
            else{
              pieChartDataSeries = createPieData(this.data["12 Months"]);
              pChart = buildPieChart(pieChartDataSeries);
              lineChartDataSeries = createTimeLineData(this.data["12 Months"], months);
              tChart = new SelectionCallbackChart(lineChartDataSeries);
            }
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  children: _buildPerformanceScreen(data, pChart, tChart)
              ),
            );
          }
          else{
            return Text("Not done");
        }
      },
    ));
  }

  List<Widget> _buildPerformanceScreen(Map<String, dynamic> data, charts.PieChart pChart, SelectionCallbackChart tChart){
    return <Widget>[
      Text("Task Breakdown by Completion Time",
        style: new TextStyle(
          fontSize: 20.0,
        ),
      ),
      SizedBox(height: 10.0),
      Expanded(
        child: SizedBox(
          height: 1000,
          child: new ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              SizedBox(
                  width: 3000,
                  height: 300,
                  child: pChart
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
                child: Text(
                  "Stats",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 20.0,
                 ),
                ),
              ),
              Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  defaultColumnWidth: FixedColumnWidth(150.0),
                  border: TableBorder.all(),
                  children: [
                    TableRow(children: [
                      Container(
                        child: Text("Tasks Completed on Time"),
                        width: 150,
                        alignment: Alignment(-0.9, 0.0),
                      ),
                      Container(
                        child: Text(data[months.toString() + " Months"]["completedOnTime"].toString()),
                        color: Colors.green[50],
                        width: 150,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        child: Text("Task Completed Late"),
                        width: 150,
                        alignment: Alignment(-0.9, 0.0),
                      ),
                      Container(
                        child: Text(data[months.toString() + " Months"]["completedLate"].toString()),
                        color: Colors.orange[50],
                        width: 150,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        child: Text("Incomplete Tasks"),
                        width: 150,
                        alignment: Alignment(-0.9, 0.0),
                      ),
                      Container(
                        child: Text(data[months.toString() + " Months"]["incomplete"].toString()),
                        color: Colors.red[50],
                        width: 150,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        child: Text("Total Tasks"),
                        width: 150,
                        alignment: Alignment(-0.95, 0.0),
                      ),
                      Container(
                        child: Text(data[months.toString() + " Months"]["tasksCreated"].toString()),
                        width: 150,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ]),TableRow(children: [
                      Container(
                        child: Text("Average Completion Time"),
                        width: 150,
                        alignment: Alignment(-0.8, 0.0),
                      ),
                      Container(
                        child: Text("15.0"),
                        width: 150,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ]),
                  ]
              ),
              SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 35,
                child: Text("Goal Completion Timeline",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                  width: 3000,
                  height: 300,
                  child: tChart
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

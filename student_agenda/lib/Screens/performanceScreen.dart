import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:student_agenda/Screens/courseDashboard.dart';
import 'dart:async';
import 'package:student_agenda/Utilities/util.dart';
import 'package:student_agenda/Utilities/goal.dart';
import 'package:student_agenda/FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';

class PerformanceScreen extends StatefulWidget {
  PerformanceScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  int onTimeNum = 0;
  int lateNum = 0;
  int tasksRemaining = 0;
  int tasksCreated = 0;

  double onTimePercent = 1;
  double latePercent = 0;

  double onTimeLegendFont = 11;
  double lateLegendFont = 11;

  Map<String, Map<String, num>> data = {
    "4 Months": {"completedOnTime": 0, "completedLate": 0, "incomplete": 0,
      "tasksCreated": 0, "onTime%": 0.0, "late%": 0.0, "incomplete%": 0.0},
    "8 Months": {"completedOnTime": 0, "completedLate": 0, "incomplete": 0,
      "tasksCreated": 0, "onTime%": 0.0, "late%": 0.0, "incomplete%": 0.0},
    "12 Months": {"completedOnTime": 0, "completedLate": 0, "incomplete": 0,
      "tasksCreated": 0, "onTime%": 0.0, "late%": 0.0, "incomplete%": 0.0},
    "allTime": {"completedOnTime": 0, "completedLate": 0, "incomplete": 0,
      "tasksCreated": 0, "onTime%": 0.0, "late%": 0.0, "incomplete%": 0.0}
  };

  Future<void> processFuture() async {
    List<Goal> tempGoals =
    await pullGoals(firebaseUser, "CourseWorkGoalObjects");
    tempGoals.addAll(await pullGoals(firebaseUser, "CourseGoalObjects"));

    DateTime currDate = DateTime.now();
    DateTime fourMonthsAgo = _getDateMonthsAgo(4, currDate);
    DateTime eightMonthsAgo = _getDateMonthsAgo(8, currDate);
    DateTime twelveMonthsAgo = _getDateMonthsAgo(12, currDate);

    for(Goal g in tempGoals){
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
      }

      for(String period in data.keys){
        data[period]["tasksCreated"] = data[period]["completedOnTime"] +
            data[period]["completedLate"] + data[period]["incomplete"];

        data[period]["onTime%"] = (data[period]["completedOnTime"] * 1.0 /
            data[period]["tasksCreated"]) * 100;

        data[period]["late%"] = (data[period]["completedLate"] * 1.0 /
            data[period]["tasksCreated"]) * 100;

        data[period]["incomplete%"] = (data[period]["incomplete"] * 1.0 /
            data[period]["tasksCreated"]) * 100;
      }
    }

    for (Goal goal in tempGoals) {
      tasksCreated++;
      if (goal.getStatus() == S_COMPLETED) {
        onTimeNum++;
      } else if (goal.getStatus() == S_COMPLETED_LATE) {
        lateNum++;
      } else {
        tasksRemaining++;
      }
    }
    onTimePercent = (onTimeNum + lateNum == 0)
        ? 1
        : onTimeNum.toDouble() / (onTimeNum + lateNum);
    latePercent = (onTimeNum + lateNum == 0)
        ? 0
        : lateNum.toDouble() / (onTimeNum + lateNum);
    tasksCreated = onTimeNum + lateNum + tasksRemaining;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    processFuture().then((arg) {}, onError: (e) {
      print(e);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Performance'),
      ),

      //draw the sidebar menu options
      drawer: MenuDrawer(),

      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          TotalTasks(
            onTimeNum: onTimeNum,
            text: 'Tasks Completed on Time:',
          ),
          SizedBox(height: 20),
          TotalTasks(
            onTimeNum: lateNum,
            text: 'Tasks Completed Late:',
          ),
          SizedBox(height: 20),
          TotalTasks(
            onTimeNum: tasksRemaining,
            text: 'Tasks Remaining:',
          ),
          SizedBox(height: 20),
          TotalTasks(
            onTimeNum: tasksCreated,
            text: 'Tasks Created:',
          ),
        ],
      ),
    );
  }

  DateTime _getDateMonthsAgo(int ago, DateTime date){
    if(ago < 12){
      return DateTime.parse(date.year.toString() + "-" +
          (date.month - ago).toString() + "-" + date.day.toString() + "T" +
          date.hour.toString() + ":" + date.minute.toString() + ":" +
          date.second.toString());
    }

    return DateTime.parse((date.year - ago / 12).toString() + "-" +
        (date.month).toString() + "-" + date.day.toString() + "T" +
        date.hour.toString() + ":" + date.minute.toString() + ":" +
        date.second.toString());
  }
}

class TotalTasks extends StatelessWidget {
  const TotalTasks({
    Key key,
    @required this.onTimeNum,
    @required this.text,
  }) : super(key: key);

  final int onTimeNum;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Container(
                child: Text(
                  '$onTimeNum',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegendEntry extends StatelessWidget {
  const LegendEntry({
    Key key,
    @required this.onTimeLegendFont,
    @required this.color,
    @required this.text,
  }) : super(key: key);

  final double onTimeLegendFont;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
        ),
        Container(
          height: 15,
          width: 15,
          color: color,
        ),
        Text(
          text,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: onTimeLegendFont,
          ),
        ),
      ],
    );
  }
}

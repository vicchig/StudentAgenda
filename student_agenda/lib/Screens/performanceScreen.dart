import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

  StreamController<PieTouchResponse> pieTouchedResultStreamController;

  int touchedIndex;

  Future<void> processFuture() async {
    List<Goal> tempGoals =
    await pullGoals(firebaseUser, "CourseWorkGoalObjects");
    tempGoals.addAll(await pullGoals(firebaseUser, "CourseGoalObjects"));

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
    pieTouchedResultStreamController = StreamController();
    pieTouchedResultStreamController.stream.distinct().listen((details) {
      if (details == null) {
        return;
      }

      setState(() {
        if (details.touchInput is FlLongPressEnd) {
          touchedIndex = -1;
        } else {
          touchedIndex = details.touchedSectionPosition;
        }
        switch (touchedIndex) {
          case 0:
            onTimeLegendFont = 15;
            lateLegendFont = 11;
            break;
          case 1:
            lateLegendFont = 15;
            onTimeLegendFont = 11;
            break;
          default:
            onTimeLegendFont = 11;
            lateLegendFont = 11;
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pieTouchedResultStreamController.close();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlChart(
                chart: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(
                          touchResponseStreamSink:
                              pieTouchedResultStreamController.sink),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: showingSections()),
                ),
              ),
            ],
          ),
          LegendEntry(
            onTimeLegendFont: onTimeLegendFont,
            color: Colors.green,
            text: ' : Tasks Completed On Time',
          ),
          SizedBox(
            height: 3,
          ),
          LegendEntry(
            onTimeLegendFont: lateLegendFont,
            color: Colors.red,
            text: ' : Tasks Completed Late',
          ),
          SizedBox(height: 30),
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

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 110 : 100;
      switch (i) {
        case 0:
//          onTimeLegendFont = isTouched ? 15 : 11;
          return PieChartSectionData(
            color: Colors.green,
            value: onTimePercent,
            title: 'On Time',
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 1:
//          lateLegendFont = isTouched ? 15 : 11;
          return PieChartSectionData(
            color: Colors.red,
            value: latePercent,
            title: 'Late',
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        default:
          return null;
      }
    });
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

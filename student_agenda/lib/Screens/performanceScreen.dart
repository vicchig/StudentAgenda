import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_agenda/Screens/performanceTab.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/Utilities/goal.dart';
import 'package:student_agenda/Utilities/tempTestGoal.dart';
import 'package:student_agenda/Utilities/tempTestGoal.dart' as prefix0;
import 'dart:async';
import 'package:student_agenda/Utilities/util.dart';
import "package:student_agenda/FirestoreManager.dart";

class PerformanceScreen extends StatefulWidget {
  PerformanceScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> with
    SingleTickerProviderStateMixin{

  TabController _tabController;
  ScrollController _scrollController;

  int onTimeNum = 0;
  int lateNum = 0;
  int tasksRemaining = 0;
  int tasksCreated = 0;

  double onTimePercent = 1;
  double latePercent = 0;

  double onTimeLegendFont = 11;
  double lateLegendFont = 11;

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

  //TODO: This is only for testing, remove later
  List<TempTestGoal> goals = new List<TempTestGoal>();



  Future<void> processFuture() async {
    //List<Goal> tempGoals =
   // await pullGoals(firebaseUser, "CourseWorkGoalObjects");
   // tempGoals.addAll(await pullGoals(firebaseUser, "CourseGoalObjects"));
    setState(() {
      //TODO: This is only for testing remove later
      //4 month goals
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-11-02T10:10:10", dateAssigned: "2019-11-02T10:10:10", dateCompleted: "2019-11-02T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-11-02T10:10:10", dateAssigned: "2019-11-02T10:10:10", dateCompleted: "2019-11-02T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-10-15T10:10:10", dateAssigned: "2019-10-15T10:10:10", dateCompleted: "2019-10-15T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-10-25T10:10:10", dateAssigned: "2019-10-25T10:10:10", dateCompleted: "2019-10-25T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-09-17T10:10:10", dateAssigned: "2019-09-17T10:10:10", dateCompleted: "2019-09-17T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-09-09T10:10:10", dateAssigned: "2019-09-09T10:10:10", dateCompleted: "2019-09-09T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-08-02T10:10:10", dateAssigned: "2019-08-02T10:10:10", dateCompleted: "2019-08-02T10:10:10"));
      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-07-30T10:10:10", dateAssigned: "2019-07-30T10:10:10", dateCompleted: "2019-07-30T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-07-29T10:10:10", dateAssigned: "2019-07-29T10:10:10", dateCompleted: "2019-07-29T10:10:10"));

      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-07-28T10:10:10", dateAssigned: "2019-07-28T10:10:10", dateCompleted: "2019-07-28T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-07-28T10:10:10", dateAssigned: "2019-07-28T10:10:10", dateCompleted: "2019-07-28T10:10:10"));//these should not count under 4 months depending on time of day

      //8 months
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-07-15T10:10:10", dateAssigned: "2019-07-15T10:10:10", dateCompleted: "2019-07-15T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-07-02T10:10:10", dateAssigned: "2019-07-02T10:10:10", dateCompleted: "2019-07-02T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-05-02T10:10:10", dateAssigned: "2019-05-02T10:10:10", dateCompleted: "2019-05-02T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-05-05T10:10:10", dateAssigned: "2019-05-05T10:10:10", dateCompleted: "2019-05-05T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-04-20T10:10:10", dateAssigned: "2019-04-20T10:10:10", dateCompleted: "2019-04-20T10:10:10"));
      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-03-30T10:10:10", dateAssigned: "2019-03-30T10:10:10", dateCompleted: "2019-03-30T10:10:10"));
      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-03-30T10:10:10", dateAssigned: "2019-03-30T10:10:10", dateCompleted: "2019-03-30T10:10:10"));
      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-03-29T10:10:10", dateAssigned: "2019-03-29T10:10:10", dateCompleted: "2019-03-29T10:10:10"));
      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-03-28T10:10:10", dateAssigned: "2019-03-28T10:10:10", dateCompleted: "2019-03-28T10:10:10"));

      //12 months
      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-02-25T10:10:10", dateAssigned: "2019-02-25T10:10:10", dateCompleted: "2019-02-25T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-02-09T10:10:10", dateAssigned: "2019-02-09T10:10:10", dateCompleted: "2019-02-09T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-01-16T10:10:10", dateAssigned: "2019-01-16T10:10:10", dateCompleted: "2019-01-16T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2019-01-20T10:10:10", dateAssigned: "2019-01-20T10:10:10", dateCompleted: "2019-01-20T10:10:10"));
      goals.add(new TempTestGoal(status: S_IN_PROGRESS, dueDate: "2019-01-19T10:10:10", dateAssigned: "2019-01-19T10:10:10", dateCompleted: "2019-01-19T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2019-03-10T10:10:10", dateAssigned: "2019-03-10T10:10:10", dateCompleted: "2019-03-10T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2018-12-30T10:10:10", dateAssigned: "2018-12-30T10:10:10", dateCompleted: "2018-12-30T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2018-12-15T10:10:10", dateAssigned: "2018-12-15T10:10:10", dateCompleted: "2018-12-15T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED, dueDate: "2018-11-30T10:10:10", dateAssigned: "2018-11-30T10:10:10", dateCompleted: "2018-11-30T10:10:10"));
      goals.add(new TempTestGoal(status: S_COMPLETED_LATE, dueDate: "2018-11-30T10:10:10", dateAssigned: "2018-11-30T10:10:10", dateCompleted: "2018-11-30T10:10:10"));



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


      for(TempTestGoal g in goals){
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

    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
    _scrollController = ScrollController();


    processFuture().then((arg) {
    }, onError: (e) {
      print(e);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new MenuDrawer(),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool boxScrolled){
          return <Widget>[
            SliverAppBar(
              title: Text("Performance"),
              pinned: true,
              floating: true,
              forceElevated: boxScrolled,
              bottom: TabBar(
                onTap: (int idx){
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                },
                tabs: <Widget>[
                  Tab(
                    text: "4 Months",
                  ),
                  Tab(
                    text: "8 Months",
                  ),
                  Tab(
                    text: "12 Months"
                  ),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            PerformanceTab(data["4 Months"], 4),
            PerformanceTab(data["8 Months"], 8),
            PerformanceTab(data["12 Months"], 12)
          ],
          controller: _tabController,
        ),
      ),
    );
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

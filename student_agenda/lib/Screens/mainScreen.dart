import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:intl/intl.dart';
import 'package:student_agenda/Screens/performanceScreen.dart';
import 'package:student_agenda/Utilities/util.dart';
import 'package:student_agenda/Utilities/goal.dart';
import 'package:student_agenda/FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:student_agenda/Screens/listedGoalsScreen.dart';

class MainDashboardScreen extends StatefulWidget {
  MainDashboardScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  double performancePercent = 70;

  List<Goal> _goals = new List<Goal>();
  List<classroom.Course> _courses = new List<classroom.Course>();
  List<classroom.CourseWork> _courseWorks = new List<classroom.CourseWork>();

  Future<void> processFuture() async {
    List<Goal> tempGoals =
        await pullGoals(firebaseUser, "CourseWorkGoalObjects");
    tempGoals.addAll(await pullGoals(firebaseUser, "CourseGoalObjects"));
    tempGoals.removeWhere((goal) =>
        goal.dueDate.compareTo(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) <
        0);
    tempGoals.sort((a, b) => DateTime(a.dueDate.year, a.dueDate.month,
            a.dueDate.day, a.dueDate.hour, a.dueDate.minute, a.dueDate.second)
        .compareTo(DateTime(b.dueDate.year, b.dueDate.month, b.dueDate.day,
            b.dueDate.hour, b.dueDate.minute, b.dueDate.second)));

    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);

    List<classroom.CourseWork> tempCourseWorks =
        await pullCourseWorkData(firebaseUser);

    setState(() {
      _goals = tempGoals;
      _courses = tempCourses;
      _courseWorks = tempCourseWorks;
    });
  }

  @override
  void initState() {
    super.initState();
    processFuture().then((arg) {}, onError: (e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Main'),
      ),

      //draw the sidebar menu options
      drawer: MenuDrawer(),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PerformanceScreen()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Heading(text: 'Task Completion Performance'),
                RoundedProgressBar(
                  style: RoundedProgressBarStyle(
                    widthShadow: 0,
                    colorProgress: Colors.green,
                    backgroundProgress: Color(0xffc8e6c9),
                  ),
                  childLeft: Text("$performancePercent%",
                      style: TextStyle(color: Colors.white)),
                  percent: performancePercent,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Heading(text: 'Upcoming Tasks'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: (_goals.length > 3) ? 3 + 1 : _goals.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return buildList(index);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 10),
            ),
          ),
          Center(
            child: (_goals.length > 1)
                ? FlatButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.green, width: 3),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListedGoalsScreen()));
                    },
                    child: Text(
                      "View More Tasks",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )
                : Container(width: 0, height: 0),
          )
        ],
      ),
    );
  }

  Color getBoxColor(index) {
    if (index != 0) {
      int realIndex = index - 1;
      if (_goals[realIndex].getStatus() != S_COMPLETED &&
          _goals[realIndex].getStatus() != S_COMPLETED_LATE) {
        return Colors.green[100];
      } else {
        return Colors.grey;
      }
    }
    return Colors.red;
  }

  Container buildList(index) {
    if (index == 0) {
      return Container(width: 0, height: 0);
    } else {
      int realIndex = index - 1;

      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: getBoxColor(index),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Course: ${_courses.firstWhere((course) => course.id == _goals[realIndex].getCourseId(), orElse: () => classroom.Course()).name}',
              style: TextStyle(fontSize: 18),
            ),
            (_goals[realIndex].getCourseWorkId() != "-1")
                ? Text(
                    'Course Work: ${_courseWorks.firstWhere((courseWork) => courseWork.courseId == _goals[realIndex].getCourseId() && courseWork.id == _goals[realIndex].getCourseWorkId(), orElse: () => classroom.CourseWork()).description}'
                        .replaceAll(new RegExp(r"null$"), "N/A"),
                    style: TextStyle(fontSize: 18),
                  )
                : Container(width: 0, height: 0),
            Text(
              'Task: ${_goals[realIndex].name}',
              style: TextStyle(fontSize: 18),
            ),
            (_goals[realIndex].text) != ""
                ? Text(
                    'Description: ${_goals[realIndex].text}',
                    style: TextStyle(fontSize: 18),
                  )
                : Container(width: 0, height: 0),
            Text(
              'Due: ${DateFormat("EEEE, MMM. d, yyyy").format(DateTime(_goals[realIndex].dueDate.year, _goals[realIndex].dueDate.month, _goals[realIndex].dueDate.day, _goals[realIndex].dueDate.hour, _goals[realIndex].dueDate.minute, _goals[realIndex].dueDate.second))}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Status: ${_goals[realIndex].getStatus().replaceAll("_", " ")}',
              style: TextStyle(fontSize: 18),
            ),
            completeGoalButton(index)
          ],
        ),
      );
    }
  }

  RaisedButton completeGoalButton(index) {
    if (index != 0) {
      int realIndex = index - 1;
      if (_goals[realIndex].getStatus() != S_COMPLETED &&
          _goals[realIndex].getStatus() != S_COMPLETED_LATE) {
        return RaisedButton(
          onPressed: () {
            setState(() {
              _goals[realIndex].completeGoal();
              List<Goal> goal = List<Goal>();
              goal.add(_goals[realIndex]);
              setUserCourseGoals(
                  firebaseUser,
                  goal,
                  (_goals[realIndex].getCourseWorkId() == "-1")
                      ? "CourseGoalObjects"
                      : "CourseWorkGoalObjects",
                  toMerge: true);
            });
          },
          child:
              const Text('Complete This Goal', style: TextStyle(fontSize: 20)),
        );
      } else {
        return RaisedButton(
          onPressed: null,
          child:
              const Text('Complete This Goal', style: TextStyle(fontSize: 20)),
        );
      }
    }
    return RaisedButton(
      onPressed: null,
      child: const Text('Complete This Goal', style: TextStyle(fontSize: 20)),
    );
  }
}

class Heading extends StatelessWidget {
  final String text;

  const Heading({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

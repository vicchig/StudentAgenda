import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_agenda/Utilities/util.dart';
import 'package:student_agenda/Utilities/goal.dart';
import 'package:student_agenda/FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import '../Screens/addGoalsScreen.dart';

class ListedGoalsScreen extends StatefulWidget {
  ListedGoalsScreen({Key key}) : super(key: key);

  @override
  ListedGoalsScreenState createState() => ListedGoalsScreenState();
}

class ListedGoalsScreenState extends State<ListedGoalsScreen> {
  List<Goal> _goals = new List<Goal>();
  List<classroom.Course> _courses = new List<classroom.Course>();
  List<classroom.CourseWork> _courseWorks = new List<classroom.CourseWork>();

  DateTime currentDate = DateTime(2019);

  Future<void> processFuture() async {
    List<Goal> tempGoals =
    await pullGoals(firebaseUser, "CourseWorkGoalObjects");
    tempGoals.addAll(await pullGoals(firebaseUser, "CourseGoalObjects"));
    tempGoals.sort((a, b) =>
        DateTime(a.dueDate.year, a.dueDate.month,
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
    processFuture().then((arg) {
      currentDate = (_goals.length > 0) ? _goals[0].dueDate : DateTime(2019);
    }, onError: (e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Task List'),
      ),

      //draw the sidebar menu options
      drawer: MenuDrawer(),

      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _goals.length,
        itemBuilder: (BuildContext context, int index) {
          return buildList(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddGoalsScreen()));
          }),
    );
    }

  Color getBoxColor(index) {
    if (_goals[index].getStatus() != S_COMPLETED &&
        _goals[index].getStatus() != S_COMPLETED_LATE) {
      return Colors.green[100];
    } else {
      return Colors.grey;
    }
  }

  Column buildList(index) {
    bool header = true;

    if (index == 0) {
      currentDate = _goals[0].dueDate;
      header = false;
    } else if (index != 0 &&
        DateTime(_goals[index].dueDate.year, _goals[index].dueDate.month,
            _goals[index].dueDate.day)
            .compareTo(DateTime(
            _goals[index - 1].dueDate.year,
            _goals[index - 1].dueDate.month,
            _goals[index - 1].dueDate.day)) !=
            0) {
      currentDate = _goals[index].dueDate;
      header = false;
    }

    if (header == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Center(
            child: Text(
              '${DateFormat("EEEE, MMM. d, yyyy").format(currentDate)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: getBoxColor(index),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Course: ${_courses
                      .firstWhere((course) =>
                  course.id == _goals[index].getCourseId(),
                      orElse: () => classroom.Course())
                      .name}',
                  style: TextStyle(fontSize: 18),
                ),
                (_goals[index].getCourseWorkId() != "-1")
                    ? Text(
                  'Course Work: ${_courseWorks
                      .firstWhere((courseWork) =>
                  courseWork.courseId == _goals[index].getCourseId() &&
                      courseWork.id == _goals[index].getCourseWorkId(),
                      orElse: () => classroom.CourseWork())
                      .description}'
                      .replaceAll(new RegExp(r"null$"), "N/A"),
                  style: TextStyle(fontSize: 18),
                )
                    : Container(width: 0, height: 0),
                Text(
                  'Task: ${_goals[index].name}',
                  style: TextStyle(fontSize: 18),
                ),
                (_goals[index].text) != ""
                    ? Text(
                  'Description: ${_goals[index].text}',
                  style: TextStyle(fontSize: 18),
                )
                    : Container(width: 0, height: 0),
                Text(
                  'Date Assigned: ${DateFormat("yyyy/MM/dd hh:mm aaa").format(
                      _goals[index].getDateAssigned())}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Status: ${_goals[index].getStatus().replaceAll("_", " ")}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Due: ${DateFormat("EEEE, MMM. d, yyyy").format(DateTime(
                      _goals[index].dueDate.year, _goals[index].dueDate.month,
                      _goals[index].dueDate.day, _goals[index].dueDate.hour,
                      _goals[index].dueDate.minute,
                      _goals[index].dueDate.second))}',
                  style: TextStyle(fontSize: 18),
                ),
                (_goals[index].getStatus() == S_COMPLETED ||
                    _goals[index].getStatus() == S_COMPLETED_LATE)
                    ? Text(
                  'Date Completed: ${DateFormat("yyyy/MM/dd hh:mm aaa").format(
                      _goals[index].getDateCompleted())}',
                  style: TextStyle(fontSize: 18),
                )
                    : Container(width: 0, height: 0),
                completeGoalButton(index)
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Divider(),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: getBoxColor(index),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Course: ${_courses
                    .firstWhere((course) =>
                course.id == _goals[index].getCourseId(),
                    orElse: () => classroom.Course())
                    .name}',
                style: TextStyle(fontSize: 18),
              ),
              (_goals[index].getCourseWorkId() != "-1")
                  ? Text(
                'Course Work: ${_courseWorks
                    .firstWhere((courseWork) =>
                courseWork.courseId == _goals[index].getCourseId() &&
                    courseWork.id == _goals[index].getCourseWorkId(),
                    orElse: () => classroom.CourseWork())
                    .description}'
                    .replaceAll(new RegExp(r"null$"), "N/A"),
                style: TextStyle(fontSize: 18),
              )
                  : Container(width: 0, height: 0),
              Text(
                'Task: ${_goals[index].name}',
                style: TextStyle(fontSize: 18),
              ),
              (_goals[index].text) != ""
                  ? Text(
                'Description: ${_goals[index].text}',
                style: TextStyle(fontSize: 18),
              )
                  : Container(width: 0, height: 0),
              Text(
                'Due: ${DateFormat("EEEE, MMM. d, yyyy").format(DateTime(
                    _goals[index].dueDate.year, _goals[index].dueDate.month,
                    _goals[index].dueDate.day, _goals[index].dueDate.hour,
                    _goals[index].dueDate.minute,
                    _goals[index].dueDate.second))}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Status: ${_goals[index].getStatus().replaceAll("_", " ")}',
                style: TextStyle(fontSize: 18),
              ),
              completeGoalButton(index)
            ],
          ),
        ),
      ],
    );
  }

  RaisedButton completeGoalButton(index) {
    if (_goals[index].getStatus() != S_COMPLETED &&
        _goals[index].getStatus() != S_COMPLETED_LATE) {
      return RaisedButton(
        onPressed: () {
          setState(() {
            _goals[index].completeGoal();
            List<Goal> specificGoalType = [];
            String courseWorkId = _goals[index].getCourseWorkId();
            for (Goal goal in _goals) {
              if ((courseWorkId == "-1" && goal.getCourseWorkId() == "-1") ||
                  (courseWorkId != "-1" && goal.getCourseWorkId() != "-1")) {
                specificGoalType.add(goal);
              }
            }
            setUserCourseGoals(
                firebaseUser,
                specificGoalType,
                (courseWorkId == "-1")
                    ? "CourseGoalObjects"
                    : "CourseWorkGoalObjects",
                toMerge: true);
          });
        },
        child: const Text('Complete This Goal', style: TextStyle(fontSize: 20)),
      );
    } else {
      return RaisedButton(
        onPressed: null,
        child: const Text('Complete This Goal', style: TextStyle(fontSize: 20)),
      );
    }
  }
}

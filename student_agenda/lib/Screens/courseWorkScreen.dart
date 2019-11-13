import 'package:flutter/material.dart';
import 'package:student_agenda/Utilities/util.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import '../FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/FirestoreDataManager.dart';

class CourseWorkScreen extends StatefulWidget {
  CourseWorkScreen({Key key, @required this.courseID}) : super(key: key);

  final String courseID;

  @override
  CourseWorkScreenState createState() =>
      CourseWorkScreenState(courseID: courseID);
}

class CourseWorkScreenState extends State<CourseWorkScreen> {
  CourseWorkScreenState({@required this.courseID});

  final String courseID;

  final List<String> entries = <String>['A', 'B', 'C'];

  List<classroom.CourseWork> _courseWorks = new List<classroom.CourseWork>();

  void processFuture() async {
    List<classroom.CourseWork> tempCourseWorks =
        await pullCourseWorkData(firebaseUser);

    tempCourseWorks = getCourseWorksForCourse(courseID, tempCourseWorks);
    tempCourseWorks.sort((a, b) => DateTime(
            a.dueDate.year,
            a.dueDate.month,
            a.dueDate.day,
            a.dueTime.hours,
            a.dueTime.minutes,
            a.dueTime.seconds)
        .compareTo(DateTime(b.dueDate.year, b.dueDate.month, b.dueDate.day,
            b.dueTime.hours, b.dueTime.minutes, b.dueTime.seconds)));
    setState(() {
      _courseWorks = tempCourseWorks;
    });
//    for (classroom.CourseWork courseWork in _courseWorks) {
//      print(courseWork.description);
//    }
  }

  @override
  void initState() {
    super.initState();
    processFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Course Works"),
      ),
      drawer: new MenuDrawer(),
      body: new ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _courseWorks.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.green[100].withOpacity(0.75),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Type: ${_courseWorks[index].workType}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Description: ${_courseWorks[index].description}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Due: ${DateTime(_courseWorks[index].dueDate.year, _courseWorks[index].dueDate.month, _courseWorks[index].dueDate.day, _courseWorks[index].dueTime.hours, _courseWorks[index].dueTime.minutes, _courseWorks[index].dueTime.seconds).toString().replaceAll(new RegExp("\\..+"), "")}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

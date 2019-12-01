import 'package:flutter/material.dart';
import 'package:student_agenda/FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/Utilities/util.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:student_agenda/FirestoreDataManager.dart';
import '../Utilities/util.dart';
import '../FirestoreDataManager.dart';
import 'classView.dart';

class teacherAssignmentScreen extends StatefulWidget {
  teacherAssignmentScreen({Key key, @required this.courseID}) : super(key: key);

  final String courseID;

  @override
  teacherAssignmentState createState() =>
      teacherAssignmentState(courseID: courseID);
}

class teacherAssignmentState extends State<teacherAssignmentScreen> {
  teacherAssignmentState({@required this.courseID});

  final String courseID;
  List<classroom.CourseWork> _courseWork = new List<classroom.CourseWork>();

  Future<void> retrieveStudents() async {
    List<classroom.CourseWork> allSubscribedCourseWork =
        await pullCourseWorkData(firebaseUser);
    List<classroom.CourseWork> tempCourseWork =
        getCourseWorksForCourse(courseID, allSubscribedCourseWork);

    setState(() {
      _courseWork = tempCourseWork;
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          new AppBar(title: new Text("Class Assignments"), centerTitle: true),
      drawer: new MenuDrawer(),
      body: new Column(children: <Widget>[
        Text("\n\Assignments\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        new Expanded(
            child: new ListView.builder(
                itemCount: _courseWork.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                      child: ListTile(
                    leading: Icon(Icons.book),
                    title: Text(_courseWork[index].description,
                        style: TextStyle(fontSize: 18)),
                    subtitle: (_courseWork[index].dueDate == null ||
                            _courseWork[index].dueTime == null)
                        ? Text("No Due Date", style: TextStyle(fontSize: 18))
                        : Text(
                            'Due: ${DateTime(_courseWork[index].dueDate.year, _courseWork[index].dueDate.month, _courseWork[index].dueDate.day, _courseWork[index].dueTime?.hours ?? 0, _courseWork[index].dueTime?.minutes ?? 0).toString().replaceAll(new RegExp("\\..+"), "")}',
                            style: TextStyle(fontSize: 18),
                          ),
                  ));
                })),
        FlatButton(
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
                    builder: (context) => ClassViewScreen(courseID: courseID)));
          },
          child: Text(
            "View Class Roster",
            style: TextStyle(fontSize: 20.0),
          ),
        )
      ]),
    );
  }
}

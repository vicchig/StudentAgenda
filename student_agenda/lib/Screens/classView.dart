import 'package:flutter/material.dart';
import 'package:student_agenda/FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/Utilities/util.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:student_agenda/FirestoreDataManager.dart';
import '../Utilities/util.dart';
import '../FirestoreDataManager.dart';

class ClassViewScreen extends StatefulWidget {
  ClassViewScreen({Key key, @required this.courseID}) : super(key: key);

  final String courseID;

  @override
  ClassViewState createState() =>
      ClassViewState(courseID: courseID);

}

class ClassViewState extends State<ClassViewScreen> {
  ClassViewState({@required this.courseID});

  final String courseID;
  List<classroom.Student> _students = new List<classroom.Student>();

  void retrieveStudents() async {
    List<classroom.Student> allSubscribedStudents = await pullClassmates(firebaseUser);
    List<classroom.Student> tempStudents = getClassRoster(courseID, allSubscribedStudents);
    setState(() {
      _students = tempStudents;
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
      appBar: new AppBar(title: new Text("Class Roster"), centerTitle: true),

      drawer: new MenuDrawer(),

      body: new Column(
          children: <Widget>[
            Text("\nStudents\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: _students.length,
                    itemBuilder: (BuildContext context, int index) {
                          return new Card(
                              child: ListTile(
                                leading: Icon(Icons.mood),
                                  title: Text(_students[index].profile.name.fullName),
                                subtitle: Text("Number of goals made: 0\nNumber of goals completed: 0") //Placeholder text
                              )
                          );
                    }
                )
            )
          ]
      ),
    );
  }
}
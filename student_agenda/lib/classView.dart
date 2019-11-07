import 'package:flutter/material.dart';
import 'package:student_agenda/util.dart';
import 'addSubtaskScreen.dart';

class ClassViewScreen extends StatefulWidget {
  @override
  ClassViewState createState() {
    return ClassViewState();
  }
}

class ClassViewState extends State<ClassViewScreen> {
  List<String> students = ["Bobby", "Tom", "Mike"];
  List<String> assignments = ["A1", "A2", "A3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Class"), centerTitle: true),

      drawer: new MenuDrawer(),

      body: new Column(
          children: <Widget>[
            Text("\nAssignments\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: assignments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => AddSubtaskScreen())
                          );
                        },
                          child: new Card(
                              child: ListTile(
                                leading: Icon(Icons.book),
                                title: Text(assignments[index]),
                              )
                      ));
                    }
                )
            ),
            Text("\nStudents\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: students.length,
                    itemBuilder: (BuildContext context, int index) {
                          return new Card(
                              child: ListTile(
                                leading: Icon(Icons.mood),
                                  title: Text(students[index]),
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
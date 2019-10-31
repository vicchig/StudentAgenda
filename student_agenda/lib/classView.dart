import 'package:flutter/material.dart';
import 'package:student_agenda/util.dart';

class ClassViewScreen extends StatefulWidget {
  @override
  ClassViewState createState() {
    return ClassViewState();
  }
}

class ClassViewState extends State<ClassViewScreen> {
  List<String> students = ["Bobby", "Tom", "Mike"];
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Students"), centerTitle: true),

      drawer: new MenuDrawer(),

      body: new Column(
          children: <Widget>[
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
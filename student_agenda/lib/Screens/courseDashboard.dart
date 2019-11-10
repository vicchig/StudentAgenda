import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_agenda/Utilities/auth.dart';
import '../FirestoreManager.dart';
import '../Utilities/util.dart';
import 'courseGoalsScreen.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;


class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState(){
    return DashboardScreenState();
  }
}

class DashboardScreenState extends State<DashboardScreen> {
  List<classroom.Course> _courses = new List<classroom.Course>();
  List<classroom.Student> _classmates = new List<classroom.Student>();

  void processFuture() async {
    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);
    List<classroom.Student> tempStudents = await pullClassmates(firebaseUser);
    setState(()  {
      _courses = tempCourses;
      _classmates = tempStudents;
    });
  }

  @override
  void initState() {
    super.initState();
    processFuture();
    print("state");
  }

  @override
  Widget build(BuildContext context){
    if(_classmates.length > 0){
      _classmates.forEach((classroom.Student s) {
        //print(s.profile.name.fullName);
      });
    }
    return Scaffold( //Sidebar menu scaffold
      appBar: new AppBar(
        title: new Text('My Courses'),
        centerTitle: true,
      ),

      //draw the sidebar menu options
      drawer: new MenuDrawer(),

      body: GridView.count( //holds all of our course buttons
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: getCourses(context)
      ),

    );
    //------------------------------

  }

  ///Obtain courses from Google Classroom and return a list of NavigationButtons
  ///which represent the courses.
  ///
  /// @param context  current application context
  /// @return         a list of NavigationButtons (one per course)
  List<Widget> getCourses(BuildContext context) { //TODO: Load students' courses off of Google Classroom and do the logic for adding them to the widget here
    final courseColours = [Colors.greenAccent, Colors.lightBlueAccent, Colors.orangeAccent,
      Colors.redAccent, Colors.amberAccent, Colors.indigoAccent, Colors.pinkAccent, Colors.limeAccent];

    final List<Widget> courseButtons = [];
    int coloursI = 0;
    for(classroom.Course course in _courses){
      courseButtons.add(
        new CustomMaterialButton(
          text: course.name,
          colour: courseColours[coloursI],
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => CourseGoalsScreen()),
            );
          },
        ),
      );
      coloursI++;
    }
    return courseButtons;
  }
}
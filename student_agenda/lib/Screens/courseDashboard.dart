import 'package:flutter/material.dart';
import 'package:student_agenda/FirestoreDataManager.dart';
import 'package:student_agenda/Utilities/auth.dart';
import '../FirestoreManager.dart';
import '../Utilities/util.dart';
import 'courseWorkScreen.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:firebase_auth/firebase_auth.dart'; //For the firebase user
import './classView.dart';

class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState() {
    return DashboardScreenState();
  }
}

class DashboardScreenState extends State<DashboardScreen> {
  List<classroom.Course> _courses = new List<classroom.Course>();

  Future<void> processFuture() async {
    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);
    tempCourses.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    setState(() {
      _courses = tempCourses;
    });
  }

  @override
  void initState() {
    super.initState();
    processFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Sidebar menu scaffold
      appBar: new AppBar(
        title: new Text('My Courses'),
        centerTitle: true,
      ),

      //draw the sidebar menu options
      drawer: new MenuDrawer(),

      body: GridView.count(
        //holds all of our course buttons
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: getCourses(context)),
    );
    //------------------------------
  }

  ///Obtain courses from Google Classroom and return a list of NavigationButtons
  ///which represent the courses.
  ///
  /// @param context  current application context
  /// @return         a list of NavigationButtons (one per course)
  List<Widget> getCourses(BuildContext context) {
    //TODO: Load students' courses off of Google Classroom and do the logic for adding them to the widget here
    final courseColours = [
      Colors.greenAccent,
      Colors.lightBlueAccent,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.amberAccent,
      Colors.indigoAccent,
      Colors.pinkAccent,
      Colors.limeAccent
    ];

    final List<Widget> courseButtons = [];
    int coloursI = 0;
    for (classroom.Course course in _courses) {
      courseButtons.add(
        new CustomMaterialButton(
          text: course.name,
          colour: courseColours[coloursI],
          onPressed: () async {
            if (await isTeacher(firebaseUser, course.id)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassViewScreen(courseID: course.id)
                )
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CourseWorkScreen(courseID: course.id)),
              );
            }

          },
        ),
      );
      coloursI++;
    }
    return courseButtons;
  }
}

//Determine whether or not the current user is a teacher of a specific course.
//
// @param user     the current user
// @param courseID the courseID to lookup
// @param inst     the current classroom context
// @return         a boolean representing whether or not the user is a teacher
Future<bool> isTeacher(FirebaseUser user, String courseID) async {
  List<classroom.Teacher> subscribedTeachers = await pullTeachers(firebaseUser);
  List<classroom.Teacher> teachers = getCourseTeachers(courseID, subscribedTeachers);
  for (int i = 0; i < teachers.length; i++) {
    if (user.displayName == teachers[i].profile.name.fullName) {
      return true;
    }
  }
  return false;
}
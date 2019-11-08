import 'package:flutter/material.dart';
import 'package:student_agenda/ClassroomApiAccess.dart';
import 'util.dart';
import 'courseGoalsScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState(){
    return DashboardScreenState();
  }
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
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
  List<Widget> getCourses(BuildContext context){ //TODO: Load students' courses off of Google Classroom and do the logic for adding them to the widget here
    final courses = ['Course 1', 'Course 2', 'Course 3', 'Course 4', 'Course 5',
      'Course 6', 'Course 7', 'Course 8'];
    final courseColours = [Colors.greenAccent, Colors.lightBlueAccent, Colors.orangeAccent,
      Colors.redAccent, Colors.amberAccent, Colors.indigoAccent, Colors.pinkAccent, Colors.limeAccent];

    final List<Widget> courseButtons = [];
    int coloursI = 0;
    for(var course in courses){
      courseButtons.add(
        new NavigationButton(
          text: course,
          colour: courseColours[coloursI],
          onPressed: (){
            ClassroomApiAccess instance = ClassroomApiAccess.getInstance();
            instance.getCourses();
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
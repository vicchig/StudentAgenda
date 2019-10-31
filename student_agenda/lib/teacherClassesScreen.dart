import 'package:flutter/material.dart';
import 'util.dart';
import 'courseGoalsScreen.dart';

class TeacherClassesScreen extends StatefulWidget {
  @override
  TeacherClassesState createState() {
    return TeacherClassesState();
  }
}

class TeacherClassesState extends State<TeacherClassesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("My Classes"),
        centerTitle: true
      ),

        drawer: new MenuDrawer(),

        body: GridView.count( //holds all of our course buttons
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: getClasses(context)
        )

    );
  }

  ///Obtain courses from Google Classroom and return a list of NavigationButtons
  ///which represent the classes.
  ///
  /// @param context  current application context
  /// @return a list of NavigationButtons (one per class)
  List<Widget> getClasses(BuildContext context){
    final classes = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
      'Class 6', 'Class 7', 'Class 8'];
    final classColours = [Colors.greenAccent, Colors.lightBlueAccent, Colors.orangeAccent,
      Colors.redAccent, Colors.amberAccent, Colors.indigoAccent, Colors.pinkAccent, Colors.limeAccent];

    final List<Widget> classButtons = [];
    int coloursI = 0;
    for (var teacherClass in classes){
      classButtons.add(
        new NavigationButton(
          text: teacherClass,
          colour: classColours[coloursI],
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => CourseGoalsScreen()),
            );
          },
        ),
      );
      coloursI++;
    }
    return classButtons;
  }
}


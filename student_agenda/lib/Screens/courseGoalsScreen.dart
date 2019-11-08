import 'package:flutter/material.dart';
import 'package:student_agenda/Utilities/util.dart';


class CourseGoalsScreen extends StatefulWidget{
  CourseGoalsScreen({Key key}) : super(key: key);

  @override
  CourseGoalsScreenState createState() => CourseGoalsScreenState();
}

class CourseGoalsScreenState extends State<CourseGoalsScreen> with TickerProviderStateMixin {
  AnimationController logoController;

  @override
  void initState() {
    logoController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text("Test Page"),
      ),
      drawer: new MenuDrawer(),
      body: new Text("Placeholder Text"),
    );

  }
}
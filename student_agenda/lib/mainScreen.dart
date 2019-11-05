import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:student_agenda/listedGoalsScreen.dart';
import 'package:student_agenda/performanceScreen.dart';
import 'package:student_agenda/tasks.dart';
import 'package:student_agenda/util.dart';

class MainDashboardScreen extends StatefulWidget {
  MainDashboardScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  double performancePercent = 70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Main'),
      ),

      //draw the sidebar menu options
      drawer: MenuDrawer(),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PerformanceScreen()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Heading(text: 'Task Completion Performance'),
                RoundedProgressBar(
                  style: RoundedProgressBarStyle(
                    widthShadow: 0,
                    colorProgress: Colors.green,
                    backgroundProgress: Color(0xffc8e6c9),
                  ),
                  childLeft: Text("$performancePercent%",
                      style: TextStyle(color: Colors.white)),
                  percent: performancePercent,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Heading(text: 'Upcoming Tasks'),
          TaskList(length: Task.dates.length),
          Center(
            child: (Task.dates.length > 1)
                ? FlatButton(
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
                              builder: (context) => ListedGoalsScreen()));
                    },
                    child: Text(
                      "View More Tasks",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )
                : Container(width: 0, height: 0),
          )
        ],
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String text;

  const Heading({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final int length;

  const TaskList({
    Key key,
    @required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (length == 0) {
      return Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'No Upcoming Tasks',
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          final date = Task.dates[index];

          return Task.subtaskDropbox(context, date);
        },
      ),
    );
  }
}

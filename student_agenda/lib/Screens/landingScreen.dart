import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_agenda/Screens/mainScreen.dart';
import 'package:student_agenda/Screens/calendarScreen.dart';
import 'package:custom_navigator/custom_navigator.dart';
import 'package:custom_navigator/custom_scaffold.dart';


class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;

  // TODO:ADD THE GENERAL GOALS SCREEN AND CHAT SCREEN TO REPLACE THE CONTAINERS
  final List<Widget> _children = [
    MainDashboardScreen(),
    CalendarScreen(),
    Container(),
    Container()
  ];

  GlobalKey<_LandingScreenState> navKey = GlobalKey<_LandingScreenState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffold: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Dashboard")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  title: Text("Calendar")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  title: Text("Goals")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble),
                  title: Text("Chat")
              )
            ]
        ),
      ),
      children: _children,
      onItemTap: (index) {},
    );
  }
}
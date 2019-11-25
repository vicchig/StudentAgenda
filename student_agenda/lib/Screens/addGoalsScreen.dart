import 'package:flutter/material.dart';
import '../Utilities/util.dart';
import 'package:student_agenda/Screens/courseGoalsScreen.dart';
import 'package:student_agenda/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:async';
import 'dart:collection';

class AddGoalsScreen extends StatefulWidget {
  @override
  AddGoalsScreenState createState() {
    return AddGoalsScreenState();
  }
}

class AddGoalsScreenState extends State<AddGoalsScreen> {
  static var subtasks = [
    'Write the intro paragraph',
    'Write the first body',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion' 'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion',
    'Write the conclusion'
  ];
  var selectedSubtask =
      null; // NOTE: Depending on implementation, may need to check for empty

  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Sidebar menu scaffold
      appBar: new AppBar(
        title: new Text('Add Goals'),
        centerTitle: true,
      ),

      //draw the sidebar menu options
      drawer: new MenuDrawer(),

      body: Column(children: [
        SizedBox(height: 140),
        subtaskDropbox(context),
        SizedBox(height: 30),
        datepicker(context),
        SizedBox(height: 80),
        addButton(context),
      ]),
    );
  }

  Widget subtaskDropbox(BuildContext context) {
    Widget dropdownbox = Align(
      alignment: Alignment.center,
      child: DropdownButton<String>(
        items: subtasks.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(
              dropDownStringItem,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (String newValueSelected) {
          _onDropDownItemSelected(newValueSelected);
        },
        underline: Container(),
        hint: Text('Subtask', style: TextStyle(fontStyle: FontStyle.italic)),
        value: selectedSubtask,
        isExpanded: true,
        style: TextStyle(
            color: Colors.green, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );

    Widget alignedBox = Align(
      alignment: Alignment(0.0, -0.7),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 3,
            ),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0))),
        height: 50,
        width: 330,
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: dropdownbox,
      ),
    );

    return alignedBox;
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this.selectedSubtask = newValueSelected;
    });
  }

  Widget datepicker(BuildContext context) {
    Widget retDate = FlatButton(
      onPressed: () => _selectDate(context),
      textColor: Colors.green,
      color: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.green, width: 3)),
      child: Container(
        height: 50,
        width: 330,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Text(
            "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );

    return retDate;
  }

  Widget addButton(BuildContext context) {
    Widget retButton = FlatButton(
      onPressed: () => finalizeSubtask(),
      textColor: Colors.white,
      color: Colors.green,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.green, width: 3)),
      child: Container(
        height: 70,
        width: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Text('Add',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
      ),
    );
    return retButton;
  }

  void finalizeSubtask() {
    _scheduleNotifications();
    print('Adding subtask ...');
  }

  Future<void> _scheduleNotifications() async {
    // TODO: DECIDE WHICH INTERVAL WE WANT TO SCHEDULE NOTIFS ON
    bool hasPassed = this.selectedDate.isBefore(DateTime.now());

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id', // temp
      'channel name', // temp
      'channel description', // temp
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    // Note that each check for hasPassed is separate so we can easily add
    // another condition later.

    // We can wrap this in an if based on things we get from settings
    // 1 hour notification
    //DateTime hourDate = this.selectedDate.subtract(Duration(hours: 1));
    // This time is for testing purposes
    DateTime hourDate = DateTime.now().add(Duration(seconds: 5));
    if (!hasPassed) {
      await flutterLocalNotificationsPlugin.schedule(
          0, // TODO: is there a unique ID for a user I can access?
          "${this.selectedSubtask} is due in 1 hour.",
          "Check in with your agenda or tap this notification for details!",
          hourDate,
          platformChannelSpecifics);
    }

    // 1 day notification
    // DateTime dayDate = this.selectedDate.subtract(Duration(days: 1));
    // This time is for testing purposes
    DateTime dayDate = DateTime.now().add(Duration(seconds: 10));
    if (!hasPassed) {
      await flutterLocalNotificationsPlugin.schedule(
          1,
          "${this.selectedSubtask} is due in 1 day.",
          "Check in with your agenda or tap this notification for details!",
          dayDate,
          platformChannelSpecifics);
    }

    // 1 week notification
    //DateTime weekDate = this.selectedDate.subtract(Duration(days: 7));
    // This time is for testing purposes
    DateTime weekDate = DateTime.now().add(Duration(seconds: 20));
    if (!hasPassed) {
      await flutterLocalNotificationsPlugin.schedule(
          2,
          "${this.selectedSubtask} is due in 1 week.",
          "Check in with your agenda or tap this notification for details!",
          weekDate,
          platformChannelSpecifics);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:student_agenda/FirestoreDataManager.dart';
import '../Utilities/util.dart';
import 'package:student_agenda/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/FirestoreManager.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'dart:async';
import 'dart:collection';
import '../Utilities/goal.dart';

class AddGoalsScreen extends StatefulWidget {
  @override
  AddGoalsScreenState createState() {
    return AddGoalsScreenState();
  }
}

class AddGoalsScreenState extends State<AddGoalsScreen> {
  List<classroom.Course> _courses = new List<classroom.Course>();
  List<classroom.CourseWork> _courseWork = new List<classroom.CourseWork>();
  List<classroom.CourseWork> _original = new List<classroom.CourseWork>();
  List<classroom.Teacher> _teachers = new List<classroom.Teacher>();
  HashMap courseToTeacher = new HashMap<String, classroom.Teacher>();

  void processFuture() async {
    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);
    List<classroom.CourseWork> tempWork =
    await pullCourseWorkData(firebaseUser);
    List<classroom.Teacher> tempTeachers = await pullTeachers(firebaseUser);
    setState(() {
      _courses = tempCourses;
      _courseWork = tempWork;
      _original = tempWork;
      _teachers = tempTeachers;
      createCourseTeacherMap();
    });
  }

  @override
  void initState() {
    super.initState();
    processFuture();
  }

  static var subtasks = [
    'Write the intro paragraph',
    'Write the first body',
    'Write the body paragraphs',
    'Write the conclusion',
    'Other'
  ];
  String selectedSubtask =
  null; // NOTE: Depending on implementation, may need to check for empty
  classroom.Course selectedCourse = null;
  classroom.CourseWork selectedCourseWork = null;

  String otherSubtask = null;

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

      body: ListView(children: [
        SizedBox(height: 70),
        courseDropbox(context),
        SizedBox(height: 20),
        courseWorkDropbox(context),
        SizedBox(height: 20),
        subtaskDropbox(context),
        (selectedSubtask == 'Other')
            ? SizedBox(height: 20)
            : SizedBox(height: 0),
        (selectedSubtask == 'Other')
            ? otherTextfield(context)
            : SizedBox(height: 0),
        SizedBox(height: 20),
        datepicker(context),
        SizedBox(height: 80),
        Align(alignment: Alignment.center, child: addButton(context))
      ]),
    );
  }

  Widget courseWorkDropbox(BuildContext context) {
    Widget dropdownbox = Align(
      alignment: Alignment.center,
      child: DropdownButton<classroom.CourseWork>(
        value: selectedCourseWork,
        items: _courseWork.map((classroom.CourseWork dropDownItem) {
          return DropdownMenuItem<classroom.CourseWork>(
            value: dropDownItem,
            child: Text(
              trimDescription(dropDownItem.description),

              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (classroom.CourseWork newValueSelected) {
          _onDropDownItemSelectedCourseWork(newValueSelected);
        },
        underline: Container(),
        hint: Text('Goal for the Course',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: (selectedCourse == null)
                    ? Color.fromRGBO(200, 200, 200, 1.0)
                    : Colors.green)),
        isExpanded: true,
        style: TextStyle(
            color: (selectedCourse == null)
                ? Color.fromRGBO(200, 200, 200, 1.0)
                : Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );

    Widget alignedBox = IgnorePointer(
      ignoring: selectedCourse == null,
      ignoringSemantics: selectedCourse == null,
      child: Align(
        alignment: Alignment(0.0, -0.7),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: (selectedCourse == null)
                    ? Color.fromRGBO(200, 200, 200, 1.0)
                    : Colors.green,
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
      ),
    );

    return alignedBox;
  }

  Widget otherTextfield(BuildContext context) {
    Widget textField = Container(
      child: TextField(
        style: TextStyle(fontSize: 18, color: Colors.green),
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: (selectedCourse == null)
                  ? Color.fromRGBO(200, 200, 200, 1.0)
                  : Colors.greenAccent),
          hintText: 'What goal did you have in mind?',
          border: InputBorder.none,
        ),
        onChanged: (text) {
          _setOtherSubtask(text);
        },
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
        child: textField,
      ),
    );
    return alignedBox;
  }

  Widget courseDropbox(BuildContext context) {
    Widget dropdownbox = Align(
      alignment: Alignment.center,
      child: DropdownButton<classroom.Course>(
        value: selectedCourse,
        items: _courses.map((classroom.Course dropDownItem) {
          return DropdownMenuItem<classroom.Course>(
            value: dropDownItem,
            child: Text(
              (dropDownItem.ownerId != null)
                  ? createTeacherCourseOption(dropDownItem)
                  : "Someone" + "'s " + dropDownItem.name.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (classroom.Course newValueSelected) {
          _onDropDownItemSelectedCourse(newValueSelected);
        },
        underline: Container(),
        hint: Text('Course', style: TextStyle(fontStyle: FontStyle.italic)),
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

  Widget subtaskDropbox(BuildContext context) {
    Widget dropdownbox = Align(
      alignment: Alignment.center,
      child: DropdownButton<String>(
        value: selectedSubtask,
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
        hint: Text('Goal',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: (selectedCourse == null)
                    ? Color.fromRGBO(200, 200, 200, 1.0)
                    : Colors.greenAccent)),
        isExpanded: true,
        style: TextStyle(
            color: (selectedCourse == null)
                ? Color.fromRGBO(200, 200, 200, 1.0)
                : Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );

    Widget alignedBox = IgnorePointer(
      ignoring: selectedCourse == null,
      ignoringSemantics: selectedCourse == null,
      child: Align(
        alignment: Alignment(0.0, -0.7),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: (selectedCourse == null)
                    ? Color.fromRGBO(200, 200, 200, 1.0)
                    : Colors.green,
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
      ),
    );

    return alignedBox;
  }

  void _setOtherSubtask(String otherSubtask) {
    setState(() {
      this.otherSubtask = otherSubtask;
    });
  }

  void _onDropDownItemSelectedCourse(classroom.Course newValueSelected) {
    setState(() {
      this.selectedCourse = newValueSelected;
      this._courseWork =
          getCourseWorksForCourse(this.selectedCourse.id, this._original);
      this.selectedCourseWork = null;
    });
  }

  void _onDropDownItemSelectedCourseWork(
      classroom.CourseWork newValueSelected) {
    setState(() {
      this.selectedCourseWork = newValueSelected;
    });
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this.selectedSubtask = newValueSelected;
    });
  }

  String trimDescription(String description) {
    if (description.contains('\n')) {
      return description.substring(0, description.indexOf('\n')) + " ...";
    }
    return description;
  }

  Widget datepicker(BuildContext context) {
    Widget flatButton = FlatButton(
      onPressed: () => _selectDate(context),
      textColor: (selectedCourse == null)
          ? Color.fromRGBO(200, 200, 200, 1.0)
          : Colors.green,
      child: Text(
          "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
    );

    Widget retDate = IgnorePointer(
      ignoring: selectedCourse == null,
      ignoringSemantics: selectedCourse == null,
      child: Align(
        alignment: Alignment(0.0, -0.7),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(226, 240, 217, 1.0),
              border: Border.all(
                color: (selectedCourse == null)
                    ? Color.fromRGBO(200, 200, 200, 1.0)
                    : Colors.green,
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
          child: flatButton,
        ),
      ),
    );

    return retDate;
  }

  Widget addButton(BuildContext context) {
    Widget retButton = IgnorePointer(
        ignoring: selectedCourse == null ||
            selectedSubtask == null ||
            (selectedSubtask == 'Other' && otherSubtask == null),
        ignoringSemantics: selectedCourse == null ||
            selectedSubtask == null ||
            (selectedSubtask == 'Other' && otherSubtask == null),
        child: FlatButton(
          onPressed: () => finalizeSubtask(),
          textColor: Colors.white,
          color: (selectedCourse == null ||
              selectedSubtask == null ||
              (selectedSubtask == 'Other' && otherSubtask == null))
              ? Color.fromRGBO(200, 200, 200, 1.0)
              : Colors.green,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
              side: BorderSide(
                  color: (selectedCourse == null ||
                      selectedSubtask == null ||
                      (selectedSubtask == 'Other' && otherSubtask == null))
                      ? Color.fromRGBO(200, 200, 200, 1.0)
                      : Colors.green,
                  width: 3)),
          child: Container(
            height: 70,
            width: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: Text('Add',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
          ),
        ));
    return retButton;
  }

  Future<void> _scheduleNotifications() async {
    // TODO: DECIDE WHICH INTERVAL WE WANT TO SCHEDULE NOTIFS ON\
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
    DateTime hourDate = this.selectedDate.add(Duration(
      seconds: 30
    )).subtract(Duration(hours: 1));

    bool hasPassed = hourDate.add(Duration(
      seconds: 30
    )).isBefore(DateTime.now());

    if (!hasPassed) {
      await flutterLocalNotificationsPlugin.schedule(
          0, // TODO: is there a unique ID for a user I can access?
          "${this.selectedSubtask} is due in 1 hour.",
          "Check in with your agenda or tap this notification for details!",
          hourDate,
          platformChannelSpecifics);
    }

    // 1 day notification
    DateTime dayDate = this.selectedDate.add(Duration(
        seconds: 30)).subtract(Duration(days: 1));

    hasPassed = dayDate.add(Duration(
      seconds: 30
    )).isBefore(DateTime.now());

    if (!hasPassed) {
      await flutterLocalNotificationsPlugin.schedule(
          1,
          "${this.selectedSubtask} is due in 1 day.",
          "Check in with your agenda or tap this notification for details!",
          dayDate,
          platformChannelSpecifics);
    }

    // 1 week notification
    DateTime weekDate = this.selectedDate.add(Duration(
      seconds: 30
    )).subtract(Duration(days: 7));

    hasPassed = weekDate.add(Duration(
      seconds: 30
    )).isBefore(DateTime.now());

    if (!hasPassed) {
      await flutterLocalNotificationsPlugin.schedule(
          2,
          "${this.selectedSubtask} is due in 1 week.",
          "Check in with your agenda or tap this notification for details!",
          weekDate,
          platformChannelSpecifics);
    }
  }

  void finalizeSubtask() async {
    _scheduleNotifications();
    List<classroom.Course> courses = await pullCourses(firebaseUser);
    for (final course in courses) {
      print(course.name);
    }

    Goal subtask = new Goal(
      name: (selectedSubtask == 'Other') ? otherSubtask : selectedSubtask,
      courseWorkID: (selectedCourseWork != null) ? selectedCourseWork.id : "-1",
      dueDate: selectedDate.toString(),
      courseID: selectedCourse.id,
    );

    List<Goal> subtasks = await pullGoals(
        firebaseUser,
        (selectedCourseWork != null)
            ? "CourseWorkGoalObjects"
            : "CourseGoalObjects");
    subtasks.add(subtask);
    setUserCourseGoals(
        firebaseUser,
        subtasks,
        (selectedCourseWork != null)
            ? "CourseWorkGoalObjects"
            : "CourseGoalObjects");

    Fluttertoast.showToast(
        msg: "Goal Added!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0);
    }


  String createTeacherCourseOption(classroom.Course course) {
    String ret = courseToTeacher[course.id].profile.name.givenName[0] + ". "
        + courseToTeacher[course.id].profile.name.familyName + "'s "
        + course.name.toString();
    return ret;
  }

  void createCourseTeacherMap() {
    for (final course in _courses) {
      for (final teacher in _teachers) {
        if (course.ownerId == teacher.userId) {
          courseToTeacher[course.id] = teacher;
          break;
        }
      }
    }
  }

  void showAlertButton(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Goal Added!"),
      content: Text("Goal successfully added!"),
      actions: <Widget>[okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
    );
  }
}

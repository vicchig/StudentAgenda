import 'package:flutter/material.dart';
import '../Utilities/util.dart';
import '../FirestoreManager.dart';

import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/FirestoreManager.dart';

import 'package:googleapis/classroom/v1.dart' as classroom;
import 'dart:async';
import 'dart:collection';
import '../Utilities/goal.dart';

class AddGoalsScreen extends StatefulWidget {
  @override
  AddGoalsScreenState createState(){
    return AddGoalsScreenState();
  }
}

class AddGoalsScreenState extends State<AddGoalsScreen> {

  List<classroom.Course> _courses = new List<classroom.Course>();
  List<String> _courses_name = new List<String>();

  void processFuture() async {
    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);
    setState(() {
      _courses = tempCourses;
      _courses_name = tempCourses.map((course) => course.name.toString()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    processFuture();
  }



  static var subtasks = ['Write the intro paragraph', 'Write the first body', 'Write the body paragraphs','Write the conclusion', 'Other'];
  var selectedSubtask = null; // NOTE: Depending on implementation, may need to check for empty
  var selectedCourse = null;


  var otherSelected = false;


  var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
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
    return Scaffold( //Sidebar menu scaffold
      appBar: new AppBar(
        title: new Text('Add Goals'),
        centerTitle: true,
      ),

      //draw the sidebar menu options
      drawer: new MenuDrawer(),

      body: Column(
      children: [
      
      SizedBox(height: 140),
      courseDropbox(context),
      SizedBox(height: 20),

      subtaskDropbox(context),
      
      SizedBox(height: 20),

      datepicker(context),
      
      SizedBox(height: 80),
      
      addButton(context),
      ]
    ),
    );
  }

  Widget courseDropbox(BuildContext context) {
    Widget dropdownbox = Align(
      alignment: Alignment.center,
      child: DropdownButton<classroom.Course>(
        value: selectedCourse,

        items: _courses.map((classroom.Course dropDownItem) {
          return DropdownMenuItem<classroom.Course>(
            value: dropDownItem,
            child: Text((dropDownItem.ownerId != null) ? dropDownItem.ownerId : "Nobody" + "'s " + dropDownItem.name.toString(),
              overflow: TextOverflow.ellipsis,),
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
              child: Text(dropDownStringItem,
                          overflow:TextOverflow.ellipsis,),
            );
          }).toList(),
          
          onChanged: (String newValueSelected) {
            _onDropDownItemSelected(newValueSelected);
          },
          underline: Container(),
          hint: Text('Goal', style: TextStyle(fontStyle: FontStyle.italic,
                                              color: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.greenAccent)),
          isExpanded: true,
          style: TextStyle(color: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green,
                          fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );


    Widget alignedBox =
      IgnorePointer(
        ignoring: selectedCourse == null,
        ignoringSemantics: selectedCourse == null,
        child: Align(
          alignment: Alignment(0.0, -0.7),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green,
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
  void _onDropDownItemSelectedCourse(classroom.Course newValueSelected) {
    setState(() {
      this.selectedCourse = newValueSelected;
    });
  }
  
  void _onDropDownItemSelected(String newValueSelected) {
	  setState(() {
		  this.selectedSubtask = newValueSelected;
	  });
  }

  Widget datepicker(BuildContext context) {
    Widget retDate =
      IgnorePointer(
        ignoring: selectedCourse == null,
        ignoringSemantics: selectedCourse == null,
        child:FlatButton(
            onPressed: () => _selectDate(context),
            textColor: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green,
            color: Colors.white,
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
            side: BorderSide(color: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green, width: 3)),

          child: Container(
            height: 50,
            width: 330,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Text(
              "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}",

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
            ),
          ),

          ),
      );
      
    return retDate;
  }
  
  Widget addButton(BuildContext context) {
      Widget retButton =
        IgnorePointer(
          ignoring:selectedCourse == null || selectedSubtask == null,
          ignoringSemantics: selectedCourse == null || selectedSubtask == null,
          child:FlatButton(
            onPressed: () => finalizeSubtask(),
                textColor: Colors.white,
                color: (selectedCourse == null || selectedSubtask == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green,
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
                side: BorderSide(color:(selectedCourse == null || selectedSubtask == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green, width: 3)),
            child: Container(
                height: 70,
                width: 100,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10.0),
                child: Text('Add',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
            ),
          )
      );
    return retButton;
  }
  
  void finalizeSubtask() async {

      List<classroom.Course> courses = await pullCourses(firebaseUser);
      for (final course in courses) {
        print(course.name);
      }


      Goal subtask = new Goal(name: "Placeholder for goal name",
                              text: selectedSubtask,
        dueDate: selectedDate.toString(),
        courseID: selectedCourse.id,
      );

      subtask.setStatus();
      List<Goal> subtasks = await pullGoals(firebaseUser, "CourseWorkGoalObjects");
      subtasks.add(subtask);
      setUserCourseGoals(firebaseUser, subtasks, "CourseWorkGoalObjects");
      
      
  }
  
  
}
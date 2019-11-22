import 'package:flutter/material.dart';
import 'package:student_agenda/FirestoreDataManager.dart';
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
  List<classroom.CourseWork> _courseWork = new List<classroom.CourseWork>();
  List<classroom.CourseWork> _original = new List<classroom.CourseWork>();

  void processFuture() async {
    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);
    List<classroom.CourseWork> tempWork = await pullCourseWorkData(firebaseUser);
    setState(() {
      _courses = tempCourses;
      _courseWork = tempWork;
      _original = tempWork;
    });
  }



  @override
  void initState() {
    super.initState();
    processFuture();
  }

  static var subtasks = ['Write the intro paragraph', 'Write the first body', 'Write the body paragraphs','Write the conclusion', 'Other'];
  String selectedSubtask = null; // NOTE: Depending on implementation, may need to check for empty
  classroom.Course selectedCourse = null;
  classroom.CourseWork selectedCourseWork = null;







  String otherSubtask = null;


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

      body: ListView(
      children: [
      
      SizedBox(height: 70),

      courseDropbox(context),

      SizedBox(height: 20),

      courseWorkDropbox(context),

      SizedBox(height: 20),

      subtaskDropbox(context),

      (selectedSubtask == 'Other') ? SizedBox(height: 20) : SizedBox(height: 0),

      (selectedSubtask == 'Other') ? otherTextfield(context) : SizedBox(height: 0),

      SizedBox(height: 20),

      datepicker(context),
      
      SizedBox(height: 80),
      Align(alignment: Alignment.center, child:addButton(context))
      ]
    ),
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
            child: Text(dropDownItem.description,
              overflow: TextOverflow.ellipsis,),
          );
        }).toList(),

        onChanged: (classroom.CourseWork newValueSelected) {
          _onDropDownItemSelectedCourseWork(newValueSelected);
        },
        underline: Container(),
        hint: Text('Goal for the Course', style: TextStyle(fontStyle: FontStyle.italic, color: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green)),
        isExpanded: true,
        style: TextStyle(
            color: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );

    Widget alignedBox = IgnorePointer(
      ignoring: selectedCourse == null,
      ignoringSemantics: selectedCourse == null,
      child:
      Align(
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


  Widget otherTextfield(BuildContext context) {
    Widget textField =   Container(
      child: TextField(
        style: TextStyle(fontSize: 18,
            color: Colors.green),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic,
              color: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.greenAccent),
          hintText: 'What goal did you have in mind?',
          border: InputBorder.none,
        ),
        onChanged: (text) {_setOtherSubtask(text);},
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
            child: Text((dropDownItem.ownerId != null) ? dropDownItem.ownerId : "Someone" + "'s " + dropDownItem.name.toString(),
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

  void _setOtherSubtask(String otherSubtask) {
    setState(() {
      this.otherSubtask = otherSubtask;
    });
  }

  void _onDropDownItemSelectedCourse(classroom.Course newValueSelected) {
    setState(() {
      this.selectedCourse = newValueSelected;
      this._courseWork = getCourseWorksForCourse(this.selectedCourse.id, this._original);
      this.selectedCourseWork = null;
    });
  }

  void _onDropDownItemSelectedCourseWork(classroom.CourseWork newValueSelected) {
    setState(() {
      this.selectedCourseWork = newValueSelected;
    });
  }

  void _onDropDownItemSelected(String newValueSelected) {
	  setState(() {
		  this.selectedSubtask = newValueSelected;
	  });
  }

  Widget datepicker(BuildContext context) {

    Widget flatButton = FlatButton(
      onPressed: () => _selectDate(context),
      textColor: (selectedCourse == null) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green,

      child: Text(
          "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}",

          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
      ),
    );

    Widget retDate =
        IgnorePointer(
          ignoring: selectedCourse == null,
          ignoringSemantics: selectedCourse == null,
          child: Align(
            alignment: Alignment(0.0, -0.7),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(226,240,217, 1.0),
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
              child: flatButton,
            ),
          ),
        );


    return retDate;
  }

  Widget addButton(BuildContext context) {
    Widget retButton =
    IgnorePointer(
        ignoring:selectedCourse == null || selectedSubtask == null || (selectedSubtask == 'Other' && otherSubtask == null),
        ignoringSemantics: selectedCourse == null || selectedSubtask == null || (selectedSubtask == 'Other' && otherSubtask == null),
        child:FlatButton(
          onPressed: () => finalizeSubtask(),
          textColor: Colors.white,
          color: (selectedCourse == null || selectedSubtask == null || (selectedSubtask == 'Other' && otherSubtask == null)) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
              side: BorderSide(color:(selectedCourse == null || selectedSubtask == null || (selectedSubtask == 'Other' && otherSubtask == null)) ? Color.fromRGBO(200,200,200, 1.0) : Colors.green, width: 3)),
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


      Goal subtask = new Goal(name: (selectedSubtask == 'Other') ? otherSubtask:selectedSubtask,
        courseWorkID: (selectedCourseWork != null) ? selectedCourseWork.id : "-1",
        dueDate: selectedDate.toString(),
        courseID: selectedCourse.id,
      );



      subtask.setStatus();
      List<Goal> subtasks = await pullGoals(firebaseUser, (selectedCourseWork != null) ? "CourseWorkGoalObjects" : "CourseGoalObjects");
      subtasks.add(subtask);
      setUserCourseGoals(firebaseUser, subtasks, (selectedCourseWork != null) ? "CourseWorkGoalObjects" : "CourseGoalObjects");
      
      
  }
  
  
}
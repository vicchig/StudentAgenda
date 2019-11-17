import 'package:flutter/material.dart';
import '../Utilities/util.dart';
import 'courseGoalsScreen.dart';
import '../FirestoreManager.dart';

import 'package:googleapis/classroom/v1.dart' as classroom;
import '../FirestoreManager.dart';
import 'package:student_agenda/Utilities/auth.dart';

import 'package:student_agenda/FirestoreManager.dart';

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
  static var subtasks = ['Write the intro paragraph', 'Write the first body', 'Write the body paragraphs','Write the conclusion'];
  var selectedSubtask = null; // NOTE: Depending on implementation, may need to check for empty
  
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
      
      subtaskDropbox(context),
      
      SizedBox(height: 30),

      datepicker(context),
      
      SizedBox(height: 80),
      
      addButton(context),
      ]
    ),
    );
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
          hint: Text('Subtask', style: TextStyle(fontStyle: FontStyle.italic)),
          isExpanded: true,
          style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.w500),
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
    Widget retDate =
        FlatButton(
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
              
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
            ),
          ),
            
          );
      
    return retDate;
  }
  
  Widget addButton(BuildContext context) {
      Widget retButton =
        FlatButton(
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
      
      print('Adding subtask ...' + "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}");
      
      
      Goal subtask = new Goal(name: "Placeholder for goal name",
                              text: selectedSubtask,
        dueDate: selectedDate.toString(),
        courseID: "placeholder for courseID",
        courseWorkID: "placeholder for courseWorkID",
      );

      subtask.setStatus();



      addUserGoal(firebaseUser, subtask);
      
      
  }
  
  
}
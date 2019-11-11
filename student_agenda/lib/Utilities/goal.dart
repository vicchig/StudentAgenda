//CLASS FOR REPRESENTING A STUDENT GOAL

import 'package:googleapis/classroom/v1.dart' as classroom;

const String S_IN_PROGRESS = "IN_PROGRESS";
const String S_COMPLETED   = "COMPLETED";
const String S_COMPLETED_LATE = "COMPLETED_LATE";
const String S_IN_PROGRESS_LATE = "IN_PROGRESS_LATE";
const String PM = "PM";
const String AM = "AM";

class Goal{
  String name;
  String text;
  DateTime dueDate;
  String amPM;

  String _status;
  String _courseID;
  String _courseWorkID;

  Goal({String name: "BlankGoal", String text: "", courseID: "-1",
    courseWorkID: "-1", String amPM: AM, String dueDate}){

    _status = S_IN_PROGRESS;
    _courseID = courseID;
    _courseWorkID = courseWorkID;

    this.name = name;
    this.text = text;
    this.dueDate = DateTime.parse(dueDate); //TODO: make sure to tell them the format for this
  }

  //TODO: Set status automatically based on what time it is (ie. past task due date, before task due date, on task due date, etc.)
  //The complete status shouldbe set through the method
  void setStatus(){
    DateTime currDateTime = DateTime.now();
    if(currDateTime.isAfter(dueDate) && _status == S_IN_PROGRESS){
      _status = S_IN_PROGRESS_LATE;
    }
    else if(currDateTime.isAfter(dueDate) && _status == S_COMPLETED){
      _status = S_COMPLETED_LATE;
    }
    else if(currDateTime.isBefore(dueDate)){
      _status = S_IN_PROGRESS;
    }
  }

  void completeGoal(){
    _status = S_COMPLETED;
  }

  //TODO: test this
  String getDueTime(){
    String result = dueDate.toIso8601String();
    result = result.substring(result.indexOf("T"));
    List<String> timeParts = result.split(":");
    return ""+timeParts[0] + ":" + timeParts[1] + ":" + timeParts[2].substring(0, 2);
  }

  //TODO: Make sure the formatting on this is good
  String getCalendarDueDate(){
    return "" + dueDate.day.toString() + "/" + dueDate.month.toString() + "/" +
        dueDate.year.toString();
  }

  String getCourseId(){
    return _courseID;
  }

  String getCourseWorkId(){
    return _courseWorkID;
  }

  //TODO: Find best formatting for this
  String toString(){
    return name + "\n" + getCalendarDueDate() + "\n" + getDueTime() + "\n" +
        _status + "\n\n" + text + "\n";
  }
}
//CLASS FOR REPRESENTING A STUDENT GOAL

import 'package:googleapis/classroom/v1.dart' as classroom;

const String S_IN_PROGRESS = "IN_PROGRESS";
const String S_COMPLETED   = "COMPLETED";
const String S_COMPLETED_LATE = "COMPLETED_LATE";
const String S_IN_PROGRESS_LATE = "IN_PROGRESS_LATE";
const String PM = "PM";
const String AM = "AM";
final Map<String, String> _months = new Map<String, String>();

class Goal{
  String name;
  String text;
  classroom.Date dueDate;
  classroom.TimeOfDay dueTime;
  String amPM;

  String _status;
  String _courseID;
  String _courseWorkID;

  Goal({String name: "BlankGoal", String text: "", courseID: "-1",
    courseWorkID: "-1", String amPM: AM, classroom.Date dueDate,
    classroom.TimeOfDay dueTime}){

    _status = S_IN_PROGRESS;
    _courseID = courseID;
    _courseWorkID = courseWorkID;

    this.name = name;
    this.text = text;
    this.dueDate = dueDate;
    this.dueTime = dueTime;
    this.amPM = amPM;
  }

  //TODO: Set status automatically based on what time it is (ie. past task due date, before task due date, on task due date, etc.)
  void setStatus(){

  }

  String getTextDueDate(){
    return  "";
  }

  String getTime(){
    return "" + dueTime.hours.toString() + ":" + dueTime.minutes.toString() +
           ":" + dueTime.seconds.toString() + amPM;
  }

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
    return name + "\n" + getCalendarDueDate() + "\n" + getTime() + "\n" +
        _status + "\n\n" + text + "\n";
  }
}
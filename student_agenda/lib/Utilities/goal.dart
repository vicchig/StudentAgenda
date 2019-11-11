//CLASS FOR REPRESENTING A STUDENT GOAL

import 'package:googleapis/classroom/v1.dart' as classroom;

const String S_IN_PROGRESS = "IN_PROGRESS";
const String S_COMPLETED   = "COMPLETED";
const String S_COMPLETED_LATE = "COMPLETED_LATE";
const String S_IN_PROGRESS_LATE = "IN_PROGRESS_LATE";

class Goal{
  String name;
  String text;
  classroom.Date _dueDate;
  String _status;
  String _courseID;
  String _courseWorkID;

  Goal({String name: "BlankGoal", String text: "", courseID: "-1",
    courseWorkID: "-1", classroom.Date dueDate}){

    _status = S_IN_PROGRESS;
    _dueDate = dueDate;
    this.name = name;
    this.text = text;
    _courseID = courseID;
    _courseWorkID = courseWorkID;
  }


  void setStatus(){

  }

  String getDateString(){
    return _dueDate.toString();
  }

  classroom.Date getDate(){
    return _dueDate;
  }

  void setDueDate(classroom.Date newDate){
    _dueDate = newDate;
  }

  String getCourseId(){
    return _courseID;
  }

  String getCourseWorkId(){
    return _courseWorkID;
  }

  String toString(){
    return name + "\n" + getDateString() + "\n" + _status + "\n\n" +
        text + "\n";
  }





}
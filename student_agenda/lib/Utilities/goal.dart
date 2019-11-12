//CLASS FOR REPRESENTING A STUDENT GOAL

import 'package:googleapis/classroom/v1.dart' as classroom;

const String S_IN_PROGRESS = "IN_PROGRESS";
const String S_COMPLETED   = "COMPLETED";
const String S_COMPLETED_LATE = "COMPLETED_LATE";
const String S_IN_PROGRESS_LATE = "IN_PROGRESS_LATE";

class Goal{
  String name;
  String text;
  DateTime dueDate;

  String _status;
  String _courseID;
  String _courseWorkID;

  //the dueDate string should be in the following format "yyyy-mm-ddThh:mm:ss"
  Goal({String name: "BlankGoal", String text: "", courseID: "-1",
    courseWorkID: "-1",  String dueDate: ""}){

    _status = S_IN_PROGRESS;
    _courseID = courseID;
    _courseWorkID = courseWorkID;

    this.name = name;
    this.text = text;
    this.dueDate = DateTime.parse(dueDate);
  }

  //The complete status should be set through the method
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

  //returns the time this task is due (DOES NOT DISTINGUISH BETWEEN AM/PM,
  // SO USE THE 24 HOUR CLOCK)
  String getDueTime(){
    String result = dueDate.toIso8601String();
    result = result.substring(result.indexOf("T"));
    List<String> timeParts = result.split(":");
    return ""+timeParts[0].substring(1,) + ":" + timeParts[1] + ":" +
        timeParts[2].substring(0, 2);
  }

  //Returns the calendar due date for this task in the format "dd/mm/yyyy"
  //Can extract the month by calling util.getMonthFromDateStr(dateStr);
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

  String toString(){
    return name + "\n" + getCalendarDueDate() + "\n" + getDueTime() + "\n" +
        _status + "\n\n" + text + "\n\n";
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "text": text,
    "status": _status,
    "courseID": _courseID,
    "courseWorkID": _courseWorkID,
    "dueDate": dueDate.toIso8601String()
  };

  Goal.fromJson(Map<String, dynamic> json)
    : name = json["name"],
      text = json["text"],
      _status = json["status"],
      _courseID = json["courseID"],
      _courseWorkID = json["courseWorkID"],
      dueDate = DateTime.parse(json["dueDate"]);
}
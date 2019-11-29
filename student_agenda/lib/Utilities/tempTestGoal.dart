//CLASS FOR REPRESENTING A STUDENT GOAL

import 'package:student_agenda/Utilities/util.dart';



class TempTestGoal {
  static const String S_IN_PROGRESS = "IN_PROGRESS";
  static const String S_COMPLETED = "COMPLETED";
  static const String S_COMPLETED_LATE = "COMPLETED_LATE";
  static const String S_IN_PROGRESS_LATE = "IN_PROGRESS_LATE";

  String name;
  String text;
  DateTime dueDate;
  DateTime dateAssigned; //these fields should be private in the actual Goal class
  DateTime dateCompleted;

  String status;
  String _courseID;
  String _courseWorkID;

  TempTestGoal({String dateCompleted, String dateAssigned, String status, String name: "BlankGoal",
    String text: "",
    courseID: "-1",
    courseWorkID: "-1",
    String dueDate: ""}) {
    _courseID = courseID;
    _courseWorkID = courseWorkID;

    this.status = status;

    this.name = name;
    this.text = text;
    this.dueDate = DateTime.parse(dueDate);
    DateTime currTime = DateTime.now();
    DateTime currDay = DateTime(currTime.year, currTime.month, currTime.day);
    if (currDay.isAfter(this.dueDate)) {
      status = S_IN_PROGRESS_LATE;
    } else {
      status = S_IN_PROGRESS;
    }

    this.dateAssigned = DateTime.parse(dateAssigned);
    this.dateCompleted = DateTime.parse(dateCompleted);
  }

  String getStatus() {
    DateTime currTime = DateTime.now();
    DateTime currDay = DateTime(currTime.year, currTime.month, currTime.day);
    if (currDay.isAfter(dueDate) && status == S_IN_PROGRESS) {
      status = S_IN_PROGRESS_LATE;
    }
    return status;
  }

  void completeGoal() {
    DateTime currTime = DateTime.now();
    DateTime currDay = DateTime(currTime.year, currTime.month, currTime.day);
    if (currDay.isAfter(dueDate)) {
      status = S_COMPLETED_LATE;
    } else {
      status = S_COMPLETED;
    }

    this.dateCompleted = DateTime.now();
  }

  DateTime getDateCompleted(){
    return this.dateCompleted;
  }

  DateTime getDateAssigned(){
    return this.dateAssigned;
  }

  String getDueTime() {
    String result = dueDate.toIso8601String();
    result = result.substring(result.indexOf("T"));
    List<String> timeParts = result.split(":");
    return "" +
        timeParts[0].substring(
          1,
        ) +
        ":" +
        timeParts[1] +
        ":" +
        timeParts[2].substring(0, 2);
  }

  String getCourseId() {
    return _courseID;
  }

  String getCourseWorkId() {
    return _courseWorkID;
  }

  String toString() {
    return name +
        "\n" +
        getCalendarDueDate(this.dueDate) +
        "\n" +
        getDueTime() +
        "\n" +
        status +
        "\n\n" +
        text +
        "\n\n";
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "text": text,
    "status": status,
    "courseID": _courseID,
    "courseWorkID": _courseWorkID,
    "dueDate": dueDate.toIso8601String()
  };

  TempTestGoal.fromJson(Map<dynamic, dynamic> json)
      : name = json["name"],
        text = json["text"],
        status = json["status"],
        _courseID = json["courseID"],
        _courseWorkID = json["courseWorkID"],
        dueDate = DateTime.parse(json["dueDate"]);
}

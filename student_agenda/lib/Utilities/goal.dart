//CLASS FOR REPRESENTING A STUDENT GOAL

import 'package:student_agenda/Utilities/util.dart';

const String S_IN_PROGRESS = "IN_PROGRESS";
const String S_COMPLETED = "COMPLETED";
const String S_COMPLETED_LATE = "COMPLETED_LATE";
const String S_IN_PROGRESS_LATE = "IN_PROGRESS_LATE";

class Goal {
  String name;
  String text;
  DateTime dueDate;

  String _status;
  String _courseID;
  String _courseWorkID;

  DateTime _dateAssigned;
  DateTime _dateCompleted;

  Goal({String name: "BlankGoal",
    String text: "",
    courseID: "-1",
    courseWorkID: "-1",
    String dueDate: ""}) {
    _courseID = courseID;
    _courseWorkID = courseWorkID;

    this.name = name;
    this.text = text;
    this.dueDate = DateTime.parse(dueDate);
    DateTime currTime = DateTime.now();
    DateTime currDay = DateTime(currTime.year, currTime.month, currTime.day);
    if (currDay.isAfter(this.dueDate)) {
      _status = S_IN_PROGRESS_LATE;
    } else {
      _status = S_IN_PROGRESS;
    }

    this._dateAssigned = DateTime.now();
    this._dateCompleted = DateTime.fromMillisecondsSinceEpoch(0);
  }

  String getStatus() {
    DateTime currTime = DateTime.now();
    DateTime currDay = DateTime(currTime.year, currTime.month, currTime.day);
    if (currDay.isAfter(dueDate) && _status == S_IN_PROGRESS) {
      _status = S_IN_PROGRESS_LATE;
    }
    return _status;
  }

  void completeGoal() {
    DateTime currTime = DateTime.now();
    DateTime currDay = DateTime(currTime.year, currTime.month, currTime.day);
    if (currDay.isAfter(dueDate)) {
      _status = S_COMPLETED_LATE;
    } else {
      _status = S_COMPLETED;
    }
    this._dateCompleted = DateTime.now();
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

  DateTime getDateCompleted() {
    return this._dateCompleted;
  }

  DateTime getDateAssigned() {
    return this._dateAssigned;
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
        _status +
        "\n\n" +
        text +
        "\n\n";
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "text": text,
    "status": _status,
    "courseID": _courseID,
    "courseWorkID": _courseWorkID,
    "dueDate": dueDate.toIso8601String(),
    "dateAssigned": _dateAssigned.toIso8601String(),
    "dateCompleted": _dateCompleted.toIso8601String()
  };

  Goal.fromJson(Map<dynamic, dynamic> json)
      : name = json["name"],
        text = json["text"],
        _status = json["status"],
        _courseID = json["courseID"],
        _courseWorkID = json["courseWorkID"],
        dueDate = DateTime.parse(json["dueDate"]),
        _dateAssigned = DateTime.parse(json["dateAssigned"]),
        _dateCompleted = DateTime.parse(json["dateCompleted"]);
}

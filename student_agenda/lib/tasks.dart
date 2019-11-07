import 'package:flutter/material.dart';
import 'dart:collection';

class Task {
  static var dates = ['Nov 1', 'Nov 13', 'Jan 21', 'Jan 24'];
  static final samplepairs1 = [
    ['Assignment 1', 'Subtask 1'],
    ['Assignment 1', 'Subtask 2'],
    ['Assignment 2', 'Subtask 1']
  ];
  static final samplepairs2 = [
    ['An assignment with a name of such great length that its', 'Subtask 11'],
    ['Assignment 11', 'Subtask 12']
  ];
  static final samplepairs3 = [
    ['Assignment 111', 'Subtask 111'],
    [
      'Assignment 111',
      'An incredibly long subtask thats very verbose very much so yes'
    ]
  ];
  static final samplepairs4 = [
    ['Assignment 1', 'Subtask 1'],
    ['Assignment 1', 'Subtask 2'],
    ['Assignment 2', 'Subtask 1'],
    ['An assignment with a name of such great length that its', 'Subtask 11'],
    ['Assignment 11', 'Subtask 12']
  ];
  static LinkedHashMap thing = new LinkedHashMap.fromIterables(
      ['Nov 1', 'Nov 13', 'Jan 21', 'Jan 24'],
      [samplepairs1, samplepairs2, samplepairs3, samplepairs4]);

  static Widget subtaskDropbox(BuildContext context, String date) {
    Column taskSubtaskPair(String task, String subtask) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.green,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            subtask,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.green,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    Widget taskSubtaskPairContainer(String task, String subtask) {
      Widget alignedBox = Align(
        alignment: Alignment(0.0, -0.7),
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(226, 240, 217, 1.0),
          ),
          height: 50,
          width: 360,
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: taskSubtaskPair(task, subtask),
        ),
      );
      return alignedBox;
    }

    Column dateSubtaskGroup = Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        height: 30,
        width: 360,
        child: Text(date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            )),
      ),
    ]);

    for (var i = 0; i < thing[date].length; i++) {
      var newPair =
          taskSubtaskPairContainer(thing[date][i][0], thing[date][i][1]);
      dateSubtaskGroup.children.add(newPair);
    }

    dateSubtaskGroup.children.add(SizedBox(
      height: 10,
    ));

    return dateSubtaskGroup;
  }
}

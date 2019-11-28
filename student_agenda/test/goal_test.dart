import 'package:mockito/mockito.dart';
import 'package:student_agenda/Utilities/goal.dart';
import "package:test/test.dart";
import 'package:collection/collection.dart';

void main() {
  Goal testGoal;

  setUp(() {
    testGoal = new Goal(
        name: "TestGoal",
        text: "Test Goal Text",
        courseID: "1",
        courseWorkID: "23",
        dueDate: (DateTime
            .now()
            .year + 1).toString() + "-11-15T10:25:00");
  });

  tearDown(() {
    testGoal = null;
  });

  group("Goal--TestGetters", () {
    test(
        ".getDueTime() should return a time on the 24-hour clock in the format"
            " hh:mm:ss", () {
      expect(testGoal.getDueTime(), equals("10:25:00"));
    });

    test(".getCourseId() should correctly return the courses id", () {
      expect(testGoal.getCourseId(), equals("1"));
    });

    test(
        ".getCourseWorkId() should correctly return the course work id this"
            " goal is assoasciated with", () {
      expect(testGoal.getCourseWorkId(), equals("23"));
    });
  });

  group("Goal--TestStatus", () {
    test(
        ".setStatus() should set status to S_IN_PROGRESS_LATE if the goal has"
            " not been completed and the due date has passed", () {
      expect(testGoal.getStatus(), equals("IN_PROGRESS"));
      testGoal.dueDate = DateTime.now();
      testGoal.dueDate = testGoal.dueDate.subtract(new Duration(days: 10));
      expect(testGoal.getStatus(), equals("IN_PROGRESS_LATE"));
    });

    test(
        ".setStatus() should set status to S_IN_PROGRESS if the due date has"
            " not passed", () {
      expect(testGoal.getStatus(), equals("IN_PROGRESS"));
      testGoal.dueDate = DateTime.now();
      testGoal.dueDate = testGoal.dueDate.add(new Duration(days: 10));
      expect(testGoal.getStatus(), equals("IN_PROGRESS"));
    });

    test(
        ".setStatus() should set status to S_COMPLETED_LATE if the due date has"
            "passed and the goal was completed", () {
      expect(testGoal.getStatus(), equals("IN_PROGRESS"));
      testGoal.dueDate = DateTime.now();
      testGoal.dueDate = testGoal.dueDate.subtract(new Duration(days: 10));
      testGoal.completeGoal();
      expect(testGoal.getStatus(), equals("COMPLETED_LATE"));
    });

    test(
        ".setStatus() and .completeGoal() should correctly set the goal state"
            " to S_COMPLETE if it was completed on time", () {
      expect(testGoal.getStatus(), equals("IN_PROGRESS"));
      testGoal.dueDate = DateTime.now();
      testGoal.dueDate = testGoal.dueDate.add(new Duration(days: 10));
      testGoal.completeGoal();
      expect(testGoal.getStatus(), equals("COMPLETED"));
    });
  });

  group("Goal--JSON conversion tests", () {
    test("Test to JSON conversion", () {
      Map<String, dynamic> actual = testGoal.toJson();
      Map<String, dynamic> expected = {
        "name": "TestGoal",
        "text": "Test Goal Text",
        "status": "IN_PROGRESS",
        "courseID": "1",
        "courseWorkID": "23",
        "dueDate": (DateTime
            .now()
            .year + 1).toString() + "-11-15T10:25:00.000"
      };
      expect(DeepCollectionEquality().equals(actual, expected), equals(true));
    });

    test("From JSON conversion", () {
      Map<String, dynamic> jsonGoal = testGoal.toJson();
      Map<String, dynamic> expected = {
        "name": "TestGoal",
        "text": "Test Goal Text",
        "status": "IN_PROGRESS",
        "courseID": "1",
        "courseWorkID": "23",
        "dueDate": (DateTime
            .now()
            .year + 1).toString() + "-11-15T10:25:00.000"
      };
      Goal fromJson = Goal.fromJson(jsonGoal);

      Map<String, dynamic> actual = fromJson.toJson();
      expect(DeepCollectionEquality().equals(actual, expected), equals(true));
    });
  });

  group("Goal--TestOther", () {
    test(
        ".toString() should return information about the goal in the correct"
            " format", () {
      expect(
          testGoal.toString(),
          equals("TestGoal\n15/11/" +
              (DateTime
                  .now()
                  .year + 1).toString() +
              "\n10:25:00"
                  "\nIN_PROGRESS\n\nTest Goal Text\n\n"));
    });
  });
}

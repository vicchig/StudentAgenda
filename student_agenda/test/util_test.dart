import 'package:student_agenda/Utilities/util.dart';
import "package:test/test.dart";


void main(){
  String dateStr = "15/11/2019";
  DateTime dateObj = DateTime.parse("2019-11-15T12:12:00");

  group("Test getMonthFromDateStr", (){
    test("correctly extracts month", (){
      expect(getMonthFromDateStr(dateStr), equals("Novemeber"));
    });

    dateStr = "15/02/2019";

    test("correctly extracts month", (){
      expect(getMonthFromDateStr(dateStr), equals("February"));
    });

    dateStr = "15-11-2019";

    //TODO: Figure out how to test methods with exceptions since this still
    // breaks and throwsFormatException does not work either
    test("should fail on an improperly formatted string", (){
      expect(getMonthFromDateStr(dateStr), throwsA(equals("FormatException: Date String could not be parsed. Got: 15-11-2019 "
          "but expected string in format: 'dd/mm/yyyy'")));
    });
  });
}
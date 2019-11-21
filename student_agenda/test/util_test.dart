import 'package:flutter/foundation.dart';
import 'package:student_agenda/Utilities/util.dart';
import "package:test/test.dart";


void main(){
  String dateStr, dateStrDiff, dateStrEx, dateStrEx2;
  DateTime dateObj, dateObjDiff;

  setUp((){
    dateStr = "16/11/2019";
    dateStrDiff = "16/02/2019";
    dateStrEx = "15-11-2019";
    dateStrEx2 = "15/11-2019";

    dateObj = DateTime.parse("2019-11-15T12:12:00");
    dateObjDiff = DateTime.parse("2019-02-15T12:12:00");
  });

  tearDown((){
    dateStr = "";
    dateStrDiff = "";
    dateStrEx = "";
    dateStrEx2 = "";

    dateObj = null;
    dateObjDiff = null;
  });

  group("Test getMonthFromDateStr", (){
    test("correctly extracts month", (){
      expect(getMonthFromDateStr(dateStr), equals("November"));
    });

    test("correctly extracts month", (){
      expect(getMonthFromDateStr(dateStrDiff), equals("February"));
    });

    test("should fail on an improperly formatted string", (){
      expect(() => getMonthFromDateStr(dateStrEx), throwsFormatException);
    });

    test("should fail on an improperly formatted string", (){
      expect(() => getMonthFromDateStr(dateStrEx2), throwsFormatException);
    });

    test("test all", (){
      List<String> dates = new List<String>();
      List<String> expected = new List<String>();
      List<String> actual = new List<String>();

      expected.addAll(["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"]);

      for(int i = 1; i <= 12; i++){
        if(i < 10){
          dates.add("15/"+"0"+i.toString()+"/2019");
        }
        else{
          dates.add("15/"+i.toString()+"/2019");
        }
      }

      for(int i = 0; i < dates.length; i++){
        actual.add(getMonthFromDateStr(dates[i]));
      }

      expect(listEquals(actual, expected), equals(true));
    });
  });

  group("Test getMonthFromDateObj", (){
    test("correctly extracts month", (){
      expect(getMonthFromDateObj(dateObj), equals("November"));
    });

    test("correctly extracts month", (){
      expect(getMonthFromDateObj(dateObjDiff), equals("February"));
    });

    test("test all", (){
      List<String> actual = new List<String>();
      List<String> expected = new List<String>();
      List<DateTime> test = new List<DateTime>();

      expected.addAll(["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"]);
      
      for(int i = 1; i <= 12; i++){
        if(i < 10){
          test.add(DateTime.parse("2019-0"+i.toString()+"-15T12:12:00"));
        }
        else{
          test.add(DateTime.parse("2019-"+i.toString()+"-15T12:12:00"));
        }
      }

      for(int i  = 0; i < test.length; i++){
        actual.add(getMonthFromDateObj(test[i]));
      }
      
      expect(listEquals(actual, expected), equals(true));
    });
  });

  group("Test getCalendarDate", (){
    test(".getCalendarDueDate() should return a calendar in the format "
    "dd/mm/yyyy", () {
    expect(getCalendarDueDate(dateObj), equals("15/11/2019"));
    });
  });
}
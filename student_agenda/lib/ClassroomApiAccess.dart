import 'package:student_agenda/auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;

final Future<Map<String, String>> _authHeaders = authService.getAuthHeaders();

class ClassroomApiAccess{
  static ClassroomApiAccess _instance;

  ClassroomApiAccess._();

  static ClassroomApiAccess getInstance(){
    if(_instance == null){
      _instance = new ClassroomApiAccess._();
    }
    return _instance;
  }

  Future<List<classroom.Course>> getCourses() async{
    /* EXAMPLE CODE FOR WHEN WE ACTUALLY HAVE TO IMPLEMENT THESE
    GoogleHttpClient httpClient = new GoogleHttpClient(await _authHeaders);
    classroom.ListCoursesResponse courses = await new classroom.ClassroomApi(httpClient).courses.list(
      pageSize: 10,
    );
    return courses.courses;*/
    List<classroom.Course> courses = new List<classroom.Course>();
    for(int i = 0; i < 8; i++){
      courses.add(new classroom.Course());
      courses[i].id = "courseID" + i.toString();
      courses[i].calendarId = "calendarID" + i.toString();
      courses[i].courseState = "ACTIVE || ARCHIVED || DECLINED || PROVISIONED";
      courses[i].courseGroupEmail = "classmail@gmail.com" + i.toString();
      courses[i].enrollmentCode = "enrollment code" + i.toString();
      courses[i].description = "Course description" + i.toString();
    }
    print(courses[0].id);

    return courses;
  }



}

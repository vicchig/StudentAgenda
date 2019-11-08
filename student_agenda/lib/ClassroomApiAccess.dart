import 'package:firebase_analytics/observer.dart';
import 'package:student_agenda/auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;

final Future<Map<String, String>> _authHeaders = authService.getAuthHeaders();


/*TODO: This class currently implements dummy functions. In the future we need
* to actually pull data from Google Classroom
*/
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
   /* // EXAMPLE CODE FOR WHEN WE ACTUALLY HAVE TO IMPLEMENT THESE
   //TODO: Should be wrapped in a try catch for the actual implementation
    GoogleHttpClient httpClient = new GoogleHttpClient(await _authHeaders);
    classroom.ListCoursesResponse courses = await new classroom.ClassroomApi
    (httpClient).courses.list(
      pageSize: 10,
    );
    return courses.courses; will be null for now since there are no courses,
     BUT return courses should never be null, if it is, there is an error*/

    List<classroom.Course> courses = new List<classroom.Course>();
    for(int i = 0; i < 8; i++){
      courses.add(new classroom.Course());
      courses[i].id = i.toString();
      courses[i].calendarId = "calendarID" + i.toString();
      courses[i].courseState = "ACTIVE || ARCHIVED || DECLINED || PROVISIONED";
      courses[i].courseGroupEmail = "classmail@gmail.com" + i.toString();
      courses[i].enrollmentCode = "enrollment code" + i.toString();
      courses[i].description = "Course description" + i.toString();
      courses[i].name = "Course Name " + i.toString();
    }

    return courses;
  }

  Future<List<classroom.CourseWork>> getCourseWork() async {
    List<classroom.CourseWork> courseWorks = new List<classroom.CourseWork>();

    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 5; j++){ //create 5 course works
        courseWorks.add(new classroom.CourseWork());
        courseWorks[i + j].courseId = i.toString();
        courseWorks[i + j].description = "Assignment Description";

        classroom.Date date = new classroom.Date();
        date.month = 1;
        date.day = 15;
        date.year = 1990;
        courseWorks[i + j].dueDate = date;

        courseWorks[i + j].id = i.toString() + j.toString();
        courseWorks[i + j].maxPoints = 10.0;

        classroom.TimeOfDay time = new classroom.TimeOfDay();
        time.hours = 10;
        time.minutes = 59;
        time.seconds = 59;
        courseWorks[i + j].dueTime = time;

        courseWorks[i + j].scheduledTime = "Scheduled Time";
        courseWorks[i + j].workType = "ASSIGNMENT";
        courseWorks[i + j].assigneeMode = "ALL_STUDENTS";
      }
    }
    return courseWorks;
  }

  List<classroom.Announcement> getAssignments(){
    List<classroom.Announcement> announcements =
                                            new List<classroom.Announcement>();

    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 5; j++){ //create 5 announcements per course
        announcements.add(new classroom.Announcement());
        announcements[i + j].courseId = i.toString();
        announcements[i + j].text = "Announcement Text";
      }
    }
    return announcements;
  }

  List<classroom.Student> getStudents(){
    List<classroom.Student> students = new List<classroom.Student>();

    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 5; j++){ //create 5 students per course
        students.add(new classroom.Student());
        students[i + j].courseId = i.toString();
        students[i + j].userId = "UID" + (i+j).toString();
        students[i + j].profile = new classroom.UserProfile();
        students[i + j].profile.name = new classroom.Name();
        students[i + j].profile.name.fullName = "ARIAN";
        students[i + j].profile.emailAddress = "arian@skype.skype.com";
      }
    }
    return students;
  }

  List<classroom.Teacher> getTeachers(){
    List<classroom.Teacher> teachers = new List<classroom.Teacher>();

    for(int i = 0; i < 8; i++){ //for every dummy course
      teachers.add(new classroom.Teacher());
      teachers[i].courseId = i.toString();
      teachers[i].profile = new classroom.UserProfile();
      teachers[i].profile.name = new classroom.Name();
      teachers[i].profile.name.fullName = "Teacher of Course " + i.toString();
    }

    return teachers;
  }

  List<classroom.Topic> getTopics(){
    List<classroom.Topic> topics = new List<classroom.Topic>();

    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 5; j++){ //create 5 topics per course
        topics.add(new classroom.Topic());
        topics[i + j].name = "Topic Name " + j.toString();
        topics[i + j].courseId = i.toString();
      }
    }

    return topics;
  }
}

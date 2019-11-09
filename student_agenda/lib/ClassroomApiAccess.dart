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
    int count = 0;
    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 5; j++){ //create 5 course works
        courseWorks.add(new classroom.CourseWork());
        courseWorks[count].courseId = i.toString();
        courseWorks[count].description = "Assignment Description";

        classroom.Date date = new classroom.Date();
        date.month = 1;
        date.day = 15;
        date.year = 1990;
        courseWorks[count].dueDate = date;

        courseWorks[count].id = i.toString() + j.toString();
        courseWorks[count].maxPoints = 10.0;

        classroom.TimeOfDay time = new classroom.TimeOfDay();
        time.hours = 10;
        time.minutes = 59;
        time.seconds = 59;
        courseWorks[count].dueTime = time;

        courseWorks[count].scheduledTime = "Scheduled Time";
        courseWorks[count].workType = "ASSIGNMENT";
        courseWorks[count].assigneeMode = "ALL_STUDENTS";
        count++;
      }
    }
    return courseWorks;
  }

  Future<List<classroom.Announcement>> getAnnouncements() async {
    List<classroom.Announcement> announcements =
                                            new List<classroom.Announcement>();
    int count = 0;
    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 2; j++){ //create 5 announcements per course
        announcements.add(new classroom.Announcement());
        announcements[count].courseId = i.toString();
        announcements[count].text = "Announcement Text";
        count++;
      }
    }
    return announcements;
  }

  Future<List<classroom.Student>> getStudents() async {
    List<classroom.Student> students = new List<classroom.Student>();
    int count =  0;
    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 5; j++){ //create 5 students per course
        students.add(new classroom.Student());
        students[count].courseId = i.toString();
        students[count].userId = "UID" + (i+j).toString();
        students[count].profile = new classroom.UserProfile();
        students[count].profile.name = new classroom.Name();
        students[count].profile.name.fullName = "ARIAN";
        students[count].profile.emailAddress = "arian@skype.skype.com";
        count++;
      }
    }
    return students;
  }

  Future<List<classroom.Teacher>> getTeachers() async {
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

  Future<List<classroom.Topic>> getTopics() async {
    List<classroom.Topic> topics = new List<classroom.Topic>();
    int count = 0;
    for(int i = 0; i < 8; i++){ //for every dummy course
      for(int j = 0; j < 5; j++){ //create 5 topics per course
        topics.add(new classroom.Topic());
        topics[count].name = "Topic Name " + j.toString();
        topics[count].courseId = i.toString();
        count++;
      }
    }

    return topics;
  }
}

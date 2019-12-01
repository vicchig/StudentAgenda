import 'package:firebase_analytics/observer.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:student_agenda/Utilities/util.dart';

final Future<Map<String, String>> _authHeaders = authService.getAuthHeaders();


class ClassroomApiAccess {
  static ClassroomApiAccess _instance;
  static GoogleHttpClient _client;

  ClassroomApiAccess._();

  static ClassroomApiAccess getInstance() {
    if (_instance == null) {
      _instance = new ClassroomApiAccess._();
    }
    return _instance;
  }


  Future<void> _connectClient() async{
    _client = new GoogleHttpClient(await _authHeaders);
  }

  /*
  TODO:
        3. Remove the fake data if everything works well
   */
  Future<List<classroom.Course>> getCourses() async {
    List<classroom.Course> courseList = new List<classroom.Course>();
    classroom.ListCoursesResponse courses;

    await _connectClient();

    try{
      courses = await new classroom.ClassroomApi(_client).courses.list();
    } catch(e, stackTrace){
      printError("CLASSROOM API ERROR!", e.toString(), stackTrace.toString());
    }
    finally{
      try{
        courseList = courses.courses;
      } on NoSuchMethodError catch(e, stackTrace){
        printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
            extraInfo: "GET request to classroom API returned NULL.");
        courseList = new List<classroom.Course>();
      } catch(e, stackTrace){
        printError("ERROR!", e.toString(), stackTrace.toString());
      }
    }

    return courseList;
    /* // EXAMPLE CODE FOR WHEN WE ACTUALLY HAVE TO IMPLEMENT THESE
   //TODO: Should be wrapped in a try catch for the actual implementation
    GoogleHttpClient httpClient = new GoogleHttpClient(await _authHeaders);
    classroom.ListCoursesResponse courses = await new classroom.ClassroomApi
    (httpClient).courses.list(
      pageSize: 10,
    );
    return courses.courses; will be null for now since there are no courses,
     BUT return courses should never be null, if it is, there is an error*/
/*
    const List<String> courseNames = <String>[
      'Mathematics',
      'Language',
      'French as a Second Language',
      'Health and Physical Education',
      'Science and Technology',
      'The Arts',
      'Social Studies',
      'History and Geography'
    ];

    List<classroom.Course> courses = new List<classroom.Course>();
    for (int i = 0; i < 8; i++) {
      courses.add(new classroom.Course());
      courses[i].id = i.toString();
      courses[i].calendarId = "calendarID" + i.toString();
      courses[i].courseState = "ACTIVE || ARCHIVED || DECLINED || PROVISIONED";
      courses[i].courseGroupEmail = "classmail@gmail.com" + i.toString();
      courses[i].enrollmentCode = "enrollment code" + i.toString();
      courses[i].description = "Course description" + i.toString();
      courses[i].name = courseNames[i];
    }

    return courses;*/
  }

  /*
  TODO:
        3. Remove the fake data if everything works well
   */
  Future<List<classroom.CourseWork>> getCourseWork(String courseId) async {
    List<classroom.CourseWork> courseWorks = new List<classroom.CourseWork>();
    classroom.ListCourseWorkResponse response;

    await _connectClient();

    try{
      response = await new classroom.ClassroomApi(_client).courses.courseWork.list(courseId);
    } catch(e, stackTrace){
      printError("CLASSROOM API ERROR!", e.toString(), stackTrace.toString());
    }
    finally{
      try{
        courseWorks = response.courseWork;
      } on NoSuchMethodError catch(e, stackTrace){
        printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
            extraInfo: "GET request to classroom API returned NULL.");
        courseWorks = new List<classroom.CourseWork>();
      } catch(e, stackTrace){
        printError("ERROR!", e.toString(), stackTrace.toString());
      }
    }

    return courseWorks;

    /*
    List<classroom.CourseWork> courseWorks = new List<classroom.CourseWork>();
    int count = 0;

    for (int i = 0; i < 8; i++) {
      //for every dummy course
      for (int j = 0; j < i + 3; j++) {
        //create 5 course works
        courseWorks.add(new classroom.CourseWork());
        courseWorks[count].courseId = i.toString();
        courseWorks[count].description = "Hand in Workbook Page ${j + 10}";

        classroom.Date date = new classroom.Date();
        date.month = DateTime
            .now()
            .add(new Duration(days: j + 7))
            .month;
        date.day = DateTime
            .now()
            .add(new Duration(days: j + 7))
            .day;
        date.year = DateTime
            .now()
            .add(new Duration(days: j + 7))
            .year;
        date = courseWorks[count].dueDate = date;

        courseWorks[count].id = i.toString() + j.toString();
        courseWorks[count].maxPoints = 10.0;

        classroom.TimeOfDay time = new classroom.TimeOfDay();
        time.hours = 8;
        time.minutes = 5;
        time.seconds = 0;
        courseWorks[count].dueTime = time;

        courseWorks[count].scheduledTime = "Scheduled Time";
        courseWorks[count].workType = "ASSIGNMENT";
        courseWorks[count].assigneeMode = "ALL_STUDENTS";
        count++;
      }
    }
    return courseWorks;*/
  }

  /*
  TODO:
        3. Remove the fake data if everything works well
   */
  Future<List<classroom.Announcement>> getAnnouncements(String courseId) async {
    List<classroom.Announcement> announcements = new List<classroom.Announcement>();
    classroom.ListAnnouncementsResponse response;

    await  _connectClient();

    try{
      response = await new classroom.ClassroomApi
        (_client).courses.announcements.list(courseId);
    } catch(e, stackTrace){
      printError("CLASSROOM API ERROR!", e.toString(), stackTrace.toString());
    }
    finally{
      try{
        announcements = response.announcements;
      } on NoSuchMethodError catch(e, stackTrace){
        printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
            extraInfo: "GET request to classroom API returned NULL.");
        announcements = new List<classroom.Announcement>();
      } catch(e, stackTrace){
        printError("ERROR!", e.toString(), stackTrace.toString());
      }
    }

    return announcements;


    /*
    List<classroom.Announcement> announcements =
    new List<classroom.Announcement>();
    int count = 0;
    for (int i = 0; i < 8; i++) {
      //for every dummy course
      for (int j = 0; j < 2; j++) {
        //create 5 announcements per course
        announcements.add(new classroom.Announcement());
        announcements[count].courseId = i.toString();
        announcements[count].text = "Announcement Text";
        count++;
      }
    }
    return announcements;*/
  }

  /*
  TODO:
        3. Remove the fake data if everything works well
   */
  Future<List<classroom.Student>> getStudents(String courseId) async {
    List<classroom.Student> students= new List<classroom.Student>();
    classroom.ListStudentsResponse response;

    await _connectClient();

    try{
      response = await new classroom.ClassroomApi
        (_client).courses.students.list(courseId);
    } catch(e, stackTrace){
      printError("CLASSROOM API ERROR!", e.toString(), stackTrace.toString());
    }
    finally{
      try{
        students = response.students;
      } on NoSuchMethodError catch(e, stackTrace){
        printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
            extraInfo: "GET request to classroom API returned NULL.");
        students = new List<classroom.Student>();
      } catch(e, stackTrace){
        printError("ERROR!", e.toString(), stackTrace.toString());
      }
    }

    return students;/*
    List<classroom.Student> students = new List<classroom.Student>();
    int count = 0;
    for (int i = 0; i < 8; i++) {
      //for every dummy course
      for (int j = 0; j < 5; j++) {
        //create 5 students per course
        students.add(new classroom.Student());
        students[count].courseId = i.toString();
        students[count].userId = "UID" + (count).toString();
        students[count].profile = new classroom.UserProfile();
        students[count].profile.name = new classroom.Name();
        students[count].profile.name.fullName = "ARIAN";
        students[count].profile.emailAddress = "arian@skype.skype.com";
        count++;
      }
    }
    return students;*/
  }
  /*
  TODO:
        3. Remove the fake data if everything works well
   */
  Future<List<classroom.Teacher>> getTeachers(String courseId) async {
    List<classroom.Teacher> teachers = new List<classroom.Teacher>();
    classroom.ListTeachersResponse response;

    await _connectClient();

    try{
      response = await new classroom.ClassroomApi
        (_client).courses.teachers.list(courseId);
    } catch(e, stackTrace){
      printError("CLASSROOM API ERROR!", e.toString(), stackTrace.toString());
    }
    finally{
      try{
        teachers = response.teachers;

      } on NoSuchMethodError catch(e, stackTrace){
        printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
            extraInfo: "GET request to classroom API returned NULL.");
        teachers = new List<classroom.Teacher>();
      } catch(e, stackTrace){
        printError("ERROR!", e.toString(), stackTrace.toString());
      }
    }

    return teachers;/*
    List<classroom.Teacher> teachers = new List<classroom.Teacher>();

    for (int i = 0; i < 8; i++) {
      //for every dummy course
      teachers.add(new classroom.Teacher());
      teachers[i].courseId = i.toString();
      teachers[i].profile = new classroom.UserProfile();
      teachers[i].profile.name = new classroom.Name();
      teachers[i].profile.name.fullName = "Teacher of Course " + i.toString();
    }

    return teachers;*/
  }
  /*
  TODO: 
        3. Remove the fake data if everything works well
   */
  Future<List<classroom.Topic>> getTopics(String courseId) async {
    List<classroom.Topic> topics = new List<classroom.Topic>();
    classroom.ListTopicResponse response;

    await _connectClient();

    try{
      response = await new classroom.ClassroomApi
        (_client).courses.topics.list(courseId);
    } catch(e, stackTrace){
      printError("CLASSROOM API ERROR!", e.toString(), stackTrace.toString());
    }
    finally{
      try{
        topics = response.topic;

      } on NoSuchMethodError catch(e, stackTrace){
        printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
            extraInfo: "GET request to classroom API returned NULL.");
        topics = new List<classroom.Topic>();
      } catch(e, stackTrace){
        printError("ERROR!", e.toString(), stackTrace.toString());
      }
    }

    return topics;/*
    List<classroom.Topic> topics = new List<classroom.Topic>();
    int count = 0;
    for (int i = 0; i < 8; i++) {
      //for every dummy course
      for (int j = 0; j < 5; j++) {
        //create 5 topics per course
        topics.add(new classroom.Topic());
        topics[count].name = "Topic Name " + j.toString();
        topics[count].courseId = i.toString();
        count++;
      }
    }

    return topics;*/
  }
}

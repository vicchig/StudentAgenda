import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:student_agenda/CustomExceptions.dart';


List<classroom.Student> getClassRoster(String courseID, List<classroom.Student> students) {
  List<classroom.Student> studentsInClass = new List<classroom.Student>();

  if(students == null){
    throw NullArgumentException("students", "getClassRoster");
  }

  for(classroom.Student s in students){
    if(s.courseId == courseID){
      studentsInClass.add(s);
    }
  }

  return studentsInClass;
}

List<classroom.Teacher> getCourseTeachers(String courseID, List<classroom.Teacher> teachers){
  List<classroom.Teacher> courseTeachers = new List<classroom.Teacher>();

  if(teachers == null){
    throw NullArgumentException("teachers", "getCourseTeachers");
  }

  for(classroom.Teacher t in teachers){
    if(t.courseId == courseID){
      courseTeachers.add(t);
    }
  }

  return courseTeachers;
}

List<classroom.Topic> getCourseTopics(String courseID, List<classroom.Topic> topics){
  List<classroom.Topic> courseTopics = new List<classroom.Topic>();

  if(topics == null){
    throw NullArgumentException("topics", "getCourseTopics");
  }

  for(classroom.Topic t in topics){
    if(t.courseId == courseID){
      courseTopics.add(t);
    }
  }

  return courseTopics;
}

List<classroom.Announcement> getCourseAnnouncements(String courseID, List<classroom.Announcement> announcements){
  List<classroom.Announcement> courseAnnouncements = new List<classroom.Announcement>();

  if(announcements == null){
    throw NullArgumentException("announcements", "getCourseAnnouncements");
  }

  for(classroom.Announcement a in announcements){
    if(a.courseId == courseID){
      courseAnnouncements.add(a);
    }
  }

  return courseAnnouncements;
}

List<classroom.CourseWork> getCourseWorksForCourse(String courseID, List<classroom.CourseWork> works){
  List<classroom.CourseWork> courseWorks = new List<classroom.CourseWork>();

  if(works == null){
    throw NullArgumentException("works", "getCourseWorksForCourse");
  }

  for(classroom.CourseWork w in works){
    if(w.courseId == courseID){
      courseWorks.add(w);
    }
  }

  return courseWorks;
}
import 'package:flutter/foundation.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:student_agenda/CustomExceptions.dart';
import "package:test/test.dart";
import "package:student_agenda/FirestoreDataManager.dart";

void main(){
  List<classroom.Student> students;
  List<classroom.Teacher> teachers;
  List<classroom.Topic> topics;
  List<classroom.CourseWork> courseWorks;
  List<classroom.Announcement> announcements;

  setUp((){
    students = new List<classroom.Student>();
    teachers = new List<classroom.Teacher>();
    topics = new List<classroom.Topic>();
    courseWorks = new List<classroom.CourseWork>();
    announcements = new List<classroom.Announcement>();

    classroom.Student s1 = new classroom.Student();
    s1.courseId = "1";
    s1.profile = new classroom.UserProfile();
    s1.profile.name = new classroom.Name();
    s1.profile.name.fullName = "Mark";

    classroom.Student s2 = new classroom.Student();
    s2.courseId = "2";
    s2.profile = new classroom.UserProfile();
    s2.profile.name = new classroom.Name();
    s2.profile.name.fullName = "John";

    classroom.Student s3 = new classroom.Student();
    s3.courseId = "1";
    s3.profile = new classroom.UserProfile();
    s3.profile.name = new classroom.Name();
    s3.profile.name.fullName = "Jim";

    classroom.Student s4 = new classroom.Student();
    s4.courseId = "5";
    s4.profile = new classroom.UserProfile();
    s4.profile.name = new classroom.Name();
    s4.profile.name.fullName = "Hank";

    students.addAll([s1, s2, s3, s4]);


    classroom.Teacher t1 = new classroom.Teacher();
    t1.courseId = "1";
    t1.profile = new classroom.UserProfile();
    t1.profile.name = new classroom.Name();
    t1.profile.name.fullName = "Mark";

    classroom.Teacher t2 = new classroom.Teacher();
    t2.courseId = "2";
    t2.profile = new classroom.UserProfile();
    t2.profile.name = new classroom.Name();
    t2.profile.name.fullName = "John";

    classroom.Teacher t3 = new classroom.Teacher();
    t3.courseId = "1";
    t3.profile = new classroom.UserProfile();
    t3.profile.name = new classroom.Name();
    t3.profile.name.fullName = "Jim";

    classroom.Teacher t4 = new classroom.Teacher();
    t4.courseId = "5";
    t4.profile = new classroom.UserProfile();
    t4.profile.name = new classroom.Name();
    t4.profile.name.fullName = "Hank";

    teachers.addAll([t1, t2, t3, t4]);


    classroom.Topic ct1 = new classroom.Topic();
    ct1.courseId = "1";
    ct1.name = "topic 1";

    classroom.Topic ct2 = new classroom.Topic();
    ct2.courseId = "2";
    ct2.name = "topic 2";

    classroom.Topic ct3 = new classroom.Topic();
    ct3.courseId = "1";
    ct3.name = "topic 3";

    classroom.Topic ct4 = new classroom.Topic();
    ct4.courseId = "4";
    ct4.name = "topic 4";

    topics.addAll([ct1, ct2, ct3, ct4]);


    classroom.CourseWork cw1 = new classroom.CourseWork();
    cw1.courseId = "1";
    cw1.id = "20";

    classroom.CourseWork cw2 = new classroom.CourseWork();
    cw2.courseId = "2";
    cw2.id = "21";

    classroom.CourseWork cw3 = new classroom.CourseWork();
    cw3.courseId = "1";
    cw3.id = "22";

    classroom.CourseWork cw4 = new classroom.CourseWork();
    cw4.courseId = "1";
    cw4.id = "23";

    courseWorks.addAll([cw1, cw2, cw3, cw4]);

    classroom.Announcement a1 = new classroom.Announcement();
    a1.courseId = "1";
    a1.id = "20";

    classroom.Announcement a2 = new classroom.Announcement();
    a2.courseId = "2";
    a2.id = "21";

    classroom.Announcement a3 = new classroom.Announcement();
    a3.courseId = "1";
    a3.id = "22";

    classroom.Announcement a4 = new classroom.Announcement();
    a4.courseId = "1";
    a4.id = "23";

    announcements.addAll([a1, a2, a3, a4]);
  });

  tearDown((){
    students.clear();
    students = null;

    teachers.clear();
    students = null;

    topics.clear();
    topics = null;

    courseWorks.clear();
    courseWorks = null;

    announcements.clear();
    announcements = null;
  });

  group("getClassRoster", (){
    test("correctly gets students", (){
      List<String> expected = new List<String>();
      List<String> actual = new List<String>();
      List<classroom.Student> roster = new List<classroom.Student>();

      expected.addAll(["Mark", "Jim"]);

      roster = getClassRoster("1", students);
      expect(roster.length, equals(2));

      for(int i = 0; i < roster.length; i++){
        actual.add(roster[i].profile.name.fullName);
      }

      expect(listEquals(expected, actual), equals(true));
    });

    test("correctly gets no students for no id", (){
      List<String> actual = new List<String>();
      List<classroom.Student> roster = new List<classroom.Student>();

      roster = getClassRoster("6", students);
      for(int i = 0; i < roster.length; i++){
        actual.add(roster[i].profile.name.fullName);
      }

      expect(actual, isEmpty);
    });

    test("throws exception when students is null", (){
      expect( () => getClassRoster("1", null), throwsA(const
      TypeMatcher<NullArgumentException>()));
    });

    test("correctly gets no students for empty list", (){
      expect(getClassRoster("1", new List<classroom.Student>()), isEmpty);
    });
  });

  group("getCourseTeachers", (){
    test("correctly gets teachers", (){
      List<String> expected = new List<String>();
      List<String> actual = new List<String>();
      List<classroom.Teacher> roster = new List<classroom.Teacher>();

      expected.addAll(["Mark", "Jim"]);

      roster = getCourseTeachers("1", teachers);
      expect(roster.length, equals(2));

      for(int i = 0; i < roster.length; i++){
        actual.add(roster[i].profile.name.fullName);
      }

      expect(listEquals(expected, actual), equals(true));
    });

    test("correctly gets no teachers for no id", (){
      List<String> actual = new List<String>();
      List<classroom.Teacher> teacherList = new List<classroom.Teacher>();

      teacherList = getCourseTeachers("6", teachers);
      for(int i = 0; i < teacherList.length; i++){
        actual.add(teacherList[i].profile.name.fullName);
      }

      expect(actual, isEmpty);
    });

    test("throws exception when teachers is null", (){
      expect( () => getCourseTeachers("1", null), throwsA(const
      TypeMatcher<NullArgumentException>()));
    });

    test("correctly gets no teachers for empty list", (){
      expect(getCourseTeachers("1", new List<classroom.Teacher>()), isEmpty);
    });
  });

  group("getCourseTopics", (){
    test("correctly gets topics", (){
      List<String> expected = new List<String>();
      List<String> actual = new List<String>();
      List<classroom.Topic> courseTopics = new List<classroom.Topic>();

      expected.addAll(["topic 1", "topic 3"]);

      courseTopics = getCourseTopics("1", topics);
      expect(courseTopics.length, equals(2));

      for(int i = 0; i < courseTopics.length; i++){
        actual.add(courseTopics[i].name);
      }

      expect(listEquals(expected, actual), equals(true));
    });

    test("correctly gets no topics for no id", (){
      List<String> actual = new List<String>();
      List<classroom.Topic> topicList = new List<classroom.Topic>();

      topicList = getCourseTopics("6", topics);
      for(int i = 0; i < topicList.length; i++){
        actual.add(topicList[i].name);
      }

      expect(actual, isEmpty);
    });

    test("throws exception when topics is null", (){
      expect( () => getCourseTopics("1", null), throwsA(const
      TypeMatcher<NullArgumentException>()));
    });

    test("correctly gets no topics for empty list", (){
      expect(getCourseTopics("1", new List<classroom.Topic>()), isEmpty);
    });
  });

  group("getCourseAnnouncements", (){
    test("correctly gets announcements", (){
      List<String> expected = new List<String>();
      List<String> actual = new List<String>();
      List<classroom.Announcement> courseAnnouncements = new List<classroom.Announcement>();

      expected.addAll(["20", "22", "23"]);

      courseAnnouncements = getCourseAnnouncements("1", announcements);
      expect(courseAnnouncements.length, equals(3));

      for(int i = 0; i < courseAnnouncements.length; i++){
        actual.add(courseAnnouncements[i].id);
      }

      expect(listEquals(expected, actual), equals(true));
    });

    test("correctly gets no announcements for no id", (){
      List<String> actual = new List<String>();
      List<classroom.Announcement> announcementList = new List<classroom.Announcement>();

      announcementList = getCourseAnnouncements("6", announcements);
      for(int i = 0; i < announcementList.length; i++){
        actual.add(announcementList[i].id);
      }

      expect(actual, isEmpty);
    });

    test("throws exception when announcements is null", (){
      expect( () => getCourseAnnouncements("1", null), throwsA(const
      TypeMatcher<NullArgumentException>()));
    });

    test("correctly gets no topics for empty list", (){
      expect(getCourseAnnouncements("1", new List<classroom.Announcement>()), isEmpty);
    });
  });

  group("getCourseWorksForCourse", (){
    test("correctly gets topics", (){
      List<String> expected = new List<String>();
      List<String> actual = new List<String>();
      List<classroom.CourseWork> courseWorksList = new List<classroom.CourseWork>();

      expected.addAll(["20", "22", "23"]);

      courseWorksList = getCourseWorksForCourse("1", courseWorks);
      expect(courseWorksList.length, equals(3));
      for(int i = 0; i < courseWorksList.length; i++){
        actual.add(courseWorksList[i].id);
      }

      expect(listEquals(expected, actual), equals(true));
    });

    test("correctly gets no topics for no id", (){
      List<String> actual = new List<String>();
      List<classroom.CourseWork> topicList = new List<classroom.CourseWork>();

      topicList = getCourseWorksForCourse("6",courseWorks);
      for(int i = 0; i < topicList.length; i++){
        actual.add(topicList[i].id);
      }

      expect(actual, isEmpty);
    });

    test("throws exception when topics is null", (){
      expect( () => getCourseWorksForCourse("1", null), throwsA(const
      TypeMatcher<NullArgumentException>()));
    });

    test("correctly gets no topics for empty list", (){
      expect(getCourseWorksForCourse("1", new List<classroom.CourseWork>()), isEmpty);
    });
  });
}
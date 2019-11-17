import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;

import 'Screens/addGoalsScreen.dart';
import 'ClassroomApiAccess.dart';
import 'Utilities/goal.dart';

void doTransaction(String onSuccess, String onError, Function transaction) async{
  try {
    await Firestore.instance.runTransaction((Transaction trans) async {
      await transaction();
    });
    print(onSuccess);
  }catch(e){
    print(onError);
    print(e);
  }
}

void setUserData(FirebaseUser user) async {
  DocumentReference ref = Firestore.instance.collection('users').
                          document(user.uid);

  await ref.setData({
    'uid': user.uid,
    'email': user.email,
    'photoURL': user.photoUrl,
    'displayName': user.displayName,
    'lastSeen': DateTime.now()
  }, merge: true);
}

void setUserClassroomData(FirebaseUser user) async{
  DocumentReference ref = Firestore.instance.collection("users").
                          document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Course> userCourses = await classroomInst.getCourses();
  Map<int, classroom.Course> map = userCourses.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index){
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.setData({
    "CourseObjects": mapToUpload
  }, merge: true);
}

void setUserCourseWorkData(FirebaseUser user) async {
  DocumentReference ref = Firestore.instance.collection("users").
  document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.CourseWork> userCourses = await classroomInst.getCourseWork();
  Map<int, classroom.CourseWork> map = userCourses.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index){
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.setData({
    "CourseWorkObjects": mapToUpload
  }, merge: true);
}

void setUserAnnouncementData(FirebaseUser user) async {
  DocumentReference ref = Firestore.instance.collection("users").
  document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Announcement> userAnnouncements = await classroomInst.getAnnouncements();
  Map<int, classroom.Announcement> map = userAnnouncements.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index){
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.setData({
    "AnnouncementObjects": mapToUpload
  }, merge: true);
}

void setUserClassStudents(FirebaseUser user) async {
  DocumentReference ref = Firestore.instance.collection("users").
  document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Student> userStudents = await classroomInst.getStudents();
  Map<int, classroom.Student> map = userStudents.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index){
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.setData({
    "StudentObjects": mapToUpload
  }, merge: true);
}

void setUserClassTeachers(FirebaseUser user) async {
  DocumentReference ref = Firestore.instance.collection("users").
  document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Teacher> userTeachers = await classroomInst.getTeachers();
  Map<int, classroom.Teacher> map = userTeachers.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index){
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.setData({
    "TeacherObjects": mapToUpload
  }, merge: true);
}



void addUserGoal(FirebaseUser user, Goal st) async {
  // May require additional error checking depending on how
  // how we choose to differentiate between goal types
  if (st.text == null) {
    return;
  }

  DocumentReference ref = Firestore.instance.collection("users").
  document(user.uid);

  // print(user.uid);
  // print((await ref.get()).data["Subtasks"]);

  Map<dynamic, dynamic> subtasks = (await ref.get()).data["Subtasks"];
  List<int> keys = subtasks.keys.toList().map((ele) => int.parse(ele)).toList();
  int newKey;
  for (newKey = 0; newKey < subtasks.length; newKey++) {
    if (!(keys.contains(newKey))) {
      break;
    }
  }

  subtasks[newKey.toString()] = st.toJson();

  await ref.setData({
    "Subtasks": subtasks
  }, merge: true);
}


void setUserClassTopics(FirebaseUser user) async {
  DocumentReference ref = Firestore.instance.collection("users").
  document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Topic> userTopics = await classroomInst.getTopics();
  Map<int, classroom.Topic> map = userTopics.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index){
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.setData({
    "TopicObjects": mapToUpload
  }, merge: true);
}

void setUserCourseGoals(FirebaseUser user, List<Goal> courseGoals) async {
  DocumentReference ref = Firestore.instance.collection("users").
  document(user.uid);

  Map<int, Goal> map = courseGoals.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index){
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.setData({
    "CourseGoalObjects": mapToUpload
  }, merge: true);
}


Future<List<classroom.Course>> pullCourses(FirebaseUser user) async{
  List<classroom.Course> courses = new List<classroom.Course>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance.collection("users").document(user.uid).get().then((
        result) {
      courseObjectListMap = result.data["CourseObjects"];
    });


    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courses.add(classroom.Course.fromJson(entry.value));
    });
    print("Successfully pulled courses.");
  }catch(e){
    print(e);
  }
  return courses;
}

Future<List<classroom.CourseWork>> pullCourseWorkData(FirebaseUser user) async{
  List<classroom.CourseWork> courseWorks = new List<classroom.CourseWork>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance.collection("users").document(user.uid).get().then((
        result) {
      courseObjectListMap = result.data["CourseWorkObjects"];
    });


    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseWorks.add(classroom.CourseWork.fromJson(entry.value));
    });
    print("Successfully pulled course works.");
  }catch(e){
    print(e);
  }
  return courseWorks;
}

Future<List<classroom.Announcement>> pullCourseAnnouncements(FirebaseUser user) async{
  List<classroom.Announcement> courseAnnouncements = new List<classroom.Announcement>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance.collection("users").document(user.uid).get().then((
        result) {
      courseObjectListMap = result.data["AnnouncementObjects"];
    });


    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseAnnouncements.add(classroom.Announcement.fromJson(entry.value));
    });
    print("Successfully pulled course announcements.");
  }catch(e){
    print(e);
  }
  return courseAnnouncements;
}

Future<List<classroom.Student>> pullClassmates(FirebaseUser user) async{
  List<classroom.Student> courseStudents = new List<classroom.Student>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance.collection("users").document(user.uid).get().then((
        result) {
      courseObjectListMap = result.data["StudentObjects"];
    });


    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseStudents.add(classroom.Student.fromJson(entry.value));
    });
    print("Successfully pulled students.");
  }catch(e){
    print(e);
  }
  return courseStudents;
}

Future<List<classroom.Teacher>> pullTeachers(FirebaseUser user) async{
  List<classroom.Teacher> courseTeachers = new List<classroom.Teacher>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance.collection("users").document(user.uid).get().then((
        result) {
      courseObjectListMap = result.data["TeacherObjects"];
    });


    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseTeachers.add(classroom.Teacher.fromJson(entry.value));
    });
    print("Successfully pulled teachers.");
  }catch(e){
    print(e);
  }
  return courseTeachers;
}

Future<List<classroom.Topic>> pullTopics(FirebaseUser user) async{
  List<classroom.Topic> courseTopics = new List<classroom.Topic>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance.collection("users").document(user.uid).get().then((
        result) {
      courseObjectListMap = result.data["TopicObjects"];
    });


    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseTopics.add(classroom.Topic.fromJson(entry.value));
    });
    print("Successfully pulled topics.");
  }catch(e){
    print(e);
  }
  return courseTopics;
}

Future<List<Goal>> pullGoals(FirebaseUser user) async {
  List<Goal> courseGoals = new List<Goal>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance.collection("users").document(user.uid).get().then((
        result) {
      courseObjectListMap = result.data["CourseGoalObjects"];
    });


    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseGoals.add(Goal.fromJson(entry.value));
    });
    print("Successfully pulled goals.");
  }catch(e){
    print(e);
  }
  return courseGoals;
}

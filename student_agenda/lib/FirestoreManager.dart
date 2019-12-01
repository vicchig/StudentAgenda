import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:student_agenda/Utilities/util.dart';

import 'ClassroomApiAccess.dart';
import 'Utilities/goal.dart';

Future<void> doTransaction(String onSuccess, String onError,
    Function transaction) async {
  try {
    await Firestore.instance.runTransaction((Transaction trans) async {
      await transaction();
    });
    print(onSuccess);
  } catch (e) {
    print(onError);
    print(e);
  }
}

Future<void> setUserData(FirebaseUser user, {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection('users').document(user.uid);

  await ref.setData({
    'uid': user.uid,
    'email': user.email,
    'photoURL': user.photoUrl,
    'displayName': user.displayName,
    'lastSeen': DateTime.now()
  }, merge: toMerge);
}

Future<void> setUserClassroomData(FirebaseUser user, {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection("users").document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Course> userCourses = await classroomInst.getCourses();
  Map<int, classroom.Course> map;
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  try {
    map = userCourses.asMap();
  } on ArgumentError catch (e, stackTrace) {
    printError("ARGUMENT ERROR!", e.toString(), stackTrace.toString());
    map = new Map<int, classroom.Course>();
  } on NoSuchMethodError catch (e, stackTrace) {
    printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
        extraInfo: "This is likely because no info was pulled from Classroom."
            " Make sure that classroom actually contains the requested data."
            " If it does not, the implementation likely has bugs.");
  } catch (e, stackTrace) {
    printError("ERROR!", e.toString(), stackTrace.toString());
  } finally {
    List<int> keys;
    try {
      keys = map.keys.toList();
    } on NoSuchMethodError catch (e, stackTrace) {
      printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString());
      keys = new List<int>();
    } catch (e, stackTrace) {
      printError("ERROR!", e.toString(), stackTrace.toString());
    } finally {
      keys.forEach((int index) {
        mapToUpload[index.toString()] = map[index].toJson();
      });
    }
  }

  await ref.updateData({"CourseObjects": FieldValue.delete()});

  await ref.setData({"CourseObjects": mapToUpload}, merge: toMerge);
}

Future<void> setAllUserCourseWorkData(FirebaseUser user, List<String> courseIds,
    {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection("users").document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.CourseWork> userCourseWorks = [];
  for (String courseId in courseIds) {
    List<classroom.CourseWork> tmp =
    await classroomInst.getCourseWork(courseId);
    if (tmp != null) {
      userCourseWorks.addAll(tmp);
    }
  }
  if (userCourseWorks.length == 0) {
    return;
  }
  Map<int, classroom.CourseWork> map;
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  try {
    map = userCourseWorks.asMap();
  } on ArgumentError catch (e, stackTrace) {
    printError("ARGUMENT ERROR!", e.toString(), stackTrace.toString());
    map = new Map<int, classroom.CourseWork>();
  } on NoSuchMethodError catch (e, stackTrace) {
    printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
        extraInfo: "This is likely because no info was pulled from Classroom."
            " Make sure that classroom actually contains the requested data."
            " If it does not, the implementation likely has bugs.");
  } catch (e, stackTrace) {
    printError("ERROR!", e.toString(), stackTrace.toString());
  } finally {
    List<int> keys;

    try {
      keys = map.keys.toList();
    } on NoSuchMethodError catch (e, stackTrace) {
      printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString());
      keys = new List<int>();
    } catch (e, stackTrace) {
      printError("ERROR!", e.toString(), stackTrace.toString());
    } finally {
      keys.forEach((int index) {
        mapToUpload[index.toString()] = map[index].toJson();
      });
    }
  }

  await ref.updateData({"CourseWorkObjects": FieldValue.delete()});

  await ref.setData({"CourseWorkObjects": mapToUpload}, merge: toMerge);
}

Future<void> setAllUserAnnouncementData(FirebaseUser user,
    List<String> courseIds,
    {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection("users").document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Announcement> userAnnouncements = [];
  for (String courseId in courseIds) {
    List<classroom.Announcement> tmp =
    await classroomInst.getAnnouncements(courseId);
    if (tmp != null) {
      userAnnouncements.addAll(tmp);
    }
  }
  if (userAnnouncements.length == 0) {
    return;
  }
  Map<int, classroom.Announcement> map;
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  try {
    map = userAnnouncements.asMap();
  } on ArgumentError catch (e, stackTrace) {
    printError("ARGUMENT ERROR!", e.toString(), stackTrace.toString());
    map = new Map<int, classroom.Announcement>();
  } on NoSuchMethodError catch (e, stackTrace) {
    printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
        extraInfo: "This is likely because no info was pulled from Classroom."
            " Make sure that classroom actually contains the requested data."
            " If it does not, the implementation likely has bugs.");
  } catch (e, stackTrace) {
    printError("ERROR!", e.toString(), stackTrace.toString());
  } finally {
    List<int> keys;

    try {
      keys = map.keys.toList();
    } on NoSuchMethodError catch (e, stackTrace) {
      printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString());
      keys = new List<int>();
    } catch (e, stackTrace) {
      printError("ERROR!", e.toString(), stackTrace.toString());
    } finally {
      keys.forEach((int index) {
        mapToUpload[index.toString()] = map[index].toJson();
      });
    }
  }

  await ref.updateData({"AnnouncementObjects": FieldValue.delete()});

  await ref.setData({"AnnouncementObjects": mapToUpload}, merge: toMerge);
}

Future<void> setAllUserClassStudents(FirebaseUser user, List<String> courseIds,
    {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection("users").document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Student> userStudents = [];
  for (String courseId in courseIds) {
    List<classroom.Student> tmp = await classroomInst.getStudents(courseId);
    if (tmp != null) {
      userStudents.addAll(tmp);
    }
  }
  if (userStudents.length == 0) {
    return;
  }
  Map<int, classroom.Student> map;
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  try {
    map = userStudents.asMap();
  } on ArgumentError catch (e, stackTrace) {
    printError("ARGUMENT ERROR!", e.toString(), stackTrace.toString());
    map = new Map<int, classroom.Student>();
  } on NoSuchMethodError catch (e, stackTrace) {
    printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
        extraInfo: "This is likely because no info was pulled from Classroom."
            " Make sure that classroom actually contains the requested data."
            " If it does not, the implementation likely has bugs.");
  } catch (e, stackTrace) {
    printError("ERROR!", e.toString(), stackTrace.toString());
  } finally {
    List<int> keys;

    try {
      keys = map.keys.toList();
    } on NoSuchMethodError catch (e, stackTrace) {
      printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString());
      keys = new List<int>();
    } catch (e, stackTrace) {
      printError("ERROR!", e.toString(), stackTrace.toString());
    } finally {
      keys.forEach((int index) {
        mapToUpload[index.toString()] = map[index].toJson();
      });
    }

    await ref.updateData({"StudentObjects": FieldValue.delete()});

    await ref.setData({"StudentObjects": mapToUpload}, merge: toMerge);
  }
}

Future<void> setAllUserClassTeachers(FirebaseUser user, List<String> courseIds,
    {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection("users").document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Teacher> userTeachers = [];
  for (String courseId in courseIds) {
    List<classroom.Teacher> tmp = await classroomInst.getTeachers(courseId);
    if (tmp != null) {
      userTeachers.addAll(tmp);
    }
  }
  if (userTeachers.length == 0) {
    return;
  }
  Map<int, classroom.Teacher> map;
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  try {
    map = userTeachers.asMap();
  } on ArgumentError catch (e, stackTrace) {
    printError("ARGUMENT ERROR!", e.toString(), stackTrace.toString());
    map = new Map<int, classroom.Teacher>();
  } on NoSuchMethodError catch (e, stackTrace) {
    printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
        extraInfo: "This is likely because no info was pulled from Classroom."
            " Make sure that classroom actually contains the requested data."
            " If it does not, the implementation likely has bugs.");
  } catch (e, stackTrace) {
    printError("ERROR!", e.toString(), stackTrace.toString());
  } finally {
    List<int> keys;

    try {
      keys = map.keys.toList();
    } on NoSuchMethodError catch (e, stackTrace) {
      printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString());
      keys = new List<int>();
    } catch (e, stackTrace) {
      printError("ERROR!", e.toString(), stackTrace.toString());
    } finally {
      keys.forEach((int index) {
        mapToUpload[index.toString()] = map[index].toJson();
      });
    }
  }

  await ref.updateData({"TeacherObjects": FieldValue.delete()});

  await ref.setData({"TeacherObjects": mapToUpload}, merge: toMerge);
}

Future<void> setAllUserClassTopics(FirebaseUser user, List<String> courseIds,
    {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection("users").document(user.uid);

  ClassroomApiAccess classroomInst = ClassroomApiAccess.getInstance();
  List<classroom.Topic> userTopics = [];
  for (String courseId in courseIds) {
    List<classroom.Topic> tmp = await classroomInst.getTopics(courseId);
    if (tmp != null) {
      userTopics.addAll(tmp);
    }
  }
  if (userTopics.length == 0) {
    return;
  }
  Map<int, classroom.Topic> map;
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  try {
    map = userTopics.asMap();
  } on ArgumentError catch (e, stackTrace) {
    printError("ARGUMENT ERROR!", e.toString(), stackTrace.toString());
    map = new Map<int, classroom.Topic>();
  } on NoSuchMethodError catch (e, stackTrace) {
    printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString(),
        extraInfo: "This is likely because no info was pulled from Classroom."
            " Make sure that classroom actually contains the requested data."
            " If it does not, the implementation likely has bugs.");
  } catch (e, stackTrace) {
    printError("ERROR!", e.toString(), stackTrace.toString());
  } finally {
    List<int> keys;
    try {
      keys = map.keys.toList();
    } on NoSuchMethodError catch (e, stackTrace) {
      printError("NO SUCH METHOD ERROR!", e.toString(), stackTrace.toString());
      keys = new List<int>();
    } catch (e, stackTrace) {
      printError("ERROR!", e.toString(), stackTrace.toString());
    } finally {
      keys.forEach((int index) {
        mapToUpload[index.toString()] = map[index].toJson();
      });
    }
  }

  await ref.updateData({"TopicObjects": FieldValue.delete()});

  await ref.setData({"TopicObjects": mapToUpload}, merge: toMerge);
}

Future<void> setUserCourseGoals(FirebaseUser user, List<Goal> courseGoals,
    String goalType,
    {toMerge: true}) async {
  DocumentReference ref =
  Firestore.instance.collection("users").document(user.uid);

  Map<int, Goal> map = courseGoals.asMap();
  Map<String, dynamic> mapToUpload = new Map<String, dynamic>();

  List<int> keys = map.keys.toList();
  keys.forEach((int index) {
    mapToUpload[index.toString()] = map[index].toJson();
  });

  await ref.updateData({goalType: FieldValue.delete()});

  await ref.setData({goalType: mapToUpload}, merge: toMerge);
}

Future<List<classroom.Course>> pullCourses(FirebaseUser user) async {
  List<classroom.Course> courses = new List<classroom.Course>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((result) {
      courseObjectListMap = result.data["CourseObjects"];
    });

    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courses.add(classroom.Course.fromJson(entry.value));
    });
    print("Successfully pulled courses.");
  } catch (e) {
    print(e);
  }
  return courses;
}

Future<List<classroom.CourseWork>> pullCourseWorkData(FirebaseUser user) async {
  List<classroom.CourseWork> courseWorks = new List<classroom.CourseWork>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((result) {
      courseObjectListMap = result.data["CourseWorkObjects"];
    });

    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseWorks.add(classroom.CourseWork.fromJson(entry.value));
    });
    print("Successfully pulled course works.");
  } catch (e) {
    print(e);
  }
  return courseWorks;
}

Future<List<classroom.Announcement>> pullCourseAnnouncements(
    FirebaseUser user) async {
  List<classroom.Announcement> courseAnnouncements =
  new List<classroom.Announcement>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((result) {
      courseObjectListMap = result.data["AnnouncementObjects"];
    });

    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseAnnouncements.add(classroom.Announcement.fromJson(entry.value));
    });
    print("Successfully pulled course announcements.");
  } catch (e) {
    print(e);
  }
  return courseAnnouncements;
}

Future<List<classroom.Student>> pullClassmates(FirebaseUser user) async {
  List<classroom.Student> courseStudents = new List<classroom.Student>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((result) {
      courseObjectListMap = result.data["StudentObjects"];
    });

    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseStudents.add(classroom.Student.fromJson(entry.value));
    });
    print("Successfully pulled students.");
  } catch (e) {
    print(e);
  }
  return courseStudents;
}

Future<List<classroom.Teacher>> pullTeachers(FirebaseUser user) async {
  List<classroom.Teacher> courseTeachers = new List<classroom.Teacher>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((result) {
      courseObjectListMap = result.data["TeacherObjects"];
    });

    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseTeachers.add(classroom.Teacher.fromJson(entry.value));
    });
    print("Successfully pulled teachers.");
  } catch (e) {
    print(e);
  }
  return courseTeachers;
}

Future<List<classroom.Topic>> pullTopics(FirebaseUser user) async {
  List<classroom.Topic> courseTopics = new List<classroom.Topic>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((result) {
      courseObjectListMap = result.data["TopicObjects"];
    });

    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseTopics.add(classroom.Topic.fromJson(entry.value));
    });
    print("Successfully pulled topics.");
  } catch (e) {
    print(e);
  }
  return courseTopics;
}

Future<List<Goal>> pullGoals(FirebaseUser user, String goalType) async {
  List<Goal> courseGoals = new List<Goal>();
  Map<dynamic, dynamic> courseObjectListMap;
  try {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((result) {
      courseObjectListMap = result.data[goalType];
    });

    courseObjectListMap.entries.forEach((MapEntry<dynamic, dynamic> entry) {
      courseGoals.add(Goal.fromJson(entry.value));
    });
    print("Successfully pulled goals.");
  } catch (e) {
    print(e);
  }
  return courseGoals;
}

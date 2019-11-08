import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;

import 'ClassroomApiAccess.dart';

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;

import 'ClassroomApiAccess.dart';

void doTransaction(String onSuccess, String onError, Function transaction){
  try{
    Firestore.instance.runTransaction((Transaction trans) async {
      transaction();
    });
    print(onSuccess);
  }catch(e){
    print(onError);
    print(e);
  }
}

void updateUserData(FirebaseUser user) async {
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

void updateUserClassroomData(FirebaseUser user) async{
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

  ref.setData({
    "CourseObjects": mapToUpload
  }, merge: true);
}


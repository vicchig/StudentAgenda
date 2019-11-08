import 'package:cloud_firestore/cloud_firestore.dart';

void doTransaction(String onSuccess, String onError, Function transaction){
  Firestore.instance.runTransaction((Transaction trans) async {
    transaction();
  }).then((val) => (){
    print(onSuccess);
  }).catchError((error) => (){
    print(onError);
    print(error);
  });
}
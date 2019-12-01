import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:http/http.dart'
    show BaseRequest, IOClient, Response, StreamedResponse;
import 'package:http/io_client.dart';

import '../FirestoreManager.dart';
import 'goal.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      classroom.ClassroomApi.ClassroomCoursesReadonlyScope,
      classroom.ClassroomApi.ClassroomAnnouncementsReadonlyScope,
      classroom.ClassroomApi.ClassroomCourseworkStudentsReadonlyScope,
      classroom.ClassroomApi.ClassroomRostersReadonlyScope,
      classroom.ClassroomApi.ClassroomTopicsReadonlyScope,
      classroom.ClassroomApi.ClassroomCourseworkMeReadonlyScope
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  final scopes = [classroom.ClassroomApi.ClassroomCoursesScope];

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // Constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      }
      return Observable.just({});
    });
  }

  // Google Sign In
  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    firebaseUser = (await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken)))
        .user;

    doTransaction("Successfully updated user data on sign in.",
        "ERROR: Failed to update user data on sign in.", () {
          setUserData(firebaseUser);
        });

    print("signed in " + firebaseUser.displayName);
    //update user classes on log in
    await doTransaction("Successfully updated course information on sign in.",
        "ERROR: Failed to update course information on sign in", () {
          setUserClassroomData(firebaseUser);
        });

    //get courses from Firebase as we need the course ids to pull the rest of
    //the data
    List<classroom.Course> courses = await pullCourses(firebaseUser);

    List<Goal> goals = new List<Goal>();
    goals.add(new Goal(name: "menu favor deer", text: "rice ideal deer rice", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T06:17:20", dateAssigned: "2019-11-28T10:26:53", dateCompleted: "2019-11-28T13:13:33"));
    goals.add(new Goal(name: "plot glove bind", text: "pole trunk cool ease", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T06:41:42", dateAssigned: "2019-11-27T12:50:40", dateCompleted: "2019-11-27T15:37:20"));
    goals.add(new Goal(name: "line mouse fate", text: "ugly false wave wave", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-12-01T07:05:23", dateAssigned: "2019-11-29T06:59:00", dateCompleted: "2019-12-02T08:43:33"));
    goals.add(new Goal(name: "mine stake deer", text: "myth cabin spot free", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T07:54:34", dateAssigned: "2019-11-28T15:07:47", dateCompleted: "2019-11-28T17:54:27"));
    goals.add(new Goal(name: "loud swear oven", text: "rope wound port mess", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T02:42:04", dateAssigned: "2019-11-27T05:10:11", dateCompleted: "2019-11-27T07:56:51"));
    goals.add(new Goal(name: "sink float loud", text: "free clock belt pace", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-28T17:03:04", dateAssigned: "2019-11-27T01:10:23", dateCompleted: "2019-11-27T03:57:03"));
    goals.add(new Goal(name: "lung shore yell", text: "spot grain risk belt", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T23:22:49", dateAssigned: "2019-11-29T22:19:50", dateCompleted: "2019-11-29T22:19:50"));
    goals.add(new Goal(name: "rope apple date", text: "cake guilt flow peer", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-02T16:57:53", dateAssigned: "2019-11-30T04:39:37", dateCompleted: "2019-11-30T04:39:37"));
    goals.add(new Goal(name: "tail spill bury", text: "pure crash pant suit", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-28T09:26:31", dateAssigned: "2019-11-26T10:26:20", dateCompleted: "2019-11-29T13:11:30"));
    goals.add(new Goal(name: "menu grant quit", text: "gear waste coal boom", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-29T06:58:45", dateAssigned: "2019-11-27T00:07:49", dateCompleted: "2019-11-30T11:51:02"));
    goals.add(new Goal(name: "jail salad bear", text: "coal sweep lawn cake", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-29T16:43:45", dateAssigned: "2019-11-27T11:56:39", dateCompleted: "2019-11-30T16:43:32"));
    goals.add(new Goal(name: "date arena ease", text: "rank crack bake mere", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T05:10:49", dateAssigned: "2019-11-29T11:48:46", dateCompleted: "2019-11-29T11:48:46"));
    goals.add(new Goal(name: "drop value plot", text: "suit slice beat poem", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-27T19:04:34", dateAssigned: "2019-11-26T03:35:58", dateCompleted: "2019-11-28T22:15:02"));
    goals.add(new Goal(name: "fund virus rose", text: "gaze craft peer dirt", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T06:32:05", dateAssigned: "2019-11-29T15:18:44", dateCompleted: "2019-11-29T15:18:44"));
    goals.add(new Goal(name: "pole stake myth", text: "mask newly ugly host", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-01T22:23:00", dateAssigned: "2019-11-28T08:03:42", dateCompleted: "2019-11-28T08:03:42"));
    goals.add(new Goal(name: "line salad rank", text: "tube draft sigh plot", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T06:41:34", dateAssigned: "2019-11-28T21:50:10", dateCompleted: "2019-12-01T13:27:30"));
    goals.add(new Goal(name: "cool white pink", text: "lung giant tail menu", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T14:24:51", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "yell arena mess", text: "dear craft wind lost", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-04T18:25:12", dateAssigned: "2019-11-30T18:20:39", dateCompleted: "2019-11-30T18:20:39"));
    goals.add(new Goal(name: "rose lover dirt", text: "bell ahead auto high", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-02T04:24:24", dateAssigned: "2019-11-28T09:13:28", dateCompleted: "2019-11-28T09:13:28"));
    goals.add(new Goal(name: "yell minor oven", text: "bury trait roll host", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-12-01T01:52:13", dateAssigned: "2019-11-28T21:22:38", dateCompleted: "2019-11-29T00:09:18"));
    goals.add(new Goal(name: "bite delay heel", text: "aide weigh pack menu", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T14:03:06", dateAssigned: "2019-11-27T23:14:13", dateCompleted: "2019-11-28T02:00:53"));
    goals.add(new Goal(name: "beat couch pant", text: "hold twist easy spot", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T11:55:02", dateAssigned: "2019-11-27T19:42:06", dateCompleted: "2019-11-27T22:28:46"));
    goals.add(new Goal(name: "pure uncle high", text: "flee tribe mask suit", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-05T12:22:59", dateAssigned: "2019-12-01T10:48:47", dateCompleted: "2019-12-01T10:48:47"));
    goals.add(new Goal(name: "pace flame crop", text: "pipe upset load rope", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T02:50:42", dateAssigned: "2019-11-28T08:08:34", dateCompleted: "2019-11-28T10:55:14"));
    goals.add(new Goal(name: "flag slide host", text: "bell short sink spot", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-03T02:51:29", dateAssigned: "2019-11-30T06:06:58", dateCompleted: "2019-11-30T06:06:58"));
    goals.add(new Goal(name: "pile patch load", text: "gear cheek corn gaze", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-28T11:22:01", dateAssigned: "2019-11-26T22:16:21", dateCompleted: "2019-11-27T01:03:01"));
    goals.add(new Goal(name: "rice favor risk", text: "mode favor port shit", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T07:50:50", dateAssigned: "2019-12-01T08:36:36", dateCompleted: "2019-12-01T08:36:36"));
    goals.add(new Goal(name: "firm pride dare", text: "date harsh tent tail", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-02T09:21:15", dateAssigned: "2019-11-30T07:30:08", dateCompleted: "2019-11-30T07:30:08"));
    goals.add(new Goal(name: "firm humor pure", text: "rice store okay soup", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T13:51:17", dateAssigned: "2019-11-27T14:45:38", dateCompleted: "2019-11-30T15:17:18"));
    goals.add(new Goal(name: "shit ghost flee", text: "teen wrong firm risk", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T10:48:11", dateAssigned: "2019-11-27T04:18:28", dateCompleted: "2019-11-27T07:05:08"));
    goals.add(new Goal(name: "heel bunch hold", text: "gaze rough tire shit", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-29T07:44:30", dateAssigned: "2019-11-28T01:34:10", dateCompleted: "2019-11-29T23:21:20"));
    goals.add(new Goal(name: "peer apple dear", text: "like burst wipe odds", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-02T20:17:49", dateAssigned: "2019-11-30T21:50:56", dateCompleted: "2019-11-30T21:50:56"));
    goals.add(new Goal(name: "pure Irish pace", text: "flee brush roll date", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-29T22:07:13", dateAssigned: "2019-11-28T04:59:49", dateCompleted: "2019-11-30T19:25:16"));
    goals.add(new Goal(name: "sink shore tire", text: "tail magic mess palm", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-29T23:13:42", dateAssigned: "2019-11-28T18:29:33", dateCompleted: "2019-12-01T03:35:08"));
    goals.add(new Goal(name: "pack shine pace", text: "menu humor cake risk", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-30T07:12:45", dateAssigned: "2019-11-29T03:12:23", dateCompleted: "2019-11-29T05:59:03"));
    goals.add(new Goal(name: "coal shell tail", text: "mail swing pray rice", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-27T14:25:47", dateAssigned: "2019-11-26T01:11:33", dateCompleted: "2019-11-26T03:58:13"));
    goals.add(new Goal(name: "tire mount peer", text: "chef ankle rank rose", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-01T22:44:48", dateAssigned: "2019-11-28T22:13:25", dateCompleted: "2019-11-28T22:13:25"));
    goals.add(new Goal(name: "bear rough mode", text: "moon since loud belt", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T09:49:10", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "menu grain risk", text: "moon magic poem flee", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T05:54:15", dateAssigned: "2019-11-28T21:42:43", dateCompleted: "2019-11-30T23:18:47"));
    goals.add(new Goal(name: "fade wound flow", text: "wipe onion rate peer", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T03:35:56", dateAssigned: "2019-11-28T01:35:50", dateCompleted: "2019-11-28T04:22:30"));
    goals.add(new Goal(name: "pray burst myth", text: "host brush plot ease", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T16:16:36", dateAssigned: "2019-11-29T05:18:23", dateCompleted: "2019-11-29T08:05:03"));
    goals.add(new Goal(name: "peer pitch flee", text: "quit smoke sink pine", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-05T18:49:05", dateAssigned: "2019-12-02T19:42:28", dateCompleted: "2019-12-02T19:42:28"));
    goals.add(new Goal(name: "cool blade rope", text: "chef apple tent flee", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-27T14:25:21", dateAssigned: "2019-11-26T07:58:37", dateCompleted: "2019-11-28T18:54:48"));
    goals.add(new Goal(name: "pray false gear", text: "boom Roman coal pine", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-06T05:23:40", dateAssigned: "2019-12-03T06:51:11", dateCompleted: "2019-12-03T06:51:11"));
    goals.add(new Goal(name: "bake round host", text: "pack chase cake dare", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-12-01T03:32:02", dateAssigned: "2019-11-29T16:01:15", dateCompleted: "2019-11-29T18:47:55"));
    goals.add(new Goal(name: "jail march tire", text: "ugly greet tail lost", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T19:56:20", dateAssigned: "2019-12-01T04:27:16", dateCompleted: "2019-12-01T04:27:16"));
    goals.add(new Goal(name: "menu swear swim", text: "ease yours date oven", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-29T06:23:53", dateAssigned: "2019-11-27T15:14:47", dateCompleted: "2019-11-27T18:01:27"));
    goals.add(new Goal(name: "mere found wise", text: "pure final easy jail", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-01T21:49:40", dateAssigned: "2019-11-30T13:26:22", dateCompleted: "2019-11-30T13:26:22"));
    goals.add(new Goal(name: "mess cabin teen", text: "bite uncle tail flat", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-30T12:52:36", dateAssigned: "2019-11-28T23:51:58", dateCompleted: "2019-12-01T02:47:58"));
    goals.add(new Goal(name: "soup outer wise", text: "gang alien spot bind", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T18:42:38", dateAssigned: "2019-11-27T22:20:14", dateCompleted: "2019-11-28T01:06:54"));
    goals.add(new Goal(name: "host pitch rope", text: "rank ghost load okay", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-29T11:46:09", dateAssigned: "2019-11-28T04:39:54", dateCompleted: "2019-11-30T14:14:44"));
    goals.add(new Goal(name: "tube flour hold", text: "dare civic cool ease", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T16:05:16", dateAssigned: "2019-11-27T21:29:16", dateCompleted: "2019-11-28T00:15:56"));
    goals.add(new Goal(name: "drop magic menu", text: "bake drunk fund roll", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T18:07:01", dateAssigned: "2019-11-30T11:16:24", dateCompleted: "2019-11-30T11:16:24"));
    goals.add(new Goal(name: "load vital lost", text: "easy shelf heel teen", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-04T06:06:31", dateAssigned: "2019-11-30T09:30:44", dateCompleted: "2019-11-30T09:30:44"));
    goals.add(new Goal(name: "bear favor bind", text: "pack fault pack jail", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-12-01T08:55:45", dateAssigned: "2019-11-29T16:42:32", dateCompleted: "2019-11-29T19:29:12"));
    goals.add(new Goal(name: "like final poet", text: "like shrug firm mine", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T00:36:20", dateAssigned: "2019-11-27T00:48:01", dateCompleted: "2019-11-29T22:13:12"));
    goals.add(new Goal(name: "gear pause flag", text: "myth rider pace crop", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T10:04:51", dateAssigned: "2019-11-28T08:40:57", dateCompleted: "2019-12-01T01:24:05"));
    goals.add(new Goal(name: "poem index load", text: "tire clerk teen heel", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-28T10:05:25", dateAssigned: "2019-11-26T07:12:27", dateCompleted: "2019-11-29T07:28:51"));
    goals.add(new Goal(name: "menu bench bell", text: "acid fiber rice lung", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-27T22:22:56", dateAssigned: "2019-11-26T02:08:42", dateCompleted: "2019-11-29T02:34:38"));
    goals.add(new Goal(name: "lung porch bell", text: "date solar like shit", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-05T22:04:22", dateAssigned: "2019-12-02T00:37:33", dateCompleted: "2019-12-02T00:37:33"));
    goals.add(new Goal(name: "bury elite oven", text: "buck false peer wind", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-12-01T23:23:06", dateAssigned: "2019-11-30T07:25:05", dateCompleted: "2019-12-02T15:46:02"));
    goals.add(new Goal(name: "line honor dare", text: "tire lobby shit beat", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T11:56:07", dateAssigned: "2019-11-28T20:32:08", dateCompleted: "2019-11-28T23:18:48"));
    goals.add(new Goal(name: "palm doubt rail", text: "buck alien auto dear", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T11:19:04", dateAssigned: "2019-11-27T05:21:29", dateCompleted: "2019-11-27T08:08:09"));
    goals.add(new Goal(name: "rope strip myth", text: "flow value sink mail", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T03:37:12", dateAssigned: "2019-11-27T23:15:24", dateCompleted: "2019-11-28T02:02:04"));
    goals.add(new Goal(name: "pile bench roll", text: "cake blend wise coal", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T20:33:42", dateAssigned: "2019-11-28T16:12:35", dateCompleted: "2019-12-01T03:06:41"));
    goals.add(new Goal(name: "clue exact suit", text: "dare sweat auto cope", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-12-01T03:16:28", dateAssigned: "2019-11-29T05:40:10", dateCompleted: "2019-11-29T08:26:50"));
    goals.add(new Goal(name: "cope match date", text: "mere rider spin bite", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T01:19:53", dateAssigned: "2019-11-28T03:51:27", dateCompleted: "2019-11-30T21:01:36"));
    goals.add(new Goal(name: "pile blend buck", text: "aide jeans sake rope", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-12-01T00:09:37", dateAssigned: "2019-11-29T10:03:22", dateCompleted: "2019-12-01T23:11:05"));
    goals.add(new Goal(name: "pile badly spot", text: "rail laser soup pace", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-01T20:10:07", dateAssigned: "2019-11-30T13:30:50", dateCompleted: "2019-11-30T13:30:50"));
    goals.add(new Goal(name: "snap awful ally", text: "gear badly fate wave", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-28T12:51:58", dateAssigned: "2019-11-26T05:22:10", dateCompleted: "2019-11-29T10:27:45"));
    goals.add(new Goal(name: "host badly bear", text: "okay minor soup tail", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-03T21:41:07", dateAssigned: "2019-11-28T16:58:31", dateCompleted: "2019-11-28T16:58:31"));
    goals.add(new Goal(name: "bell flour tent", text: "wind chaos mess dare", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-28T05:05:43", dateAssigned: "2019-11-26T06:52:48", dateCompleted: "2019-11-26T09:39:28"));
    goals.add(new Goal(name: "tail steep loud", text: "bake bench bind corn", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-28T21:45:13", dateAssigned: "2019-11-26T17:39:55", dateCompleted: "2019-11-29T19:51:20"));
    goals.add(new Goal(name: "myth brush shit", text: "cope exact pack beat", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T03:42:21", dateAssigned: "2019-11-30T16:39:49", dateCompleted: "2019-11-30T16:39:49"));
    goals.add(new Goal(name: "roll rumor peer", text: "rose arise palm odds", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-30T08:33:13", dateAssigned: "2019-11-28T09:38:22", dateCompleted: "2019-11-28T12:25:02"));
    goals.add(new Goal(name: "peer shrug fund", text: "mess cabin wise roll", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T04:22:42", dateAssigned: "2019-11-28T07:22:08", dateCompleted: "2019-11-30T22:33:01"));
    goals.add(new Goal(name: "flow burst loud", text: "cope smoke drop ugly", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T09:59:09", dateAssigned: "2019-11-30T08:20:16", dateCompleted: "2019-11-30T08:20:16"));
    goals.add(new Goal(name: "mere snake quit", text: "hold trait moon odds", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-01T23:19:31", dateAssigned: "2019-11-30T13:24:13", dateCompleted: "2019-11-30T13:24:13"));
    goals.add(new Goal(name: "beat yield tire", text: "rope since lawn flag", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T04:11:01", dateAssigned: "2019-11-29T06:07:46", dateCompleted: "2019-11-29T06:07:46"));
    goals.add(new Goal(name: "yell fiber bell", text: "poem reach pant myth", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-12-01T16:16:15", dateAssigned: "2019-11-29T17:25:12", dateCompleted: "2019-12-02T07:24:25"));
    goals.add(new Goal(name: "yell daily sigh", text: "load candy bite bury", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-12-01T07:42:23", dateAssigned: "2019-11-29T11:24:58", dateCompleted: "2019-11-29T14:11:38"));
    goals.add(new Goal(name: "odds sweep sink", text: "flag trunk okay bell", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T11:10:22", dateAssigned: "2019-11-28T06:54:06", dateCompleted: "2019-11-28T09:40:46"));
    goals.add(new Goal(name: "gang stake deck", text: "coal towel buck dirt", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-04T03:16:36", dateAssigned: "2019-11-30T16:00:00", dateCompleted: "2019-11-30T16:00:00"));
    goals.add(new Goal(name: "heel award wave", text: "gear shell soup okay", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-27T10:18:35", dateAssigned: "2019-11-26T01:39:52", dateCompleted: "2019-11-26T04:26:32"));
    goals.add(new Goal(name: "easy outer cope", text: "pant float crop hold", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-29T17:05:12", dateAssigned: "2019-11-27T19:18:44", dateCompleted: "2019-11-30T16:54:16"));
    goals.add(new Goal(name: "drop brand line", text: "lung scope free sigh", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T18:43:40", dateAssigned: "2019-11-28T04:51:22", dateCompleted: "2019-11-30T17:43:30"));
    goals.add(new Goal(name: "ugly slave pole", text: "peer couch wind port", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-28T12:46:23", dateAssigned: "2019-11-27T05:11:24", dateCompleted: "2019-11-29T12:12:39"));
    goals.add(new Goal(name: "chef piano pure", text: "mine hence pink mask", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-28T19:27:40", dateAssigned: "2019-11-27T09:13:38", dateCompleted: "2019-11-30T06:05:30"));
    goals.add(new Goal(name: "boom pizza poet", text: "menu imply flee snap", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T08:54:48", dateAssigned: "2019-11-28T10:04:24", dateCompleted: "2019-11-28T12:51:04"));
    goals.add(new Goal(name: "mess trait wage", text: "myth hence high deer", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-04T02:05:51", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "flag unity soon", text: "dare label load rice", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-12-01T02:16:54", dateAssigned: "2019-11-28T21:00:51", dateCompleted: "2019-11-28T23:47:31"));
    goals.add(new Goal(name: "beat ahead suit", text: "line fifty tent pile", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-29T21:59:07", dateAssigned: "2019-11-28T12:38:39", dateCompleted: "2019-11-30T19:21:13"));
    goals.add(new Goal(name: "bury realm menu", text: "mask favor flow mine", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-28T21:10:23", dateAssigned: "2019-11-27T10:51:39", dateCompleted: "2019-11-27T13:38:19"));
    goals.add(new Goal(name: "tail favor bake", text: "acid brush soon wind", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-02T01:50:07", dateAssigned: "2019-11-30T01:08:19", dateCompleted: "2019-11-30T01:08:19"));
    goals.add(new Goal(name: "math porch mail", text: "buck trail soon pace", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T01:33:33", dateAssigned: "2019-11-28T00:45:16", dateCompleted: "2019-11-28T03:31:56"));
    goals.add(new Goal(name: "pray worth host", text: "palm wrist peer cake", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-04T12:59:26", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "mine opera acid", text: "bear store dirt auto", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-29T09:55:07", dateAssigned: "2019-11-27T13:56:29", dateCompleted: "2019-11-27T16:43:09"));
    goals.add(new Goal(name: "fast worth rank", text: "ease delay shit gear", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-28T15:16:54", dateAssigned: "2019-11-27T03:49:36", dateCompleted: "2019-11-27T06:36:16"));
    goals.add(new Goal(name: "flee brush wave", text: "rice Islam clue belt", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-29T14:38:47", dateAssigned: "2019-11-27T08:29:01", dateCompleted: "2019-11-30T15:41:03"));
    goals.add(new Goal(name: "port array wise", text: "belt mouse odds soup", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T10:20:58", dateAssigned: "2019-11-29T02:16:54", dateCompleted: "2019-11-29T05:03:34"));
    goals.add(new Goal(name: "mere harsh rail", text: "coal medal bear fast", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-27T22:57:49", dateAssigned: "2019-11-25T23:24:35", dateCompleted: "2019-11-26T02:11:15"));
    goals.add(new Goal(name: "loud trait deer", text: "menu pride sigh palm", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T17:27:25", dateAssigned: "2019-11-29T07:22:45", dateCompleted: "2019-11-29T10:09:25"));
    goals.add(new Goal(name: "wave bunch pant", text: "snap doubt quit wind", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-27T20:03:55", dateAssigned: "2019-11-25T16:40:59", dateCompleted: "2019-11-29T05:41:44"));
    goals.add(new Goal(name: "pole hurry fund", text: "flow rifle ugly lung", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-30T10:13:59", dateAssigned: "2019-11-29T02:33:52", dateCompleted: "2019-12-01T15:08:31"));
    goals.add(new Goal(name: "bite relax crop", text: "snap drift wipe pine", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-28T21:25:18", dateAssigned: "2019-11-26T17:48:35", dateCompleted: "2019-11-30T07:04:19"));
    goals.add(new Goal(name: "auto rifle ease", text: "poem fraud fate roll", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-28T19:40:12", dateAssigned: "2019-11-26T21:19:44", dateCompleted: "2019-11-27T00:06:24"));
    goals.add(new Goal(name: "peer hence rice", text: "flat click pole deck", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-27T11:54:39", dateAssigned: "2019-11-25T20:53:32", dateCompleted: "2019-11-25T23:40:12"));
    goals.add(new Goal(name: "pray swear dirt", text: "math wound firm crop", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-29T16:44:48", dateAssigned: "2019-11-27T11:20:17", dateCompleted: "2019-11-30T16:44:04"));
    goals.add(new Goal(name: "rose draft wipe", text: "load candy peer auto", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-04T10:54:06", dateAssigned: "2019-11-30T00:23:33", dateCompleted: "2019-11-30T00:23:33"));
    goals.add(new Goal(name: "coal trunk bite", text: "tube piano ally bake", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-30T06:31:25", dateAssigned: "2019-11-28T15:51:11", dateCompleted: "2019-11-30T23:37:22"));
    goals.add(new Goal(name: "rose fluid bury", text: "pray flour bite ally", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-28T05:54:25", dateAssigned: "2019-11-26T17:57:09", dateCompleted: "2019-11-26T20:43:49"));
    goals.add(new Goal(name: "mask boost lost", text: "bind ratio clue lung", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-12-01T03:19:05", dateAssigned: "2019-11-29T00:00:23", dateCompleted: "2019-12-01T19:35:28"));
    goals.add(new Goal(name: "soup trait rank", text: "pure scary line host", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T11:24:16", dateAssigned: "2019-11-28T11:25:01", dateCompleted: "2019-12-01T17:48:49"));
    goals.add(new Goal(name: "ease meter dirt", text: "swim plead moon pink", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-28T23:49:07", dateAssigned: "2019-11-27T00:44:25", dateCompleted: "2019-11-27T03:31:05"));
    goals.add(new Goal(name: "mode match acid", text: "hold bunch wind port", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T04:32:59", dateAssigned: "2019-11-29T08:15:14", dateCompleted: "2019-11-29T08:15:14"));
    goals.add(new Goal(name: "pure shell menu", text: "okay giant ease roll", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T06:46:10", dateAssigned: "2019-12-02T14:53:39", dateCompleted: "2019-12-02T14:53:39"));
    goals.add(new Goal(name: "pack slide okay", text: "date sweep line myth", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-29T19:21:45", dateAssigned: "2019-11-28T14:06:14", dateCompleted: "2019-11-28T16:52:54"));
    goals.add(new Goal(name: "ease magic pace", text: "rank prior poem gang", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-05T02:59:58", dateAssigned: "2019-12-02T17:06:22", dateCompleted: "2019-12-02T17:06:22"));
    goals.add(new Goal(name: "boom wound poem", text: "tube trunk cope host", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-27T16:22:04", dateAssigned: "2019-11-26T06:22:10", dateCompleted: "2019-11-29T03:52:38"));
    goals.add(new Goal(name: "dare smell lung", text: "crop prior load cope", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T17:24:28", dateAssigned: "2019-11-29T06:57:47", dateCompleted: "2019-11-29T09:44:27"));
    goals.add(new Goal(name: "corn badly free", text: "ease hurry pure pale", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T06:23:05", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "heel daily chef", text: "date doubt lung free", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-27T23:31:47", dateAssigned: "2019-11-25T20:00:36", dateCompleted: "2019-11-29T09:22:16"));
    goals.add(new Goal(name: "risk slice hold", text: "oven virus clue poet", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-02T09:01:31", dateAssigned: "2019-11-29T14:52:52", dateCompleted: "2019-11-29T14:52:52"));
    goals.add(new Goal(name: "tent count mess", text: "wise spill pack corn", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-30T12:50:39", dateAssigned: "2019-11-28T08:55:21", dateCompleted: "2019-11-28T11:42:01"));
    goals.add(new Goal(name: "mode alter fast", text: "lost stair bite line", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T23:22:41", dateAssigned: "2019-11-28T07:50:59", dateCompleted: "2019-11-28T10:37:39"));
    goals.add(new Goal(name: "host ankle yell", text: "rank slave dare ally", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-04T15:36:09", dateAssigned: "2019-12-01T08:18:37", dateCompleted: "2019-12-01T08:18:37"));
    goals.add(new Goal(name: "myth react lawn", text: "roll honey deck dirt", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-27T23:10:12", dateAssigned: "2019-11-26T12:17:10", dateCompleted: "2019-11-29T02:08:22"));
    goals.add(new Goal(name: "ease split pray", text: "pale dream pale pure", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T04:55:45", dateAssigned: "2019-11-27T16:34:36", dateCompleted: "2019-11-30T10:49:32"));
    goals.add(new Goal(name: "okay split pure", text: "okay super menu gang", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T15:48:17", dateAssigned: "2019-11-29T15:50:33", dateCompleted: "2019-11-29T15:50:33"));
    goals.add(new Goal(name: "flat house wind", text: "pale grain bind mess", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-30T11:18:51", dateAssigned: "2019-11-28T08:39:28", dateCompleted: "2019-12-01T16:24:36"));
    goals.add(new Goal(name: "aide craft myth", text: "clue ankle mere high", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T10:50:58", dateAssigned: "2019-11-29T00:16:54", dateCompleted: "2019-11-29T03:03:34"));
    goals.add(new Goal(name: "drop pitch lost", text: "deck daily risk rope", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-28T04:48:26", dateAssigned: "2019-11-26T13:11:29", dateCompleted: "2019-11-29T04:45:06"));
    goals.add(new Goal(name: "plot swing mess", text: "pace bunch fate quit", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-06T05:29:42", dateAssigned: "2019-12-01T04:20:13", dateCompleted: "2019-12-01T04:20:13"));
    goals.add(new Goal(name: "heel arena tube", text: "flag tribe boom poet", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-12-01T13:03:44", dateAssigned: "2019-11-30T07:21:23", dateCompleted: "2019-11-30T10:08:03"));
    goals.add(new Goal(name: "spot magic rose", text: "spin civic mere mall", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-27T04:57:21", dateAssigned: "2019-11-24T22:22:03", dateCompleted: "2019-11-25T01:08:43"));
    goals.add(new Goal(name: "risk rapid myth", text: "shit cabin cool rate", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-29T10:48:46", dateAssigned: "2019-11-27T16:20:58", dateCompleted: "2019-11-30T03:10:45"));
    goals.add(new Goal(name: "pale greet lung", text: "port loose tail wipe", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T06:32:37", dateAssigned: "2019-11-28T02:11:37", dateCompleted: "2019-12-01T15:10:26"));
    goals.add(new Goal(name: "menu imply bell", text: "cake shrug bite bear", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-28T22:00:49", dateAssigned: "2019-11-27T03:35:40", dateCompleted: "2019-11-30T07:22:04"));
    goals.add(new Goal(name: "sake guard flag", text: "heel smell mine wage", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-27T22:27:13", dateAssigned: "2019-11-25T17:57:17", dateCompleted: "2019-11-25T20:43:57"));
    goals.add(new Goal(name: "peer pause cake", text: "corn delay bite acid", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-30T10:01:47", dateAssigned: "2019-11-28T13:33:56", dateCompleted: "2019-12-01T11:51:39"));
    goals.add(new Goal(name: "tail angel tire", text: "firm Irish menu easy", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T08:54:01", dateAssigned: "2019-11-28T03:59:41", dateCompleted: "2019-11-30T12:48:40"));
    goals.add(new Goal(name: "easy honey yell", text: "load swing cake rank", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-28T03:18:47", dateAssigned: "2019-11-25T21:16:24", dateCompleted: "2019-11-29T05:45:40"));
    goals.add(new Goal(name: "rice shelf coal", text: "bear grant myth beat", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T05:06:50", dateAssigned: "2019-11-28T15:38:28", dateCompleted: "2019-11-30T22:55:05"));
    goals.add(new Goal(name: "ally lemon spot", text: "buck shame spot fate", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-28T02:52:42", dateAssigned: "2019-11-26T09:55:01", dateCompleted: "2019-11-29T13:28:20"));
    goals.add(new Goal(name: "crop flesh pant", text: "wise prize deck pine", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-12-01T10:23:29", dateAssigned: "2019-11-30T04:06:56", dateCompleted: "2019-11-30T06:53:36"));
    goals.add(new Goal(name: "deck medal jail", text: "sigh proof spin loud", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T06:25:56", dateAssigned: "2019-11-28T08:08:39", dateCompleted: "2019-12-01T14:28:44"));
    goals.add(new Goal(name: "lung grant firm", text: "corn grave beat wipe", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-12-01T03:26:48", dateAssigned: "2019-11-29T17:01:45", dateCompleted: "2019-12-02T06:26:30"));
    goals.add(new Goal(name: "mail fifty sink", text: "soup ghost cake rose", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-28T19:21:58", dateAssigned: "2019-11-26T23:29:20", dateCompleted: "2019-11-27T02:16:00"));
    goals.add(new Goal(name: "mess giant fate", text: "buck label fund rail", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T09:43:44", dateAssigned: "2019-11-28T17:18:38", dateCompleted: "2019-12-01T16:15:36"));
    goals.add(new Goal(name: "poem pause pole", text: "corn wrong wind tire", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T03:41:27", dateAssigned: "2019-11-30T01:44:40", dateCompleted: "2019-11-30T01:44:40"));
    goals.add(new Goal(name: "risk medal pant", text: "tent nerve yell gaze", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-05T07:25:16", dateAssigned: "2019-12-02T10:43:19", dateCompleted: "2019-12-02T10:43:19"));
    goals.add(new Goal(name: "flat found quit", text: "bind grain poet cope", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-29T02:50:36", dateAssigned: "2019-11-27T13:42:01", dateCompleted: "2019-11-29T21:21:49"));
    goals.add(new Goal(name: "aide print flow", text: "wipe mount corn acid", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-12-01T00:52:16", dateAssigned: "2019-11-29T01:55:52", dateCompleted: "2019-12-02T05:33:25"));
    goals.add(new Goal(name: "rate wrist belt", text: "pace flesh crop spin", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-30T06:27:38", dateAssigned: "2019-11-29T01:58:43", dateCompleted: "2019-12-01T06:37:42"));
    goals.add(new Goal(name: "soup blind moon", text: "deer yield flat host", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T20:58:48", dateAssigned: "2019-11-28T17:35:34", dateCompleted: "2019-11-28T20:22:14"));
    goals.add(new Goal(name: "dirt waste teen", text: "gaze harsh cake pack", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-28T23:29:21", dateAssigned: "2019-11-26T20:11:59", dateCompleted: "2019-11-26T22:58:39"));
    goals.add(new Goal(name: "bury yield ugly", text: "soup newly pink load", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T17:21:52", dateAssigned: "2019-11-28T13:22:30", dateCompleted: "2019-12-01T14:37:37"));
    goals.add(new Goal(name: "crop magic wave", text: "hold carve shit sake", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-28T17:41:23", dateAssigned: "2019-11-26T15:33:20", dateCompleted: "2019-11-26T18:20:00"));
    goals.add(new Goal(name: "bite Irish risk", text: "port waste tent wipe", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-28T21:40:49", dateAssigned: "2019-11-26T23:17:25", dateCompleted: "2019-11-30T07:12:04"));
    goals.add(new Goal(name: "sake unity buck", text: "okay found soup teen", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-05T08:12:12", dateAssigned: "2019-11-30T23:31:22", dateCompleted: "2019-11-30T23:31:22"));
    goals.add(new Goal(name: "dare guilt cake", text: "bury couch date poet", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T12:08:36", dateAssigned: "2019-11-28T19:09:56", dateCompleted: "2019-12-01T02:25:58"));
    goals.add(new Goal(name: "easy await lung", text: "clue grave okay bury", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-28T01:11:38", dateAssigned: "2019-11-25T18:43:40", dateCompleted: "2019-11-29T10:25:53"));
    goals.add(new Goal(name: "rice split clue", text: "gaze trace peer fund", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T16:26:55", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "poet seize like", text: "spot realm aide menu", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-03T19:12:47", dateAssigned: "2019-11-30T20:09:52", dateCompleted: "2019-11-30T20:09:52"));
    goals.add(new Goal(name: "high float palm", text: "pace sweat wise sink", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-04T02:18:39", dateAssigned: "2019-11-30T11:19:25", dateCompleted: "2019-11-30T11:19:25"));
    goals.add(new Goal(name: "mode sweat deck", text: "dear eager risk host", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T11:38:14", dateAssigned: "2019-11-28T19:01:17", dateCompleted: "2019-11-28T21:47:57"));
    goals.add(new Goal(name: "peer smell pant", text: "flee boost poem mask", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-28T17:39:06", dateAssigned: "2019-11-26T14:11:43", dateCompleted: "2019-11-26T16:58:23"));
    goals.add(new Goal(name: "aide delay pack", text: "mall slave snap fast", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-03T16:24:37", dateAssigned: "2019-11-30T08:08:27", dateCompleted: "2019-11-30T08:08:27"));
    goals.add(new Goal(name: "fund clerk suit", text: "pole cloth bake mall", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-30T07:19:02", dateAssigned: "2019-11-28T11:28:23", dateCompleted: "2019-11-28T14:15:03"));
    goals.add(new Goal(name: "wave white palm", text: "mask blade fund cake", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T00:15:53", dateAssigned: "2019-11-30T09:26:27", dateCompleted: "2019-11-30T09:26:27"));
    goals.add(new Goal(name: "ugly shade rank", text: "poet stair soup auto", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T03:05:48", dateAssigned: "2019-11-27T09:36:33", dateCompleted: "2019-11-30T09:54:34"));
    goals.add(new Goal(name: "fast pitch pant", text: "rose smoke cake cope", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T07:00:19", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "sink trunk palm", text: "flag mouse rope soon", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T07:43:31", dateAssigned: "2019-11-27T04:16:35", dateCompleted: "2019-11-27T07:03:15"));
    goals.add(new Goal(name: "dear angle wipe", text: "mess scope line wipe", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T14:39:04", dateAssigned: "2019-11-29T02:48:32", dateCompleted: "2019-12-01T12:56:48"));
    goals.add(new Goal(name: "port elbow spot", text: "mode slope crop flag", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T07:26:55", dateAssigned: "2019-11-27T21:02:12", dateCompleted: "2019-11-27T23:48:52"));
    goals.add(new Goal(name: "sake spill dirt", text: "date brush port poet", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-12-01T00:53:06", dateAssigned: "2019-11-29T01:16:04", dateCompleted: "2019-12-01T22:05:06"));
    goals.add(new Goal(name: "pace pause yell", text: "boom pride mode bear", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-28T14:57:02", dateAssigned: "2019-11-26T18:45:16", dateCompleted: "2019-11-29T08:57:25"));
    goals.add(new Goal(name: "poet clerk boom", text: "pack opera pale deer", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-29T20:07:01", dateAssigned: "2019-11-28T08:00:26", dateCompleted: "2019-11-30T18:25:10"));
    goals.add(new Goal(name: "free lemon myth", text: "dare grain lung myth", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-28T21:40:05", dateAssigned: "2019-11-26T23:30:28", dateCompleted: "2019-11-29T13:24:36"));
    goals.add(new Goal(name: "bind grain myth", text: "bury trail load coal", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T17:24:06", dateAssigned: "2019-11-28T04:47:59", dateCompleted: "2019-11-30T17:03:43"));
    goals.add(new Goal(name: "mail yield pile", text: "okay lobby pole easy", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-12-01T06:00:35", dateAssigned: "2019-11-29T22:59:29", dateCompleted: "2019-11-30T01:46:09"));
    goals.add(new Goal(name: "beat clerk spin", text: "pant forty pray load", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-27T12:10:53", dateAssigned: "2019-11-25T04:37:43", dateCompleted: "2019-11-28T21:19:57"));
    goals.add(new Goal(name: "pole laugh flow", text: "wipe steep bear heel", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T06:55:12", dateAssigned: "2019-11-28T15:37:20", dateCompleted: "2019-12-01T12:35:58"));
    goals.add(new Goal(name: "wipe weird pray", text: "peer craft mall mine", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T07:58:21", dateAssigned: "2019-11-30T18:58:45", dateCompleted: "2019-11-30T18:58:45"));
    goals.add(new Goal(name: "jail speed soon", text: "aide rider pure boom", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T00:05:48", dateAssigned: "2019-11-26T22:06:48", dateCompleted: "2019-11-27T00:53:28"));
    goals.add(new Goal(name: "rice angel jail", text: "cake prize dear tube", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T02:33:52", dateAssigned: "2019-11-27T04:36:29", dateCompleted: "2019-11-27T07:23:09"));
    goals.add(new Goal(name: "mask store flow", text: "pole shame fast palm", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T02:25:37", dateAssigned: "2019-11-28T17:20:40", dateCompleted: "2019-11-28T20:07:20"));
    goals.add(new Goal(name: "tent exact rice", text: "soup shine sigh flee", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-12-01T09:41:17", dateAssigned: "2019-11-29T18:22:28", dateCompleted: "2019-11-29T21:09:08"));
    goals.add(new Goal(name: "pine index myth", text: "deer grave plot rank", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T22:49:17", dateAssigned: "2019-11-29T18:14:33", dateCompleted: "2019-11-29T21:01:13"));
    goals.add(new Goal(name: "beat slice dare", text: "bind scare bury deck", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-04T15:09:54", dateAssigned: "2019-12-03T06:33:52", dateCompleted: "2019-12-03T06:33:52"));
    goals.add(new Goal(name: "clue snake peer", text: "chef shell wave pipe", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-12-01T04:56:57", dateAssigned: "2019-11-29T12:34:02", dateCompleted: "2019-12-02T02:37:18"));
    goals.add(new Goal(name: "host award mall", text: "dirt scare belt ally", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-30T09:27:17", dateAssigned: "2019-11-28T12:20:43", dateCompleted: "2019-11-28T15:07:23"));
    goals.add(new Goal(name: "plot tight line", text: "rice slave sink tube", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T20:11:40", dateAssigned: "2019-11-29T15:34:10", dateCompleted: "2019-11-29T18:20:50"));
    goals.add(new Goal(name: "ally stair cake", text: "date label lung pray", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T00:23:19", dateAssigned: "2019-11-26T17:32:23", dateCompleted: "2019-11-26T20:19:03"));
    goals.add(new Goal(name: "wave strip mine", text: "flat drift mall lawn", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T12:46:07", dateAssigned: "2019-11-29T02:48:37", dateCompleted: "2019-12-01T02:44:43"));
    goals.add(new Goal(name: "myth cheek port", text: "buck strip drop clue", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T01:48:46", dateAssigned: "2019-11-27T15:53:14", dateCompleted: "2019-11-30T09:16:03"));
    goals.add(new Goal(name: "soup couch dare", text: "crop trait coal rope", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T12:42:02", dateAssigned: "2019-11-27T07:48:43", dateCompleted: "2019-11-27T10:35:23"));
    goals.add(new Goal(name: "rope flour oven", text: "chef cabin free beat", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-29T06:10:13", dateAssigned: "2019-11-27T11:11:45", dateCompleted: "2019-11-27T13:58:25"));
    goals.add(new Goal(name: "beat nerve line", text: "clue eager coal easy", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-29T02:07:58", dateAssigned: "2019-11-26T22:55:44", dateCompleted: "2019-11-27T01:42:24"));
    goals.add(new Goal(name: "tail giant heel", text: "free clerk yell swim", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-05T10:29:13", dateAssigned: "2019-12-02T18:14:07", dateCompleted: "2019-12-02T18:14:07"));
    goals.add(new Goal(name: "drop pride chef", text: "pine clock risk bury", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T10:37:48", dateAssigned: "2019-12-01T11:37:47", dateCompleted: "2019-12-01T11:37:47"));
    goals.add(new Goal(name: "lost grant swim", text: "poem brush tent pace", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-12-01T04:15:48", dateAssigned: "2019-11-29T14:35:04", dateCompleted: "2019-12-01T18:16:52"));
    goals.add(new Goal(name: "aide grant gang", text: "pine depth line rank", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-04T09:50:53", dateAssigned: "2019-11-30T06:18:12", dateCompleted: "2019-11-30T06:18:12"));
    goals.add(new Goal(name: "mere stuff mail", text: "tent grant bite spot", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T08:04:15", dateAssigned: "2019-11-27T13:39:58", dateCompleted: "2019-11-30T12:23:47"));
    goals.add(new Goal(name: "clue bunch jail", text: "fate opera beat free", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T06:49:04", dateAssigned: "2019-11-27T02:50:26", dateCompleted: "2019-11-29T22:40:06"));
    goals.add(new Goal(name: "flat thumb bake", text: "heel worth load pant", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T08:15:55", dateAssigned: "2019-11-27T23:22:51", dateCompleted: "2019-11-30T12:29:37"));
    goals.add(new Goal(name: "flag clerk rail", text: "pace honey hold aide", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-28T05:05:11", dateAssigned: "2019-11-26T07:53:58", dateCompleted: "2019-11-26T10:40:38"));
    goals.add(new Goal(name: "oven logic hold", text: "pack stuff drop easy", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-02T22:32:36", dateAssigned: "2019-11-29T12:20:15", dateCompleted: "2019-11-29T12:20:15"));
    goals.add(new Goal(name: "wise giant okay", text: "belt stair gear cool", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-05T22:37:05", dateAssigned: "2019-12-03T02:35:40", dateCompleted: "2019-12-03T02:35:40"));
    goals.add(new Goal(name: "pale uncle mall", text: "high seize acid gear", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T19:53:00", dateAssigned: "2019-11-28T15:55:49", dateCompleted: "2019-11-28T18:42:29"));
    goals.add(new Goal(name: "rose sweat chef", text: "loud sixth gaze pine", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T05:53:59", dateAssigned: "2019-11-29T11:57:23", dateCompleted: "2019-11-29T11:57:23"));
    goals.add(new Goal(name: "ugly daily pink", text: "gaze apple ally auto", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-29T16:15:10", dateAssigned: "2019-11-27T22:58:02", dateCompleted: "2019-11-28T01:44:42"));
    goals.add(new Goal(name: "pole yield acid", text: "aide steep menu auto", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-02T14:53:05", dateAssigned: "2019-11-30T23:11:45", dateCompleted: "2019-11-30T23:11:45"));
    goals.add(new Goal(name: "host favor mere", text: "poet thumb okay crop", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T01:56:14", dateAssigned: "2019-11-28T05:20:37", dateCompleted: "2019-11-30T21:19:47"));
    goals.add(new Goal(name: "peer medal swim", text: "math skirt peer pure", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-28T14:25:44", dateAssigned: "2019-11-27T09:00:28", dateCompleted: "2019-11-27T11:47:08"));
    goals.add(new Goal(name: "deer count mask", text: "mere belly cool soup", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T23:55:49", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "acid fence pole", text: "sake rider heel host", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-05T00:24:05", dateAssigned: "2019-11-30T16:48:29", dateCompleted: "2019-11-30T16:48:29"));
    goals.add(new Goal(name: "auto react firm", text: "spot brush flee fade", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-30T05:25:13", dateAssigned: "2019-11-28T15:31:33", dateCompleted: "2019-11-30T23:04:16"));
    goals.add(new Goal(name: "swim flame tent", text: "coal print boom buck", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T16:53:27", dateAssigned: "2019-11-27T14:55:50", dateCompleted: "2019-11-30T09:31:32"));
    goals.add(new Goal(name: "pile plead peer", text: "bind blend mess sake", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-04T03:25:40", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "high craft cool", text: "cake essay deer yell", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-12-01T23:10:16", dateAssigned: "2019-11-30T07:52:15", dateCompleted: "2019-11-30T10:38:55"));
    goals.add(new Goal(name: "firm click fade", text: "spot label oven coal", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-02T03:07:46", dateAssigned: "2019-11-28T13:56:39", dateCompleted: "2019-11-28T13:56:39"));
    goals.add(new Goal(name: "lawn piano peer", text: "peer prior dare bury", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-04T07:35:26", dateAssigned: "2019-12-02T08:45:38", dateCompleted: "2019-12-02T08:45:38"));
    goals.add(new Goal(name: "swim array rank", text: "tube yours fund fate", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-05T17:52:56", dateAssigned: "2019-12-03T03:16:25", dateCompleted: "2019-12-03T03:16:25"));
    goals.add(new Goal(name: "flag porch rank", text: "pack fault oven pure", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-27T22:51:17", dateAssigned: "2019-11-25T22:39:20", dateCompleted: "2019-11-29T05:56:37"));
    goals.add(new Goal(name: "firm rumor lung", text: "pink unity rope hold", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-11-30T23:00:55", dateAssigned: "2019-11-29T12:46:07", dateCompleted: "2019-12-01T19:23:28"));
    goals.add(new Goal(name: "heel favor soon", text: "pile solar spin sink", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-03T13:11:13", dateAssigned: "2019-11-29T09:44:00", dateCompleted: "2019-11-29T09:44:00"));
    goals.add(new Goal(name: "mine rough rail", text: "lost worry odds dear", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T02:01:41", dateAssigned: "2019-11-27T09:56:38", dateCompleted: "2019-11-27T12:43:18"));
    goals.add(new Goal(name: "cope shame mere", text: "date ahead mess ally", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-02T14:29:30", dateAssigned: "2019-11-30T14:26:15", dateCompleted: "2019-11-30T14:26:15"));
    goals.add(new Goal(name: "tent bench spin", text: "tail scope rice date", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-30T21:33:22", dateAssigned: "2019-11-28T16:28:26", dateCompleted: "2019-11-28T19:15:06"));
    goals.add(new Goal(name: "peer array dirt", text: "pale newly ally snap", status: S_COMPLETED, courseID: "46758684876", dueDate: "2019-11-29T16:41:01", dateAssigned: "2019-11-28T07:28:30", dateCompleted: "2019-11-28T10:15:10"));
    goals.add(new Goal(name: "mall track acid", text: "acid grace ally soon", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-04T00:08:03", dateAssigned: "2019-11-29T13:02:17", dateCompleted: "2019-11-29T13:02:17"));
    goals.add(new Goal(name: "coal fraud poet", text: "host drama mere jail", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-06T00:14:49", dateAssigned: "2019-12-03T06:54:47", dateCompleted: "2019-12-03T06:54:47"));
    goals.add(new Goal(name: "lung rapid peer", text: "soup wrist soup ally", status: S_COMPLETED_LATE, courseID: "47736319395", dueDate: "2019-11-29T20:24:58", dateAssigned: "2019-11-28T05:01:43", dateCompleted: "2019-11-30T18:34:09"));
    goals.add(new Goal(name: "plot label gang", text: "ally trail boom lost", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T06:19:24", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "auto drama firm", text: "lawn float dare pine", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-04T22:24:01", dateAssigned: "2019-11-30T15:56:10", dateCompleted: "2019-11-30T15:56:10"));
    goals.add(new Goal(name: "tube drunk mail", text: "rank tight drop wise", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-03T13:14:00", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "plot brush port", text: "tire weird tube rice", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-11-30T14:04:42", dateAssigned: "2019-11-28T21:36:58", dateCompleted: "2019-11-29T00:23:38"));
    goals.add(new Goal(name: "shit minor flag", text: "buck laugh crop rail", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-04T04:46:29", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "swim tribe roll", text: "spot angle heel dear", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T06:02:09", dateAssigned: "2019-11-28T06:59:58", dateCompleted: "2019-11-28T09:46:38"));
    goals.add(new Goal(name: "boom wrist bake", text: "host cross wave tent", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-29T11:36:42", dateAssigned: "2019-11-27T08:59:51", dateCompleted: "2019-11-27T11:46:31"));
    goals.add(new Goal(name: "flow print flee", text: "gang wrong rate bake", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-28T18:56:16", dateAssigned: "2019-11-27T08:42:43", dateCompleted: "2019-11-30T05:49:48"));
    goals.add(new Goal(name: "free skirt cool", text: "bake wrist pure soup", status: S_IN_PROGRESS, courseID: "47736319395", dueDate: "2019-12-03T07:23:19", dateAssigned: "2019-12-01T01:36:34", dateCompleted: "2019-12-01T01:36:34"));
    goals.add(new Goal(name: "cake tribe wind", text: "lost yield risk mode", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-03T08:26:36", dateAssigned: "2019-12-01T16:43:20", dateCompleted: "2019-12-01T16:43:20"));
    goals.add(new Goal(name: "ugly belly mess", text: "spin print port teen", status: S_IN_PROGRESS, courseID: "47736319362", dueDate: "2019-12-03T01:07:28", dateAssigned: "2019-11-30T17:44:28", dateCompleted: "2019-11-30T17:44:28"));
    goals.add(new Goal(name: "lost blind bell", text: "load sweat risk menu", status: S_COMPLETED, courseID: "47736319395", dueDate: "2019-11-30T14:38:26", dateAssigned: "2019-11-28T17:40:20", dateCompleted: "2019-11-28T20:27:00"));
    goals.add(new Goal(name: "ugly crawl pant", text: "soup prize like bake", status: S_COMPLETED, courseID: "47736319362", dueDate: "2019-12-01T17:08:40", dateAssigned: "2019-11-29T12:52:31", dateCompleted: "2019-11-29T15:39:11"));
    goals.add(new Goal(name: "mere crawl wage", text: "dirt lemon auto risk", status: S_IN_PROGRESS, courseID: "46758684876", dueDate: "2019-12-01T22:28:23", dateAssigned: "2019-11-28T22:03:26", dateCompleted: "2019-11-28T22:03:26"));
    goals.add(new Goal(name: "pace split pink", text: "clue plead rail pine", status: S_COMPLETED_LATE, courseID: "47736319362", dueDate: "2019-11-29T17:50:17", dateAssigned: "2019-11-27T12:06:44", dateCompleted: "2019-12-01T04:28:32"));
    goals.add(new Goal(name: "acid brick easy", text: "tent plain sigh ease", status: S_COMPLETED_LATE, courseID: "46758684876", dueDate: "2019-12-01T00:24:11", dateAssigned: "2019-11-28T21:17:24", dateCompleted: "2019-12-01T18:41:37"));

    setUserCourseGoals(firebaseUser, goals, "CourseGoalObjects");

    List<String> courseIds = [];
    for (classroom.Course c in courses) {
      courseIds.add(c.id);
    }

    await doTransaction("Successfully updated user course work data.",
        "ERROR: Failed to update user course work data.", () {
          setAllUserCourseWorkData(firebaseUser, courseIds);
    });

    await doTransaction("Successfully updated user announcement data.",
        "ERROR: Failed to update user announcement data.", () {
          setAllUserAnnouncementData(firebaseUser, courseIds);
    });

    await doTransaction("Successfully updated user classmates data.",
        "ERROR: Failed to update user classmates data.", () {
          setAllUserClassStudents(firebaseUser, courseIds);
    });

    await doTransaction("Successfully updated user teachers data.",
        "ERROR: Failed to update user teachers data.", () {
          setAllUserClassTeachers(firebaseUser, courseIds);
    });

    await doTransaction("Successfully updated user course topics data.",
        "ERROR: Failed to update user course topics data.", () {
          setAllUserClassTopics(firebaseUser, courseIds);
    });

    loading.add(false);
    return firebaseUser;
  }

  Future<Map<String, String>> getAuthHeaders() {
    return _googleSignIn.currentUser.authHeaders;
  }

  void signOut() {
    _auth.signOut();
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}

final AuthService authService = AuthService();
FirebaseUser firebaseUser;

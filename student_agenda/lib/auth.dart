import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/appstate/v1.dart';
import 'package:rxdart/rxdart.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:http/http.dart'
    show BaseRequest, IOClient, Response, StreamedResponse;
import 'package:http/io_client.dart';
import 'package:student_agenda/ClassroomApiAccess.dart';
import 'package:student_agenda/util.dart';
import 'FirestoreManager.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = new GoogleSignIn(
                        scopes: [
                            'email',
                            classroom.ClassroomApi.ClassroomCoursesScope,
                        ],);
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
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      }
      return Observable.just({ });
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
          idToken: googleAuth.idToken
        )
    )).user;

    doTransaction("Successfully updated user data on sign in.",
                  "ERROR: Failed to update user data on sign in.",
                  (){setUserData(firebaseUser);});

    print("signed in " + firebaseUser.displayName);

    //update user classes on log in
    doTransaction("Successfully updated course information on sign in.",
                  "ERROR: Failed to update course information on sign in",
                  (){setUserClassroomData(firebaseUser);});

    doTransaction("Successfully updated user course work data.",
                  "ERROR: Failed to update user course work data.",
                  (){setUserCourseWorkData(firebaseUser);});

    doTransaction("Successfully updated user announcement data.",
                  "ERROR: Failed to update user announcement data.",
                  (){setUserAnnouncementData(firebaseUser);});

    doTransaction("Successfully updated user classmates data.",
                  "ERROR: Failed to update user classmates data.",
                  (){setUserClassStudents(firebaseUser);});

    doTransaction("Successfully updated user teachers data.",
                  "ERROR: Failed to update user teachers data.",
                  (){setUserClassTeachers(firebaseUser);});

    doTransaction("Successfully updated user course topics data.",
                  "ERROR: Failed to update user course topics data.",
                  (){setUserClassTopics(firebaseUser);});

    
    loading.add(false);
    return firebaseUser;
  }

  Future<Map<String, String>> getAuthHeaders(){
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
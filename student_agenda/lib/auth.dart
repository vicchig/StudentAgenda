import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/appstate/v1.dart';
import 'package:rxdart/rxdart.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:http/http.dart'
    show BaseRequest, IOClient, Response, StreamedResponse;
import 'package:http/io_client.dart';
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
    FirebaseUser user = (await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        )
    )).user;

    doTransaction("Successfully updated user data on sign in.",
                  "ERROR: Failed to update user data on sign in.",
                  (){updateUserData(user);});

   /* Firestore.instance.runTransaction((Transaction trans) async {
      updateUserData(user);
    }).then((val) => (){
      print("Successfully updated user data on sign in.");
    }).catchError((error) => (){
      print("ERROR: Failed to update user data on sign in.");
      print(error);
    });*/
    print("signed in " + user.displayName);
    
    loading.add(false);
    return user;
  }

  Future<Map<String, String>> getAuthHeaders(){
    return _googleSignIn.currentUser.authHeaders;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    await ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);

  }

  void updateUserClassroomData(FirebaseUser user) async{

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
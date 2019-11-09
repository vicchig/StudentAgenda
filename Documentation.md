# Student Agenda



## Dev Notes

### How to call a cloud function in Flutter

1. Import cloud function package

```Java
import 'package:cloud_functions/cloud_functions.dart';
```
2. Create a function callable

```Java
final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'helloWorld')
        ..timeout = const Duration(seconds: 30);
```
This will create an object that can be called later, the function name is the name of the function in firebase. Additionally make sure to add a timeout on the callable.

3. When needed (ex: `onPressed` call) call the the callable

```Java
onPressed: () async {
  try {
    final HttpsCallableResult result = await callable.call(); 
    print(result.data);
  } on CloudFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e.code);
    print(e.message);
    print(e.details);
  } catch (e) {
    print('caught generic exception');
    print(e);
  }
}
```
In this example the `onPressed` call will call an `async` function that, in a try/catch, will call the previously made callable and save the returned data in a `HttpsCallableResult` object. Getting the data from the `HttpsCallableResult` object depends on the returned data but a simple `result.data` will work for most cases



### FirestoreManager Documentation
API for working with data on the Cloud Firestore, particularly for linking data between the Google Classroom API and the Firestore.
#### Methods
__1.__ void doTransaction(String onSuccess, String onError, Function transaction) async
##### Summary:
Wrapper that performs a Firestore Transaction in a synchronized manner. Called during reads and writes to the Firestore to ensure atomicity of 
reads and writes.
##### Parameters
* __onSuccess__:   message displayed upon the operation's success
* __onError__:     message displayed if the operation does not succeed
* __transaction__: operation to be performed during a transcation. This should be a read or write operation to the Firestore. 


__2.__ void setUserData(FirebaseUser user) async
##### Summary:
Updates the per-user document in the 'users' collection with current user information, if the information exists. Otherwise,
creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.


__3.__ void setClassroomData(FirebaseUser user) async
##### Summary:
Updates the per-user document in the 'users' collection with current information about courses that they are subscribed to, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.


__4.__ void setUserCourseWorkData(FirebaseUser user) async
##### Summary:
Updates the per-user document in the 'users' collection with current information about course work that they are allowed to view from classes that they are subscribed to, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.


__5.__ void setUserAnnouncementData(FirebaseUser user) async
##### Summary:
Updates the per-user document in the 'users' collection with current information about course announcements that they are allowed to view from classes that they are subscribed to, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.


__5.__ void setUserClassStudents(FirebaseUser user) async
##### Summary:
Updates the per-user document in the 'users' collection with current information about students in the current user's subscribed classes, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.


__6.__ void setUserClassTeachers(FirebaseUser user) async
##### Summary:
Updates the per-user document in the 'users' collection with current information about teachers of the current user's subscribed classes, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.


__7.__ void setUserClassTopics(FirebaseUser user) async
##### Summary:
Updates the per-user document in the 'users' collection with current information about course topics from the current user's subscribed classes, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.


__8.__ Future<List<classroom.Course>> pullCourses(FirebaseUser user) async
##### Summary:
Pulls information about courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of List<classroom.Course> where the list value of the future contains the classroom.Course objects that define each of the user's courses. __The return of this function cannot be used directly and must be processed as in the example code.__
##### Example Usage in a Widget:
```Java
class DashboardScreenState extends State<DashboardScreen> {
  List<classroom.Course> _courses = new List<classroom.Course>();
  
  void processFuture() async {
    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);
    setState(()  {
      _courses = tempCourses;
    });
  }

  @override
  void initState() {
    super.initState();
    processFuture();
  }
}
```
##### Explanation
Because this method is asynchronous, it will return a Future<T> which must be processed by the user to extract the T object of the Future. The 'await' keyword allows to wait for a Future to complete its task. Once the task is completed, the returned object is extracted from the Future and can be used regularly. The reason for using setState() instead of a direct assignment to _courses is that without calling setState() there is no guarantee that the state variable _courses is updated at the appropriate time. __Not following this example may introduce race conditions into your code where the build() method of your widget is executed before the data is ready resulting in no guarantees on the completeness of data being returned.__


__9.__ Future<List<classroom.CourseWork>> pullCourseWorkData(FirebaseUser user) async
##### Summary:
Pulls information about course work objects for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of List<classroom.CourseWork> where the list value of the future contains the classroom.CourseWork objects that define each of the user's courses. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__10.__ Future<List<classroom.Announcement>> pullCourseAnnouncements(FirebaseUser user) async
##### Summary:
Pulls information about announcements that the user is allowed to see for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of List<classroom.Announcement> where the list value of the future contains the classroom.Announcement objects that define each of the user's courses. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__11.__ Future<List<classroom.Student>> pullClassmates(FirebaseUser user) async
##### Summary:
Pulls information about students for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of List<classroom.Student> where the list value of the future contains the classroom.Student objects that define each of the user's courses. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__12.__ Future<List<classroom.Teacher>> pullTeachers(FirebaseUser user) async
##### Summary:
Pulls information about teachers of the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of List<classroom.Teacher> where the list value of the future contains the classroom.Teacher objects that define each of the user's courses. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__13.__ Future<List<classroom.Topic>> pullTopics(FirebaseUser user) async
##### Summary:
Pulls information about course material topics for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __user__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of List<classroom.Topic> where the list value of the future contains the classroom.Topic objects that define each of the user's courses. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__

###FirestoreDataManager Documentation
API for processing data obtained from the Cloud Firestore. __This API deals a lot with data types defined in Google's Classroom API, it is suggested to review its documentation as needed to see what fields and methods the returned objects contain.__


#### Methods
__1.__ List<classroom.Student> getClassRoster(String courseID, List<classroom.Student> students)
##### Summary:
Find and return all students from students who are subscribed to the class with a courseId that matches courseID.
##### Exceptions and Preconditions:
Assumes that students is not null, throws __NullArgumentException__ otherwise.
##### Parameters:
* __courseID__:  course id of the course the students of which are being searched for.
* __students__:  student objects to search in
##### Return:
A List of all Student objects in students that had a courseId that matched courseID.


__2.__ List<classroom.Teacher> getCourseTeachers(String courseID, List<classroom.Teacher> teachers)
##### Summary:
Find and return all teachers in teachers who teach the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that teachers is not null, throws __NullArgumentException__ otherwise.
##### Parameters:
* __courseID__:  course id of the course the teachers of which are being searched for.
* __teachers__:  teacher objects to search in
##### Return:
A List of all Teacher objects in topics that had a courseId that matched courseID.


__3.__ List<classroom.Topic> getCourseTopics(String courseID, List<classroom.Topic> topics)
##### Summary:
Find and return all course topics in topics for the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that topics is not null, throws __NullArgumentException__ otherwise.
##### Parameters:
* __courseID__:  course id of the course the topics of which are being searched for.
* __topics__:    topic objects to search in
##### Return:
A List of all Topic objects in topics that had a courseId that matched courseID.


__4.__ List<classroom.Announcement> getCourseAnnouncements(String courseID, List<classroom.Announcement> announcements)
##### Summary:
Find and return all course announcements in announcements for the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that announcements is not null, throws __NullArgumentException__ otherwise.
##### Parameters:
* __courseID__:       course id of the course the topics of which are being searched for.
* __announcements__:  announcement objects to search in
##### Return:
A List of all Announcement objects in announcements that had a courseId that matched courseID.


__5.__ List<classroom.CourseWork> getCourseWorksForCourse(String courseID, List<classroom.CourseWork> works)
##### Summary:
Find and return all course works in works for the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that works is not null, throws __NullArgumentException__ otherwise.
##### Parameters:
* __courseID__:  course id of the course the topics of which are being searched for.
* __works__:     announcement objects to search in
##### Return:
A List of all CourseWork objects in works that had a courseId that matched courseID.





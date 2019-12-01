# Student Agenda Documentation

## Helpful Links

* [Markdown CheatSheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)  

## Links to Items within this Document
* [FirestoreManager Doc](#firestoremanager-documentation)
* [FirestoreDataManager Doc](#firestoredatamanager-documentation)

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



## FirestoreManager Documentation
API for working with data on the Cloud Firestore, particularly for linking data between the Google Classroom API and the Firestore.
#### Methods
__1.__ `void doTransaction(String onSuccess, String onError, Function transaction) async`
##### Summary:
Wrapper that performs a Firestore Transaction in a synchronized manner. Called during reads and writes to the Firestore to ensure atomicity of reads and writes.
##### Parameters
* __`onSuccess`__:   message displayed upon the operation's success
* __`onError`__:     message displayed if the operation does not succeed
* __`transaction`__: operation to be performed during a transcation. This should be a read or write operation to the Firestore. ...


__2.__ `void setUserData(FirebaseUser user, {toMerge: true}) async`
##### Summary:
Updates the per-user document in the 'users' collection with current user information, if the information exists. Otherwise,
creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __`user`__:     object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`toMerge`__:  __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__3.__ `void setClassroomData(FirebaseUser user, {toMerge: true}) async`
##### Summary:
Updates the per-user document in the 'users' collection with current information about courses that they are subscribed to, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __`user`__:     object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`toMerge`__:  __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__4.__ `void setUserCourseWorkData(FirebaseUser user, String courseId, {toMerge: true}) async`
##### Summary:
Updates the per-user document in the 'users' collection with current information about course work that they are allowed to view from classes that they are subscribed to, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __`user`__:     object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`courseId`__: id of course for which to pull course works for from classroom.
* __`toMerge`__:  __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__5.__ `void setUserAnnouncementData(FirebaseUser user, String courseId, {toMerge: true}) async`
##### Summary:
Updates the per-user document in the 'users' collection with current information about course announcements that they are allowed to view from classes that they are subscribed to, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __`user`__:     object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`courseId`__: id of course for which to pull course announcements for from classroom.
* __`toMerge`__:  __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__5.__ `void setUserClassStudents(FirebaseUser user, String courseId, {toMerge: true}) async`
##### Summary:
Updates the per-user document in the 'users' collection with current information about students in the current user's subscribed classes, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __`user`__:     object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`courseId`__: id of course for which to pull course students for from classroom.
* __`toMerge`__:  __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__6.__ `void setUserClassTeachers(FirebaseUser user,String courseId, {toMerge: true}) async`
##### Summary:
Updates the per-user document in the 'users' collection with current information about teachers of the current user's subscribed classes, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __`user`__:     object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`courseId`__: id of course for which to pull course teachers for from classroom.
* __`toMerge`__:  __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__7.__ `void setUserClassTopics(FirebaseUser user, String courseTopics, {toMerge: true}) async`
##### Summary:
Updates the per-user document in the 'users' collection with current information about course topics from the current user's subscribed classes, if the information exists. Otherwise, creates an entry in the document to contain the information. Called once on user sign in by default.
##### Parameters:
* __`user`__:     object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`courseId`__: id of course for which to pull course topics for from classroom.
* __`toMerge`__:  __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__8.__ `Future<List<classroom.Course>> pullCourses(FirebaseUser user) async`
##### Summary:
Pulls information about courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __`user`__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of `List<classroom.Course>` where the list value of the future contains the `classroom.Course` objects that define each of the user's courses. __The return of this function cannot be used directly and must be processed as in the example code.__
##### Example Usage in a Widget:
```Java
class DashboardScreenState extends State<DashboardScreen> {
  List<classroom.Course> _courses = new List<classroom.Course>();
  
  Future<void> processFuture() async {
    List<classroom.Course> tempCourses = await pullCourses(firebaseUser);
    setState(()  {
      _courses = tempCourses;
    });
  }

  @override
  void initState() {
    super.initState();
    processFuture().then((arg) {
    
    // ANY CODE THAT DEPENDS ON processFuture() COMPLETING FIRST
    
    }, onError: (e) {
        print(e);
        // ERROR HANDLING CODE
    });
    // ANY CODE THAT DOES NOT DEPEND ON processFuture() TO COMPLETE
  }
}
```
##### Explanation
Because this method is asynchronous, it will return a `Future<T>` which must be processed by the user to extract the T object of the Future. The 'await' keyword allows to wait for a Future to complete its task. Once the task is completed, the returned object is extracted from the Future and can be used regularly. The reason for using `setState()` instead of a direct assignment to `_courses` is that without calling `setState()` there is no guarantee that the state variable `_courses` is updated at the appropriate time. __Not following this example may introduce race conditions into your code where the `build()` method of your widget is executed before the data is ready resulting in no guarantees on the completeness of data being returned.__


__9.__ `Future<List<classroom.CourseWork>> pullCourseWorkData(FirebaseUser user) async`
##### Summary:
Pulls information about course work objects for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __`user`__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of `List<classroom.CourseWork>` where the list value of the future contains the `classroom.CourseWork` objects that define user course work. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__10.__ `Future<List<classroom.Announcement>> pullCourseAnnouncements(FirebaseUser user) async`
##### Summary:
Pulls information about announcements that the user is allowed to see for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __`user`__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of `List<classroom.Announcement>` where the list value of the future contains the `classroom.Announcement` objects that define announcements in courses that the user is subscribed to. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__11.__ `Future<List<classroom.Student>> pullClassmates(FirebaseUser user) async`
##### Summary:
Pulls information about students for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __`user`__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of `List<classroom.Student>` where the list value of the future contains the `classroom.Student` objects that define students in classes that the user is subscribed to. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__12.__ `Future<List<classroom.Teacher>> pullTeachers(FirebaseUser user) async`
##### Summary:
Pulls information about teachers of the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __`user`__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of `List<classroom.Teacher>` where the list value of the future contains the `classroom.Teacher` objects that define teachers for classes that the user is subscribed to. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__13.__ `Future<List<classroom.Topic>> pullTopics(FirebaseUser user) async`
##### Summary:
Pulls information about course material topics for the courses that the current user is subscribed to from the Firestore.
##### Parameters:
* __`user`__:  object storing the currently logged in FireBase user from which appropriate information is extracted.
##### Return:
A Future of `List<classroom.Topic>` where the list value of the future contains the `classroom.Topic` objects that define each of the user's course topics. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


__14.__ `void setUserCourseGoals(FirebaseUser user, List<Goal> courseGoals, String goalType, {toMerge: true}) async`
##### Summary:
Updates per user goals on Firebase with goals from courseGoals in the goalType section of the document. This method will remove every goal with the specified goal type and replace it with the list of goals inputted as the argument. If you want to keep the current goals, then add the goals from pullGoals to the courseGoals.
##### Parameters:
* __`user`__:      object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`goalType`__:  specifies which section of the Firebase document to push the goals to. One of "CourseGoalObjects" (main goals for a specific course), "GeneralGoalObjects" (general goals for no particular course) or "CourseWorkGoalObjects" (specific goals for an assignment of some course).
* __`toMerge`__:   __optional__ flag that decides whether this data will be merged with the current data on Firebase (if true) or overwrite it (if false). __Set to true by default if no value is specified.__


__15.__ `Future<List<Goal>> pullGoals(FirebaseUser user, String goalType) async`
##### Summary:
Pulls information about goals of a given goalType for this user.
##### Parameters:
* __`user`__:      object storing the currently logged in FireBase user from which appropriate information is extracted.
* __`goalType`__:  specifies which section of the Firebase document to pull goals from. One of "CourseGoalObjects" (main goals for a specific course), "GeneralGoalObjects" (general goals for no particular course) or "CourseWorkGoalObjects" (specific goals for an assignment of some course).
##### Return:
A Future of `List<Goal>` where the list value of the future contains the `Goal` objects that define each of the user's goals. __The return of this function cannot be used directly and must be processed to extract it from the Future by awaiting its completion.__


## FirestoreDataManager Documentation
API for processing data obtained from the Cloud Firestore. __This API deals a lot with data types defined in Google's Classroom API, it is suggested to review its documentation as needed to see what fields and methods the returned objects contain.__


#### Methods
__1.__ `List<classroom.Student> getClassRoster(String courseID, List<classroom.Student> students)`
##### Summary:
Find and return all students from students who are subscribed to the class with a courseId that matches courseID.
##### Exceptions and Preconditions:
Assumes that students is not null, throws __`NullArgumentException`__ otherwise.
##### Parameters:
* __`courseID`__:  course id of the course the students of which are being searched for.
* __`students`__:  student objects to search in
##### Return:
A List of all Student objects in students that had a courseId that matched courseID.


__2.__ `List<classroom.Teacher> getCourseTeachers(String courseID, List<classroom.Teacher> teachers)`
##### Summary:
Find and return all teachers in teachers who teach the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that teachers is not null, throws __`NullArgumentException`__ otherwise.
##### Parameters:
* __`courseID`__:  course id of the course the teachers of which are being searched for.
* __`teachers`__:  teacher objects to search in
##### Return:
A List of all Teacher objects in topics that had a courseId that matched courseID.


__3.__ `List<classroom.Topic> getCourseTopics(String courseID, List<classroom.Topic> topics)`
##### Summary:
Find and return all course topics in topics for the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that topics is not null, throws __`NullArgumentException`__ otherwise.
##### Parameters:
* __`courseID`__:  course id of the course the topics of which are being searched for.
* __`topics`__:    topic objects to search in
##### Return:
A List of all Topic objects in topics that had a courseId that matched courseID.


__4.__ `List<classroom.Announcement> getCourseAnnouncements(String courseID, List<classroom.Announcement> announcements)`
##### Summary:
Find and return all course announcements in announcements for the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that announcements is not null, throws __`NullArgumentException`__ otherwise.
##### Parameters:
* __`courseID`__:       course id of the course the topics of which are being searched for.
* __`announcements`__:  announcement objects to search in
##### Return:
A List of all Announcement objects in announcements that had a courseId that matched courseID.


__5.__ `List<classroom.CourseWork> getCourseWorksForCourse(String courseID, List<classroom.CourseWork> works)`
##### Summary:
Find and return all course works in works for the course with courseId courseID.
##### Exceptions and Preconditions:
Assumes that works is not null, throws __`NullArgumentException`__ otherwise.
##### Parameters:
* __`courseID`__:  course id of the course the topics of which are being searched for.
* __`works`__:     announcement objects to search in
##### Return:
A List of all CourseWork objects in works that had a courseId that matched courseID.



## Goal Documentation
The internal class representation of a student goal within our app. Should be associated with a particular course and a particular cousre work.

#### Attributes
* __`String name`__:           name of this goal
* __`String text`__:           description of this goal
* __`DateTime dueDate`__:      due date of this goal. The raw format of this object is "yyyy-mm-ddThh:mm:ss:nnnn" and so special getter methods should be used to access the full date. Access directly to this object is provided as a convenience in case a specific attribute (such as the month) is needed.
* __`String _status`__:        status indicating that the goal is in one of these states: "IN_PROGRESS", "COMPLETED", "COMPLETED_LATE" and "IN_PROGRESS_LATE"
* __`String _courseID`__:      ID of Course object that this goal belongs to
* __`String _courseWorkID`__:  ID of the CourseWork object that this goal is associated with.

#### Constructors
__1.__
`Goal({String name: "BlankGoal", String text: "", courseID: "-1",
    courseWorkID: "-1",  String dueDate: ""})`
##### Summary:
Every parameter is optional and will be assigned its default value unless otherwise specified. The format for the date string is: "yyyy-mm-ddThh:mm:ss", where T let's the object separate the date from the time during the parsing of the string.

__2.__
`Goal.fromJson(Map<dynamic, dynamic> json)`
##### Summary:
Create a new Goal object from its JSON representation.
##### Parameters:
* __`json`__: JSON representation of this object stored in a Map
##### Return:
A Goal object the fields of which are the keys of the map and their values the corresponding key values from the map.

#### Methods
__1.__ `String getStatus()`
##### Summary:
Get the current status of this goal. Before returning, this method will change the status from on time to late if the goal is in progress and it is currently past the due date.
##### Return:
One of: ("IN_PROGRESS", "COMPLETED", "COMPLETED_LATE", "IN_PROGRESS_LATE").

__2.__ `void completeGoal()`
##### Summary:
Set the state of this goal to one of ("COMPLETED", "COMPLETED_LATE").

__3.__ `String getDueTime()`
##### Summary:
Get the string representation of this goal's due time on a 24-hour clock.
##### Return:
String in the format "hh:mm:ss".

__4.__ `String getCalendarDueDate()`
##### Summary:
Get the string representation of this goal's due date. See [Util Doc](#util-functions-documentation)
##### Return:
String in the format "dd/mm/yyyy".

__5.__ `String getCourseId()`
##### Summary: 
Get the ID of the course that this goal is associated with.
##### Return:
A numeric course ID as a string.

__6.__ `String getCourseWorkId()`
##### Summary: 
Get the ID of the course work that this goal is associated with.
##### Return:
A numeric course work ID as a string.

__7.__ `String toString()`
##### Summary: 
Get the String summary of the object.
##### Return:
This object as a description string.

__8.__ `Map<String, dynamic> toJson()`
##### Summary:
Converts this object into a Json serializable representation using a hash map. For example, the name of the Goal object that was converted can be accessed from the returned Map as follows: returnedMap["name"].
##### Return:
Map object with keys being the fields of the Goal object and the values their corresponding values.


## Util Functions Documentation

__1.__ `String getMonthFromDateStr(String dateString)`
##### Summary:
Extract and convert the numerical month in a date string to its text representation. For example, for the input "15/11/2019" the return
would be "November".
##### Parameters:
* __`dateString`__:  the string representation of the date the month of which is to be extracted
##### Exceptions and Preconditions:
Assumes that the string is properly formatted as specified. Throws a __FormatException__ otherwise when the string cannot be parsed.
##### Return:
Text representation of the month within the given date.  


__2.__ `String getMonthFromDateObj(DateTime date)`
##### Summary:
Extract the month from a date object and return its text representation.
##### Parameters:
* __`date`__:  a date object from which to extract the month
##### Return:
Text representation of the month within the given date.

__3.__ `printError(String header, String error, String stackTrace, {String extraInfo = ""})`
##### Summary:
Print a nicely formatted custom error message to the debug console using the header to label the message, error as the message text and stackTrace for the location of the error. extraInfo is used to provide optional
details about the error.
##### Parameters:
* __`header`__:      error message header.
* __`error`__:       error text. Should be e.toString() where e is the error object caught inside the try-catch block.
* __`stackTrace`__:  stack trace of the error. You should use stackTrace.toString() for this argument where stackTrace is the stack trace caught in a try-catch block.
* __`extraInfo`__:   optional argument for holding any extra information the developer may want to specify about the error.
##### Example Usage and Output:
```Java
try{
  //YOUR CODE
} catch (e, stackTrace){
  printError("ERROR!", e.toString(), stackTrace.toString(), "Optional Info");
}


"""
Example Output:

-------------------------------------ERROR!-------------------------------------
NoSuchMethodError: The getter 'keys' was called on null.
Receiver: null
Tried calling: keys
Optional Info

Stack Trace:
#0      Object.noSuchMethod (dart:core-patch/object_patch.dart:51:5)
#1      setUserClassTopics (package:student_agenda/FirestoreManager.dart:297:22)
"""
```

__4.__ `String getCalendarDueDate(DateTime date)`
##### Summary: 
Get the string representation of date.
##### Parameters:
* __`date`__:  object from which to extract the date string. 
##### Return:
String in the format "dd/mm/yyyy".

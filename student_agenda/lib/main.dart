import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis/chat/v1.dart' as prefix0;
import 'package:googleapis/classroom/v1.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_agenda/Screens/courseGoalsScreen.dart';
import 'package:student_agenda/Screens/landingScreen.dart';
import 'package:student_agenda/Screens/listedGoalsScreen.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'Screens/courseDashboard.dart';
import 'Utilities/util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_agenda/Screens/mainScreen.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

// Stream so app can respond to notification-related events, since we define in
// the main function.
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload
  });
}

Future<void> main() async {
  // needed since we init in main
  WidgetsFlutterBinding.ensureInitialized();

  // check if app was launched via notification
  var notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // platform dependent init settings
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
    onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload));
    }
  );

  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    }
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController logoController;

  @override
  void initState() {logoController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();

    // listen for received notifications
    didReceiveLocalNotificationSubject.stream.listen(
        (ReceivedNotification receivedNotification) async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: receivedNotification.title != null
                ? Text(receivedNotification.body)
                : null,
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Future<FirebaseUser> user = authService.googleSignIn();
                    Navigator.of(context, rootNavigator: true).pop();
                    await user.then((user) =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                LandingScreen()
                            )
                        )
                    );
//                    await Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => ListedGoalsScreen()
//                      )
//                    );
                  },
                )
              ],
            )
          );
        }
    );

    selectNotificationSubject.stream.listen((String payload) async {
      Future<FirebaseUser> user = authService.googleSignIn();
      Navigator.of(context, rootNavigator: true).pop();
      await user
          .then((user) =>
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LandingScreen())
          )
      );
//      await Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => ListedGoalsScreen())
//      );
    });
  }

  @override
  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  void displayLogInFailedToast(var e) {
    Fluttertoast.showToast(
        msg: "Log in failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    print("LOG IN EXCEPTION START--------------");
    print(e);
    print("LOG IN EXCEPTION END--------------");
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = CustomMaterialButton(
      text: 'Login',
      onPressed: () {
        Future<FirebaseUser> user = authService.googleSignIn();
        user
            .then((user) =>
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LandingScreen()),
            ))
            .catchError((e) => displayLogInFailedToast(e));
      },
    );
    // This method is rerun every time setState is called
    return Scaffold(
      backgroundColor: Color(0xff00AC52),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(36.0, 36.0, 36.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(logoController),
                    child: InkWell(
                      onDoubleTap: () => logoController.forward(),
                      child: Image.asset(
                        "images/tdsblogo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 45.0),
                loginButton,
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:student_agenda/Screens/landingScreen.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'Screens/courseDashboard.dart';
import 'Utilities/util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_agenda/Screens/mainScreen.dart';

void main() => runApp(MyApp());

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
  void initState() {
    logoController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
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

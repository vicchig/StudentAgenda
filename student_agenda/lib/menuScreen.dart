import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton( //TODO: An image would probably look better (this is just a placeholder for now)
              onPressed: null, //TODO: Make this go to the courses page
              child: Text('My Courses', style: TextStyle(fontSize: 20)
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(  //TODO: An image would probably look better (this is just a placeholder for now)
              onPressed: null, //TODO: Make this go to the settings page
              child: Text('Settings', style: TextStyle(fontSize: 20)
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(   //TODO: An image would probably look better (this is just a placeholder for now)
              onPressed: null, //TODO: Make this go back to the log in page and log out the user
              child: Text('Log Out', style: TextStyle(fontSize: 20)
              ),
            ),
          ],
        ),
      ),
    );
  }



}
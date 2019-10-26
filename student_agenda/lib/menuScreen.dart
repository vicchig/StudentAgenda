import 'package:flutter/material.dart';
import 'util.dart';

class MainMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
        centerTitle: true,
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          NavigationButton(
            text: 'Course 1',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 2',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 3',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 4',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 5',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 6',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 7',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 8',
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
        ],
      )

      );
  }



}
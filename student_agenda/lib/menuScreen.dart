import 'package:flutter/material.dart';
import 'util.dart';

class MainMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
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
          NavigationButton( //TODO: Likely will want images for these
                            //TODO: Also all of these need proper onPressed() methods
            text: 'Course 1',
            colour: Colors.greenAccent,
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 2',
            colour: Colors.lightBlueAccent,
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 3',
            colour: Colors.orangeAccent,
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 4',
            colour: Colors.redAccent,
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 5',
            colour: Colors.amberAccent,
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 6',
            colour: Colors.indigoAccent,
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 7',
            colour: Colors.pinkAccent,
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          NavigationButton(
            text: 'Course 8',
            colour: Colors.limeAccent,
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
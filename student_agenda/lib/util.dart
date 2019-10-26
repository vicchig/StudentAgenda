import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Button that navigates to another screen
class NavigationButton extends StatelessWidget{
  ///Button Text, default='NavigationText'
  final String text;

  ///How far off the screen the button appears to be, default=5.0
  final double elevation;

  ///Background colour of the button, default=Colors.white
  final Color colour;

  ///How rounded the edges of the square button are, default=30.0
  final double borderRad ;

  ///Method that is ran when the button is pressed
  final GestureTapCallback onPressed;

  NavigationButton({this.text = 'Navigation Button', @required this.onPressed,
  this.elevation = 5.0, this.colour = Colors.white, this.borderRad = 30.0});

  @override
  Widget build(BuildContext context){
    return Material( //Course 1
      elevation: this.elevation,
      borderRadius: BorderRadius.circular(this.borderRad),
      color: this.colour,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(
          this.text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//------------------------------
//CODE ADAPTED FROM: https://www.linkedin.com/pulse/build-your-own-custom-side-menu-flutter-app-alon-rom
///Item representation for the sidebar menu
class MenuItem{
  ///Text of the menu item
  String text;

  ///Background colour of the menu item
  Color colour;

  ///Function that is executed when the menu item is chosen
  Function func;

  MenuItem({this.text = 'Menu Item', this.colour = Colors.white,
            @required this.func});
}
//------------------------------

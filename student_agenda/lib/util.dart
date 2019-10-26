import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget{

  String text;
  double elevation;
  Color colour = Colors.white;
  double borderRad ;

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
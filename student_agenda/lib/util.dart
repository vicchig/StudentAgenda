import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget{

  String text;
  final GestureTapCallback onPressed;
  NavigationButton({this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context){
    return Material( //Course 1
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
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
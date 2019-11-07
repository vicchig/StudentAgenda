import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'calendarScreen.dart';
import 'courseDashboard.dart';
import 'addGoalsScreen.dart';
import 'listedGoalsScreen.dart';
import 'package:student_agenda/performanceScreen.dart';
import 'package:student_agenda/mainScreen.dart';


/// Button that navigates to another screen
class NavigationButton extends StatelessWidget {
  ///Button Text, default='NavigationText'
  final String text;

  ///How far off the screen the button appears to be, default=5.0
  final double elevation;

  ///Background colour of the button, default=Colors.white
  final Color colour;

  ///How rounded the edges of the square button are, default=30.0
  final double borderRad;

  ///Method that is ran when the button is pressed
  final GestureTapCallback onPressed;

  NavigationButton(
      {this.text = 'Navigation Button',
      @required this.onPressed,
      this.elevation = 5.0,
      this.colour = Colors.white,
      this.borderRad = 30.0});

  @override
  Widget build(BuildContext context) {
    return Material(
      //Course 1
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
class MenuItem {
  ///Text of the menu item
  String text;

  ///Background colour of the menu item
  Color colour;

  ///Function that is executed when the menu item is chosen
  Function func;

  MenuItem(
      {this.text = 'Menu Item',
      this.colour = Colors.white,
      @required this.func});
}
//------------------------------

/// Drawer class for displaying the sidebar menu
class MenuDrawer extends StatefulWidget {
  @override
  MenuDrawerState createState() {
    return MenuDrawerState();
  }
}

//------------------------------
//CODE ADAPTED FROM:  https://www.linkedin.com/pulse/build-your-own-custom-side-menu-flutter-app-alon-rom
///Drawer class for drawing the sidebar menu in a Widget's Scaffold
///
/// Ex. use inside build()
/// drawer: new MenuDrawerState(),
class MenuDrawerState extends State<MenuDrawer> {
  ///Currently selected screen (in the sidebar menu)
  MenuItem selectedMenuItem;

  ///List of menu options that are displayed in the sidebar menu
  List<MenuItem> menuItems;

  ///Widgets representing each menu option in menuItems
  List<Widget> menuOptionWidgets = [];

  @override
  void initState() {
    super.initState();

    menuItems = createMenuItems(this.context);
    selectedMenuItem = menuItems.first;
  }

  ///Select the provided menu item item and update the current state of the
  ///Widget
  ///
  /// @param item  menu item that has been selected
  void onSelectMenuItem(MenuItem item, BuildContext context) {
    setState(() {
      //change the global state variables here
      selectedMenuItem = item;
    });
    Navigator.of(context).pop(); //close menu

    Navigator.push(context, item.func()); //change screen
  }

  @override
  Widget build(BuildContext context) {
    menuOptionWidgets = [];
    //add options and widgets that represent them to their respective lists
    for (var menuItem in menuItems) {
      menuOptionWidgets.add(
        new Container(
          decoration: new BoxDecoration(
              color: menuItem == selectedMenuItem ? 
                Colors.orange : Colors.green),
          child: new ListTile(
            onTap: () => onSelectMenuItem(menuItem, context),
            title: Text(
              menuItem.text,
              style: new TextStyle(
                  fontSize: 20.0,
                  color: menuItem.colour,
                  fontWeight: menuItem == selectedMenuItem
                      ? FontWeight.bold
                      : FontWeight.w300),
            ),
          ),
        ),
      );

      menuOptionWidgets.add(
        new SizedBox(
          child: new Center(
            child: new Container(
              margin: new EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
              height: 0.3,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
              child: Center(
                child: Text(
                  'Menu',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              margin: new EdgeInsetsDirectional.only(top: 20.0),
              color: Colors.white,
              constraints: BoxConstraints(maxHeight: 90.0, minHeight: 90.0)),
          new SizedBox(
            child: new Center(
              child: new Container(
                margin: new EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
                height: 0.3,
                color: Colors.green,
              ),
            ),
          ),
          new Container(
            color: Colors.white,
            child: new Column(children: menuOptionWidgets),
          ),
        ],
      ),
    );
  }

  ///Return a list of menu options to be used by the sidebar menu
  ///
  /// @return  list containing all available menu items
  List<MenuItem> createMenuItems(BuildContext context) {
    final menuItems = [
      new MenuItem(
          text: 'My Courses',
          colour: Colors.white,
          func: () {
            return MaterialPageRoute(builder: (context) => DashboardScreen());
          }),
      new MenuItem(
          text: 'Settings',
          colour: Colors.white,
          func: () {
            return MaterialPageRoute(builder: (context) => SettingsScreen());
          }),      
      new MenuItem(
          text: 'Calendar Screen (temporary link)',
          colour: Colors.white,
          func: (){
            authService.signOut();
            return MaterialPageRoute(builder: (context) => CalendarScreen());
          }),
      new MenuItem(
          text: 'Add Goal (For Demo Only)',
          colour: Colors.white,
          func: () {
            return MaterialPageRoute(builder: (context) => AddGoalsScreen());
          }),
      new MenuItem(
          text: 'Goal List (For Demo Only)',
          colour: Colors.white,
          func: () {
            return MaterialPageRoute(builder: (context) => ListedGoalsScreen());
          }),
      new MenuItem(
          text: 'Performance (For Demo Only)',
          colour: Colors.white,
          func: () {
            return MaterialPageRoute(builder: (context) => PerformanceScreen());
          }),
      new MenuItem(
          text: 'Log Out',
          colour: Colors.white,
          func: () {
            return MaterialPageRoute(builder: (context) => MyHomePage());
          }),
      new MenuItem(
          text: 'Dashboard (For Demo Only)',
          colour: Colors.white,
          func: () {
            return MaterialPageRoute(
                builder: (context) => MainDashboardScreen());
          }),
    ];
    return menuItems;
  }
//------------------------------
}

import 'package:flutter/material.dart';
import 'package:student_agenda/myCoursesScreen.dart';
import 'util.dart';

//------------------------------
//CODE ADAPTED FROM:  https://www.linkedin.com/pulse/build-your-own-custom-side-menu-flutter-app-alon-rom
///Sidebar menu that appears in every screen except for the log in
class MainMenu extends StatefulWidget {
  @override
  MainMenuState createState(){
    return MainMenuState();
  }
}

///Sidebar menu Widget state
class MainMenuState extends State<MainMenu> {
  ///Title of the current screen being displayed
  Widget appBarTitle;

  ///Currently selected screen (in the sidebar menu)
  MenuItem selectedMenuItem;

  ///List of menu options that are displayed in the sidebar menu
  List<MenuItem> menuItems;

  ///Widgets representing each menu option in menuItems
  List<Widget> menuOptionWidgets = [];

  @override
  void initState() {
    super.initState();

    menuItems = createMenuItems();
    selectedMenuItem = menuItems.first;
    appBarTitle = new Text(selectedMenuItem.text);
  }

  /// Execute item's func field and return the result
  ///
  /// @param item  a menu item whose func is to be executed
  getMenuItemWidget(MenuItem item){
    return item.func();
  }

  ///Select the provided menu item item and update the current state of the
  ///Widget
  ///
  /// @param item  menu item that has been selected
  void onSelectMenuItem(MenuItem item){
    setState(() { //change the global state variables here
      selectedMenuItem = item;
      appBarTitle = new Text(item.text);
    });

    Navigator.of(context).pop(); //close menu
  }

  @override
  Widget build(BuildContext context) {
    menuOptionWidgets = [];

    //add options and widgets that represent them to their respective lists
    for(var menuItem in menuItems){
      menuOptionWidgets.add(
          new Container(
              decoration: new BoxDecoration(
              color: menuItem == selectedMenuItem ? Colors.blueGrey : Colors.black
            ),
            child: new ListTile(
              onTap: () => onSelectMenuItem(menuItem),
              title: Text(
                menuItem.text, style: new TextStyle(
                  fontSize: 20.0,
                  color: menuItem.colour,
                  fontWeight: menuItem == selectedMenuItem ? FontWeight.bold : FontWeight.w300),
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

    return Scaffold( //Sidebar menu scaffold
      appBar: new AppBar(
        title: appBarTitle,
        centerTitle: true,
      ),

      //draw the sidebar menu options
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Container(
                child: Center(
                     child: Text(
                       'Menu',
                       textAlign: TextAlign.center,
                       style: new TextStyle(
                           fontSize: 20.0,
                           fontWeight: FontWeight.bold ),
                     ),
                ),
                margin: new EdgeInsetsDirectional.only(top: 20.0),
                color: Colors.white,
                constraints: BoxConstraints(maxHeight: 90.0, minHeight: 90.0)
            ),
            new SizedBox(
              child: new Center(
                child: new Container(
                  margin:
                  new EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
                  height: 0.3,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              color: Colors.white,
              child: new Column(children: menuOptionWidgets),
            ),
          ],
        ),
      ),
      //------------------------------

        body: getMenuItemWidget(selectedMenuItem),

      );
  }

  ///Return a list of menu options to be used by the sidebar menu
  ///
  /// @return  list containing all available menu items
  List<MenuItem> createMenuItems(){
    final menuItems = [
      new MenuItem(
        text: 'My Courses',
        colour: Colors.white,
        func: (){
          return new CoursesScreen();
        }
      ),
      new MenuItem(
        text: 'Settings',
        colour: Colors.white,
        func: (){
          return new CoursesScreen();
        }
      ),
      new MenuItem(
        text: 'Log Out',
        colour: Colors.white,
        func: (){
          return new CoursesScreen();
        }
      ),
    ];
    return menuItems;
  }
}
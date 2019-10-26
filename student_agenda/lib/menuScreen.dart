import 'package:flutter/material.dart';
import 'package:student_agenda/myCoursesScreen.dart';
import 'util.dart';

//------------------------------
//CODE ADAPTED FROM:  https://www.linkedin.com/pulse/build-your-own-custom-side-menu-flutter-app-alon-rom
class MainMenu extends StatefulWidget {
  @override
  MainMenuState createState() => MainMenuState();

}
class MainMenuState extends State<MainMenu> {
  Widget appBarTitle;
  MenuItem selectedMenuItem;
  List<MenuItem> menuItems;
  List<Widget> menuOptionWidgets = [];

  @override
  void initState() {
    super.initState();

    menuItems = createMenuItems();
    selectedMenuItem = menuItems.first;
    appBarTitle = new Text(selectedMenuItem.text);
  }

  getMenuItemWidget(MenuItem item){
    return item.func();
  }

  void onSelectItem(MenuItem item){
    setState(() { //change the global state variables here
      selectedMenuItem = item;
      appBarTitle = new Text(item.text);
    });

    Navigator.of(context).pop(); //close menu
  }

  @override
  Widget build(BuildContext context) {
    menuOptionWidgets = [];
    for(var menuItem in menuItems){
      menuOptionWidgets.add(
          new Container(
            decoration: new BoxDecoration(
              color: menuItem == selectedMenuItem ? Colors.grey[200] : Colors.white
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
    //------------------------------


    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        centerTitle: true,
      ),

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

  List<MenuItem> createMenuItems(){
    final menuItems = [
      new MenuItem(
        text: 'My Courses',
        func: () => new CoursesScreen(),
      ),
      new MenuItem(
        text: 'Settings',
        func: () => new CoursesScreen(),
      ),
      new MenuItem(
        text: 'Log Out',
        func: () => new CoursesScreen(),
      ),
    ];
    return menuItems;
  }

  void onSelectMenuItem(MenuItem item){

  }
}
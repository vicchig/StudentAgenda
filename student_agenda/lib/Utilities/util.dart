import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import '../main.dart';
import '../Screens/calendarScreen.dart';
import '../Screens/courseDashboard.dart';
import '../Screens/addGoalsScreen.dart';
import '../Screens/listedGoalsScreen.dart';
import 'package:student_agenda/Screens/performanceScreen.dart';
import 'package:student_agenda/Screens/mainScreen.dart';
import 'package:charts_flutter/flutter.dart' as charts;


import '../Screens/settingsScreen.dart';
import 'auth.dart';

//TODO: Probably move these to their own files


/// Button that navigates to another screen
class CustomMaterialButton extends StatelessWidget {
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

  CustomMaterialButton(
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
            authService.signOut();
            Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new MyHomePage()));
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

//USEFUL FUNCTIONS
final Map<String, String>numToMonth = {"1": "January", "2": "February",
  "3": "March", "4": "April", "5": "May", "6": "June", "7": "July",
  "8": "August", "9": "September", "10": "October", "11": "November",
  "12": "December"};

String getMonthFromDateStr(String dateString) {
  List<String> splitStr = dateString.split("/");

  if( splitStr.length > 1 && splitStr[1][0] == "0"){
    splitStr[1] = splitStr[1].substring(1);
  }

  if(splitStr.length > 1 && numToMonth.keys.contains(splitStr[1])){
      return numToMonth[splitStr[1]];
  }
  throw new FormatException("Date String could not be parsed. Got: " +
      dateString, " but expected string in format: 'dd/mm/yyyy'");
}

String getMonthFromDateObj(DateTime date){
  return numToMonth[date.month.toString()];
}

void printError(String header, String error, String stackTrace,
    {String extraInfo = ""}){
  print("\n");
  print("-------------------------------------"+  header +
      "-------------------------------------\n" + error);
  print(extraInfo + "\n\n");
  print("Stack Trace: \n" + stackTrace);
  print("\n\n");
}

String getCalendarDueDate(DateTime date){
  return "" + date.day.toString() + "/" + date.month.toString() + "/" +
      date.year.toString();
}

class PieDatum {
  final String label;
  final double percentVal;
  final Color color;

  PieDatum(this.label, this.percentVal, this.color);
}

List<charts.Series<PieDatum, String>> createPieData(Map<String, dynamic> chartData) {
  List<PieDatum> data = new List<PieDatum>();
  data.add(new PieDatum("Completed on Time", chartData["onTime%"], Colors.green[200]));
  data.add(new PieDatum("Completed Late", chartData["late%"], Colors.orangeAccent[100]));
  data.add(new PieDatum("Incomplete", chartData["incomplete%"], Colors.redAccent[100]));

  return [
    new charts.Series<PieDatum, String>(
      id: 'Data',
      domainFn: (PieDatum point, _) => point.label,
      measureFn: (PieDatum point, _) => point.percentVal,
      data: data,
      labelAccessorFn: (PieDatum row, _) => '${row.percentVal.toString() + "%"}',
      colorFn: (PieDatum point, _) => charts.ColorUtil.fromDartColor(point.color)
    )
  ];
}

charts.PieChart buildPieChart(List<charts.Series<PieDatum, dynamic>> chartDataSeries){
  return charts.PieChart(
    chartDataSeries,
    animate: true,
    animationDuration: Duration(milliseconds: 750),
    behaviors: [
      new charts.DatumLegend(
        outsideJustification: charts.OutsideJustification.endDrawArea,
        horizontalFirst: false,
        desiredMaxRows: 1,
        cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),

      )
    ],
    defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
          )
        ]
    ),
  );
}

List<Widget> buildPerformanceScreen(Map<String, dynamic> data, charts.PieChart pChart, charts.LineChart tChart){
  return <Widget>[
    Text("Task Breakdown by Completion Time"),
    SizedBox(height: 10.0),
    Expanded(
      child: SizedBox(
        height: 1000,
        child: new ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(
                width: 3000,
                height: 300,
                child: pChart
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              child: Text("Stats", textAlign: TextAlign.center),
            ),
            Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                defaultColumnWidth: FixedColumnWidth(150.0),
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Container(
                      child: Text("Tasks Completed on Time"),
                      width: 150,
                      alignment: Alignment(-0.9, 0.0),
                    ),
                    Container(
                      child: Text(data["completedOnTime"].toString()),
                      color: Colors.green[50],
                      width: 150,
                      alignment: Alignment(0.0, 0.0),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      child: Text("Task Completed Late"),
                      width: 150,
                      alignment: Alignment(-0.9, 0.0),
                    ),
                    Container(
                      child: Text(data["completedLate"].toString()),
                      color: Colors.orange[50],
                      width: 150,
                      alignment: Alignment(0.0, 0.0),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      child: Text("Incomplete Tasks"),
                      width: 150,
                      alignment: Alignment(-0.9, 0.0),
                    ),
                    Container(
                      child: Text(data["incomplete"].toString()),
                      color: Colors.red[50],
                      width: 150,
                      alignment: Alignment(0.0, 0.0),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      child: Text("Total Tasks"),
                      width: 150,
                      alignment: Alignment(-0.95, 0.0),
                    ),
                    Container(
                      child: Text(data["tasksCreated"].toString()),
                      width: 150,
                      alignment: Alignment(0.0, 0.0),
                    ),
                  ]),TableRow(children: [
                    Container(
                      child: Text("Average Completion Time"),
                      width: 150,
                      alignment: Alignment(-0.8, 0.0),
                    ),
                    Container(
                      child: Text("15.0"),
                      width: 150,
                      alignment: Alignment(0.0, 0.0),
                    ),
                  ]),
                ]
            ),
            SizedBox(
              height: 35,
            ),
            SizedBox(
                width: 3000,
                height: 300,
                child: tChart
            ),
          ],
        ),
      ),
    ),
  ];
}

charts.LineChart buildLineChart(List<charts.Series<TimeSeriesValue, int>> chartDataSeries){
  return new charts.LineChart(
    chartDataSeries,
    animate: true,
    defaultRenderer: new charts.LineRendererConfig(),
    customSeriesRenderers: [
      new charts.PointRendererConfig(
          customRendererId: 'customPoint')
    ],
    behaviors: [
      new charts.SlidingViewport(),
      new charts.PanAndZoomBehavior(),
    ],
  );
}


List<charts.Series<TimeSeriesValue, int>> createTimeLineData(Map<String, dynamic> chartData, int months) {
  List<TimeSeriesValue> data = new List<TimeSeriesValue>();
  for(int i = 0; i < months; i++){
    data.add(TimeSeriesValue(i + 1, 0));
  }

  print(chartData);

  int periodStartYear = chartData["goalCompletions"][0].year;
  int periodStartMonth = chartData["goalCompletions"][0].month;
  int periodEndMonth = chartData["goalCompletions"][1].month;
  for(int i = 2; i < chartData["goalCompletions"].length; i++){
    int goalCompletionYear = chartData["goalCompletions"][i].year;
    int goalCompletionMonth = chartData["goalCompletions"][i].month;

    if(goalCompletionYear <= periodStartYear){
      int monthIdx = goalCompletionMonth - periodStartMonth;
      monthIdx = monthIdx == months ? monthIdx - 1: monthIdx;
      data[monthIdx].val++;
    }
    else if(goalCompletionYear > periodStartYear){
      data[12 - ((periodEndMonth - months) + 12)].val++;
    }
  }


  return [
    new charts.Series<TimeSeriesValue, int>(
        id: 'Data',
        domainFn: (TimeSeriesValue point, _) => point.month,
        measureFn: (TimeSeriesValue point, _) => point.val,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    )
  ];
}

class TimeSeriesValue{
  final int month;
  int val;

  TimeSeriesValue(this.month, this.val);
}


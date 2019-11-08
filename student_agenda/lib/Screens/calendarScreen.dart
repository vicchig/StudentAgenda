import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../Utilities/util.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

void main() => runApp(CalendarScreen());

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Calendar',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CalPage(),
    );
  }
}

class CalPage extends StatefulWidget {
  @override
  _CalPageState createState() => _CalPageState();
}

class _CalPageState extends State<CalPage> with TickerProviderStateMixin{
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {

    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8', 'Event T1', 'Event T2'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };


    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();



    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );


    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }


  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }


  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    //set default value for focused day as current day so application can write out text
    // without crashing on startup before the user taps on the first focused date
    //_calendarController.setFocusedDay(_calendarController.selectedDay);

    //following is for formatting date that is shown below calendar that says what day tasks are due
    DateFormat formatter = new DateFormat('EEEE LLLL dd yyyy');
    String formatted = '';
    if(_calendarController.focusedDay != null) {
      DateTime selectedDate = _calendarController.focusedDay;
      formatted = formatter.format(selectedDate);
    } else {
      /*
      without this get malformed message?
      Even though empty if?

      //_calendarController.setFocusedDay(new DateTime.now());
      */
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Calendar'),
      ),
      //draw the sidebar menu options
      drawer: new MenuDrawer(),
      //body: SingleChildScrollView(
        body: Column(
          mainAxisSize: MainAxisSize.max,          
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              initialCalendarFormat: CalendarFormat.month,
              onDaySelected: _onDaySelected,
              onVisibleDaysChanged: _onVisibleDaysChanged,
              events: _events,
              calendarStyle: CalendarStyle(
                  //holidayStyle: TextStyle(color: Colors.blue),
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).primaryColor,
                  markersColor: Colors.green[900],

                  //change following 2 for colors of all days on weekends
                  weekendStyle: TextStyle(color: Colors.green),
                  outsideWeekendStyle: TextStyle(color: Colors.green),
                  //markersColor: Colors.green,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,

              daysOfWeekStyle: DaysOfWeekStyle(
                //color of day headers for weekend (Sat, Sun)
                weekendStyle: TextStyle(color: Colors.green),
              ),
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _calendarController,

            ),

            //below is for centered text after the calendar
            const SizedBox(height: 8.0),
            Center(child: Text(
              'Tasks due on ${formatted}',
              style: TextStyle(color: Colors.black,
                fontSize: 16.0, fontWeight: FontWeight.bold,
              ),
            )),

            //following is list of events shown when tap on a day
            Expanded(child: _buildEventList()),
          ],
        ),
      //),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.map((event) => Container(
        decoration: BoxDecoration(
          color: Colors.green,
          boxShadow: [BoxShadow(color: const Color(0xFF000000), blurRadius: 2.0)],
          gradient: new LinearGradient(
              colors: [Colors.green[400], Colors.green[700]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          //border: Border.all(width: 0.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString(),
          style: TextStyle(color: Colors.white)),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }
}


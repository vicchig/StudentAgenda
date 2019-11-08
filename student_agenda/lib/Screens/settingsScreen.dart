import 'package:flutter/material.dart';
import 'package:student_agenda/Utilities/util.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() {
    return SettingsScreenState();
  }
}


class SettingsScreenState extends State<SettingsScreen> {
  final List<String> entries = <String>["Setting1", "Setting2", "Setting3",
                                        "Setting4", "Setting5", "Setting6",
                                        "Setting7", "Setting8", "Setting9"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
        centerTitle: true,
      ),

      // Draw Sidebar menu options
      drawer: new MenuDrawer(),
      
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.white70,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("${entries[index]}") // Can replace this w/ buttons, or toggle switches, etc.
            )
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )
    );
  }
}
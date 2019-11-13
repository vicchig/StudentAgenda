import 'package:flutter/material.dart';
import 'package:student_agenda/Utilities/util.dart';
import '../Utilities/util.dart';

class AddSubtaskScreen extends StatefulWidget {
  @override
  AddSubtaskState createState() {
    return AddSubtaskState();
  }
}

class AddSubtaskState extends State<AddSubtaskScreen> {
  List<String> subTasks = [];
  final TextEditingController subtaskController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Add a subtask"), centerTitle: true),
      drawer: new MenuDrawer(),
      body: new Column(children: <Widget>[
        new TextField(
            controller: subtaskController,
            onSubmitted: (text) {
              if (text != "") {
                subTasks.add(text);
                subtaskController.clear();
                setState(() {});
              }
            },
            decoration: InputDecoration(hintText: "Please enter a subtask")),
        new Expanded(
            child: new ListView.builder(
                itemCount: subTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: ObjectKey(subTasks[index]),
                      onDismissed: (direction) {
                        setState(() {
                          subTasks.removeAt(index);
                        });
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(content: new Text("Subtask removed")));
                      },
                      child:
                          Card(child: ListTile(title: Text(subTasks[index]))),
                      background: new Container(color: Colors.green));
                })),
        new Container(
            width: 50,
            margin: EdgeInsets.all(24),
            child: new CustomMaterialButton(
              onPressed: () {
                if (subtaskController.text != "") {
                  subTasks.add(subtaskController.text);
                  subtaskController.clear();
                  setState(() {});
                }
              },
              colour: Colors.green,
              text: "+",
            ))
      ]),
    );
  }
}

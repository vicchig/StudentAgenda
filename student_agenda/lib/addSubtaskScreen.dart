import 'package:flutter/material.dart';
import 'package:student_agenda/util.dart';

class AddSubtaskScreen extends StatefulWidget {
  @override
  AddSubtaskState createState() {
    return AddSubtaskState();
  }
}

class AddSubtaskState extends State<AddSubtaskScreen> {
  List<String> subTasks = [];
  final TextEditingController subtaskController = new TextEditingController();
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text("Add a subtask"), centerTitle: true),

        drawer: new MenuDrawer(),

        body: new Column(
          children: <Widget>[
            new TextField(
            controller: subtaskController,
              onSubmitted: (text) {
                if (text != "") {
                  id++;
                  subTasks.add(text);
                  subtaskController.clear();
                  setState(() {});
                }
              },

              decoration: InputDecoration(
                hintText: "Please enter a subtask"
              )
            ),
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: subTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible  (
                          key: new Key(id.toString()),
                          onDismissed: (direction) {
                            subTasks.removeAt(index);
                            Scaffold.of(context).showSnackBar(new SnackBar (
                                content: new Text("Subtask removed")
                            ));
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(subTasks[index])
                            )
                          ),
                          background: new Container(
                            color: Colors.green
                          )
                      );
                    }
                )
            )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (subtaskController.text != "") {
            id++;
            subTasks.add(subtaskController.text);
            subtaskController.clear();
            setState(() {});
          }
        }
      ),
    );
  }
}
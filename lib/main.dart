import 'package:flutter/material.dart';
import 'package:gonote/create.dart';
import 'package:gonote/list.dart';
import 'package:gonote/task.dart';

void main() => runApp(NoteApp());

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TODO();
  }
}

class TODO extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteState();
  }
}

class NoteState extends State<TODO> {
  final List<Task> tasks = [];

  void onTaskCreated(String name) {
    setState(() {
      tasks.add(Task(name));
    });
  }

  // A new callback function to toggle task's completion
  void onTaskToggled(Task task) {
    setState(() {
      task.setCompleted(!task.isCompleted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Note',
      initialRoute: '/',
      routes: {
        '/': (context) => NoteList(),
        '/create': (context) => NoteCreate(
          onCreate: onTaskCreated,
        ),
      },
    );
  }
}

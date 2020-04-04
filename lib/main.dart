import 'package:flutter/material.dart';
import 'package:gonote/task.dart';
import 'package:gonote/create.dart';
import 'package:gonote/list.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Note',
      initialRoute: '/',
      routes: {
        '/': (context) => NoteList(tasks: tasks),
        '/create': (context) => NoteCreate(
          onCreate: onTaskCreated,
        ),
      },
    );
  }
}

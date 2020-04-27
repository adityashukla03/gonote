import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:gonote/create.dart';
import 'package:gonote/login.dart';
import 'package:gonote/screens/home.dart';
import 'package:gonote/task.dart';
import 'package:provider/provider.dart';

import './model/user.dart' show CurrentUser;
import './screens/note_editor.dart';

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
    return StreamProvider.value(
      value: FirebaseAuth.instance.onAuthStateChanged
          .map((user) => CurrentUser.create(user)),
      initialData: CurrentUser.initial,
      child: Consumer<CurrentUser>(
        builder: (context, user, _) => MaterialApp(
          title: 'Go Note',
          initialRoute: '/',
          home: user.isInitialValue
              ? Scaffold(body: const SizedBox())
              : user.data != null ? HomeScreen() : LoginScreen(),
          routes: {
            '/create': (context) => NoteCreate(
              onCreate: onTaskCreated,
            ),
            '/note': (context) => NodeEditor(),
          },
        ),
      ),
    );
  }
}

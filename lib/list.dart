import 'package:flutter/material.dart';
import 'package:gonote/task.dart';

class NoteList extends StatelessWidget {

  final List<Task> tasks;

  NoteList({@required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Note'),
      ),
      body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(tasks[index].getName()),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/create'),
          child: Icon(Icons.add)
      ),
    );
  }
}

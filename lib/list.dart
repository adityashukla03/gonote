import 'package:flutter/material.dart';
import 'package:gonote/task.dart';

class NoteList extends StatelessWidget {
  final List<Task> tasks;
  final onToggle;

  NoteList({@required this.tasks, @required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Note'),
      ),
      body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(tasks[index].getName()),
              value: tasks[index].isCompleted(),
              onChanged: (_) => onToggle(tasks[index]),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/create'),
          child: Icon(Icons.add)),
    );
  }
}

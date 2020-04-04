import 'package:flutter/material.dart';

// Since we are handling user input, state is used
class NoteCreate extends StatefulWidget {

  // Callback function that gets called when user submits a new task
  final onCreate;

  NoteCreate({@required this.onCreate});

  @override
  State<StatefulWidget> createState() {
    return NoteCreateState();
  }
}

class NoteCreateState extends State<NoteCreate> {

  // Controller that handles the TextField
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create a task')),
      body: Center(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                // Opens the keyboard automatically
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: 'Enter name for your task'
                  )
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          // Call the callback with the new task name
          widget.onCreate(controller.text);
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}
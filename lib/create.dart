import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final collection = Firestore.instance.collection('tasks');
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
                  decoration:
                      InputDecoration(labelText: 'Enter name for your task')))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          if (controller.text.isNotEmpty) {
            await collection.add(
              {'name': controller.text, 'completed': false},
            );
          } else {
            //TODO: field validation
            print("Empty field");
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}

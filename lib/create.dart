import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import './model/user.dart' show CurrentUser;

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
  final notesCollection = Firestore.instance.collection('notes');

  // Controller that handles the TextField
  final TextEditingController notesTitleTextController =
      TextEditingController();
  final TextEditingController notesContentTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context)?.data;
    final uid = user?.uid;
    return Scaffold(
      appBar: AppBar(title: Text('Create a task')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                controller: notesTitleTextController,
                decoration:
                    InputDecoration(labelText: 'Enter name for your task'),
              ),
              TextField(
                autofocus: true,
                controller: notesContentTextController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          if (notesTitleTextController.text.isNotEmpty) {
            await notesCollection.add(
              {
                'uid': uid,
                'title': notesTitleTextController.text,
                'content': notesContentTextController.text,
              },
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

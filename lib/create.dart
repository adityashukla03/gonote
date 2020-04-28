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
  final _formKey = GlobalKey<FormState>();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty && val.length == 0 ? 'Enter a Note title' : null,
                    autofocus: true,
                    controller: notesTitleTextController,
                    decoration:
                        InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: notesContentTextController,
                    decoration: InputDecoration(labelText: 'Content'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          final timestamp = DateTime.now();
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> data = {
              'uid': uid,
              'title': notesTitleTextController.text,
              'content': notesContentTextController.text,
              'createdAt': timestamp.millisecondsSinceEpoch,
            };
            await notesCollection.add(data);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

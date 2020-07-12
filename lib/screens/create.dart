import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../model/user.dart' show CurrentUser;

// Since we are handling user input, state is used
class NoteCreate extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return NoteCreateState();
  }
}

class NoteCreateState extends State<NoteCreate> {

  final userNotesCollection = Firestore.instance.collection('users');

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
        iconTheme: IconThemeData(
            color: Color(0xC2000000)
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          final timestamp = DateTime.now();
            Map<String, dynamic> data = {
              'uid': uid,
              'title': notesTitleTextController.text,
              'content': notesContentTextController.text,
              'createdAt': timestamp.millisecondsSinceEpoch,
            };
            await userNotesCollection.document(user.uid).collection('notes').add(data);
            Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) => DefaultTextStyle(
    style: TextStyle(
      color: Color(0xC2000000),
      fontSize: 18,
      height: 1.3125,
    ),
    child: Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: _buildNoteDetail(),
      ),
    ),
  );

  Widget _buildNoteDetail() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      TextField(
        controller: notesTitleTextController,
        style: TextStyle(
          color: Color(0xFF202124),
          fontSize: 21,
          height: 19 / 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          hintText: 'Title',
          border: InputBorder.none,
          counter: const SizedBox(),
        ),
        maxLines: null,
        maxLength: 1024,
        textCapitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: 14),
      TextField(
        controller: notesContentTextController,
        style: TextStyle(
          color: Color(0xC2000000),
          fontSize: 18,
          height: 1.3125,
        ),
        decoration: const InputDecoration.collapsed(hintText: 'Content'),
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
      ),
    ],
  );
}

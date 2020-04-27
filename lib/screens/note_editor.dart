import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gonote/model/note.dart';

class NodeEditor extends StatefulWidget {
  const NodeEditor({Key key, this.note}) : super(key: key);

  final Note note;

  @override
  _NodeEditorState createState() => _NodeEditorState(note);
}

class _NodeEditorState extends State<NodeEditor> {
  _NodeEditorState(Note note)
      : this._note = note ?? Note(),
        _originNote = note?.copy() ?? Note(),
        this._titleTextController = TextEditingController(text: note?.title),
        this._contentTextController =
            TextEditingController(text: note?.content);

  final Note _note;
  final Note _originNote;

  Color get _noteColor => _note.color ?? Colors.white;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<Note> _noteSubscription;
  final TextEditingController _titleTextController;
  final TextEditingController _contentTextController;

  /// If the note is modified.
  bool get _isDirty => _note != _originNote;

  @override
  void initState() {
    super.initState();
    _titleTextController
        .addListener(() => _note.title = _titleTextController.text);
    _contentTextController
        .addListener(() => _note.content = _contentTextController.text);
  }

  @override
  void dispose() {
    _noteSubscription?.cancel();
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor"),
      ),
      body: Center(
        child: Text(
          "Developing Editor page........",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

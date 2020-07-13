import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gonote/model/note.dart';
import 'package:provider/provider.dart';

import '../model/user.dart' show CurrentUser;
import 'package:gonote/model/note.dart' show Note;
import '../service/notes_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gonote/widget/delet_btn.dart';

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

//  final userNotesCollection = Firestore.instance.collection('users');
//  final notesCollection = Firestore.instance.collection('notes');

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
    final uid = Provider.of<CurrentUser>(context).data.uid;
    return SafeArea(
      child: ChangeNotifierProvider.value(
        value: _note,
        child: Consumer<Note>(
          builder: (_, __, ___) => Hero(
            tag: 'NoteItem${_note.id}',
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.white,
                appBarTheme: Theme.of(context).appBarTheme.copyWith(
                      elevation: 0,
                      iconTheme: IconThemeData(
                        color: Color(0xC2000000),
                      ),
                    ),
                scaffoldBackgroundColor: Colors.white,
                bottomAppBarColor: Colors.white,
              ),
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text(
                    "Editor",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    DeleteBtn(note: _originNote, atDetailScreen: true),
                  ],
                ),
                body: _buildBody(context, uid),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String uid) => DefaultTextStyle(
        style: TextStyle(
          color: Color(0xC2000000),
          fontSize: 18,
          height: 1.3125,
        ),
        child: WillPopScope(
          onWillPop: () => _onPop(uid),
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: _buildNoteDetail(),
            ),
          ),
        ),
      );

  Widget _buildNoteDetail() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _titleTextController,
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
            controller: _contentTextController,
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

  Future<bool> _onPop(String uid) {
    if (_isDirty && (_note.id != null || _note.isNotEmpty)) {
      _note
        ..modifiedAt = DateTime.now()
        ..saveToFireStore(uid);
    }
    return Future.value(true);
  }
}

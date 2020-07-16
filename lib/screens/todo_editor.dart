import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gonote/main.dart';
import 'package:gonote/model/todo.dart';
import 'package:provider/provider.dart';

import '../model/user.dart' show CurrentUser;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gonote/widget/delet_btn.dart';

class TodoEditor extends StatefulWidget {

  const TodoEditor({Key key, this.todo}) : super(key: key);

  final Todo todo;

  @override
  _TodoEditorState createState() => _TodoEditorState(todo);

}

class _TodoEditorState extends State<TodoEditor> {

  _TodoEditorState(Todo todo)
      : this._todo = todo ?? Todo(),
        this._originTodo = todo.copyWith() ?? Todo(),
        this._contentTextController =
        TextEditingController(text: todo?.name);

  final Todo _todo;
  final Todo _originTodo;

  final userTodoCollection = Firestore.instance.collection('users');

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<Todo> _todoSubscription;
  final TextEditingController _contentTextController;

  /// If the note is modified.
  bool get _isDirty => _todo != _originTodo;

  @override
  void initState() {
    super.initState();
    _contentTextController
        .addListener(() => _todo.name = _contentTextController.text);
  }

  @override
  void dispose() {
    _todoSubscription?.cancel();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<CurrentUser>(context).data.uid;
    return SafeArea(
      child: ChangeNotifierProvider.value(
        value: _todo,
        child: Consumer<Todo>(
          builder: (_, __, ___) => Hero(
            tag: 'Todo${_todo.id}',
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
                    DeleteBtn(todo: _originTodo, note: null, atDetailScreen: true),
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
          child: _buildTodoDetail(),
        ),
      ),
    ),
  );

  Widget _buildTodoDetail() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
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

  Future<bool> _onPop(String uid) async {
    if ((_todo.id.isNotEmpty || _todo.name.isNotEmpty) && (_todo.name != _originTodo.name)) {
      _todo
        ..modifiedAt = DateTime.now();
      Map<String, dynamic> data = {
        'uid': uid,
        'name': _todo.name,
        'completed': _todo.completed,
        'modifiedAt':_todo.modifiedAt,
      };
      userTodoCollection.document(uid).collection('todo').document(_todo.id).updateData(data);
    }
    return Future.value(true);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gonote/model/note.dart';
import 'package:gonote/model/todo.dart';
import 'package:provider/provider.dart';
import '../model/user.dart' show CurrentUser;

import 'package:gonote/widget/delet_btn.dart';
import 'package:gonote/screens/todo_editor.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  bool todoCheck = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context)?.data;
    final uid = user?.uid;
    final userTodoCollection = Firestore.instance.collection('users').document(uid).collection('todo');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Color(0xC2000000)),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userTodoCollection.where('uid', isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          // Handling errors from firebase
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return ListView(
                children: snapshot.data.documents.map(
                  (document) {
                    return
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.,
                        children: <Widget>[
                          Checkbox(
                            value: document['completed'],
                            onChanged: (newValue) => userTodoCollection.document(document.documentID).updateData(
                              {'completed': newValue},),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(document['name']),
                            ),
                          ),
                          DeleteBtn(todo: Todo(id:document.documentID, name:document['name'], completed:document['completed'], createdAt:document['createdAt'], modifiedAt:document['modifiedAt']), note: null, atDetailScreen: true),
                          IconButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, '/todo_edit', arguments: {'todo': Todo(id:document.documentID, name:document['name'], completed:document['completed'], createdAt:document['createdAt'], modifiedAt:document['modifiedAt'])});
                            },
                            icon: Icon(Icons.edit),
                            //alignment: Alignment.centerRight,
                          )
                        ],
                      );
                  },
                ).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/createtodo'),
          child: Icon(Icons.add)),
    );
  }
}

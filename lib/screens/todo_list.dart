import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart' show CurrentUser;

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
                    return CheckboxListTile(
                      value: document['completed'],
                      title: Text(document['name']),
                      // Updating the database on task completion
                      onChanged: (newValue) =>
                          userTodoCollection.document(document.documentID).updateData(
                        {'completed': newValue},
                      ),
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

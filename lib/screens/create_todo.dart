import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../model/user.dart' show CurrentUser;

class TodoCreate extends StatefulWidget {
  TodoCreate();

  @override
  State<StatefulWidget> createState() {
    return TodoCreateState();
  }
}

class TodoCreateState extends State<TodoCreate> {
  final _formKey = GlobalKey<FormState>();

  final userTodoCollection = Firestore.instance.collection('users');

  // Controller that handles the TextField
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context)?.data;
    final uid = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Todo',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Color(0xC2000000)),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(16),
            child: TextFormField(
                autofocus: true,
                validator: (val) => val.isEmpty ? 'Please enter todo' : null,
                controller: controller,
                decoration: InputDecoration(labelText: 'Enter Todo'))),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> data = {
              'uid': uid,
              'name': controller.text,
              'completed': false,
              'createdAt': DateTime.now(),
              'modifiedAt': DateTime.now(),
            };
            await userTodoCollection.document(user.uid).collection('todo').add(data);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './widget/drawer.dart';

class NoteList extends StatelessWidget {

  final collection = Firestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Note'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      title: Text(document['name']),
                      value: document['completed'],
                      // Updating the database on task completion
                      onChanged: (newValue) =>
                          collection.document(document.documentID).updateData(
                        {'completed': newValue},
                      ),
                    );
                  },
                ).toList(),
              );
          }
        },
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create'),
        child: Icon(Icons.add),
      ),
    );
  }
}

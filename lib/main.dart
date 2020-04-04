import 'package:flutter/material.dart';

void main() => runApp(TODOApp());

class TODOApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Go Note',
        home: Scaffold(
          // AppBar is the header in the top of the screen
            appBar: AppBar(
              title: Text('Go Note'),
            ),
            body: Center(
                child: Text('Notes')
            )
        )
    );
  }
}
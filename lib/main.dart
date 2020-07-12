import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:gonote/screens/create.dart';
import 'package:gonote/screens/create_todo.dart';
import 'package:gonote/screens/home.dart';
import 'package:gonote/screens/login.dart';
import 'package:provider/provider.dart';

import './model/user.dart' show CurrentUser;
import './screens/note_editor.dart';
import 'screens/settings_screen.dart';
import 'screens/todo_list.dart';

import 'package:flutter/services.dart';

void main() => runApp(NoteApp());

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return TODO();
  }
}

class TODO extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteState();
  }
}

class NoteState extends State<TODO> {
  @override
  Widget build(BuildContext context) => StreamProvider.value(
        value: FirebaseAuth.instance.onAuthStateChanged
            .map((user) => CurrentUser.create(user)),
        initialData: CurrentUser.initial,
        child: Consumer<CurrentUser>(
          builder: (context, user, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Go Note',
            initialRoute: '/',
            home: user.isInitialValue
                ? Scaffold(body: const SizedBox())
                : user.data != null ? HomeScreen() : LoginScreen(),
            routes: {
              '/settings': (_) => SettingsScreen(),
              '/todo': (_) => TodoList(),
              '/createtodo': (_) => TodoCreate(),
            },
            onGenerateRoute: _generateRoute,
          ),
        ),
      );

  Route _generateRoute(RouteSettings settings) {
    try {
      return _doGenerateRoute(settings);
    } catch (e, s) {
      debugPrint("failed to generate route for $settings: $e $s");
      return null;
    }
  }

  Route _doGenerateRoute(RouteSettings settings) {
    if (settings.name?.isNotEmpty != true) return null;

    final uri = Uri.parse(settings.name);
    final path = uri.path ?? '';
    // final q = uri.queryParameters ?? <String, String>{};
    switch (path) {
      case '/note': {
          final note = (settings.arguments as Map ?? {})['note'];
          return _buildRoute(settings, (_) => NodeEditor(note: note));
        }
      case '/create': {
          return _buildRoute(settings, (_) => NoteCreate());
        }
      default:
        return null;
    }
  }

  Route _buildRoute(RouteSettings settings, WidgetBuilder builder) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: builder,
      );
}

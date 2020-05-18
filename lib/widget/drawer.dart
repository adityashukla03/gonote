import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _drawerHeader(context),
          buildListTile("Notes", Icons.assignment, () {
            Navigator.of(context).pop();
          }),
          Divider(height: 10, color: Colors.red),
          buildListTile("Logout", Icons.power_settings_new, () async {
            Navigator.of(context).pop();
            _signOut();
          }),
        ],
      ),
    );
  }

  Widget _drawerHeader(BuildContext context) => SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Color(0xFF61656A),
                fontSize: 36,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
              children: [
                TextSpan(
                  text: 'Go',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: 'Note',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

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
          Container(
            height: 150,
            child: UserAccountsDrawerHeader(
              accountName: Text("Sumit"),
              accountEmail: Text("sumit.thakur@gorapid.io"),
            ),
          ),

          buildListTile("Notes", Icons.history, () {
            Navigator.of(context).pop();
          }),

          Divider(height: 10, color: Colors.red),
          buildListTile("Logout", Icons.settings, () async {
            Navigator.of(context).pop();
            _signOut();
          }),
        ],
      ),
    );
  }
}

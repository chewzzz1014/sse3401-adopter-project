import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarMenuButton extends StatefulWidget {
  const AppBarMenuButton({super.key});

  @override
  State<AppBarMenuButton> createState() => _AppBarMenuButtonState();
}

class _AppBarMenuButtonState extends State<AppBarMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings),
      onSelected: (String result) {
        print('Selected: $result');
        switch(result) {
          case 'profile':
            Navigator.pushNamed(context, '/profile');
          case 'logout':
            print('logout');
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/auth_service.dart';

class AppBarMenuButton extends StatefulWidget {
  const AppBarMenuButton({super.key});

  @override
  State<AppBarMenuButton> createState() => _AppBarMenuButtonState();
}

class _AppBarMenuButtonState extends State<AppBarMenuButton> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
  }

  Future<void> _logout() async {
    bool result = await _authService.logout();
    if(result) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings),
      onSelected: (String result) async {
        print('Selected: $result');
        switch (result) {
          case 'profile':
            Navigator.pushNamed(context, '/profile');
          case 'logout':
            await _logout();
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

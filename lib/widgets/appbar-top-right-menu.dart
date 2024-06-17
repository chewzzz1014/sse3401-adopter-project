import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/services/alert_service.dart';
import 'package:sse3401_adopter_project/services/navigation_service.dart';

import '../services/auth_service.dart';

class AppBarMenuButton extends StatefulWidget {
  const AppBarMenuButton({super.key});

  @override
  State<AppBarMenuButton> createState() => _AppBarMenuButtonState();
}

class _AppBarMenuButtonState extends State<AppBarMenuButton> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  Future<void> _logout() async {
    bool result = await _authService.logout();
    if (result) {
      _alertService.showToast(
        text: 'Successfully logged out',
        icon: Icons.check,
      );
      _navigationService.pushReplacementNamed('/login');
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
            _navigationService.pushNamed('/profile');
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

import 'package:flutter/cupertino.dart';
import 'package:sse3401_adopter_project/screens/auth/login.dart';
import 'package:sse3401_adopter_project/screens/auth/signup.dart';

import '../main.dart';
import '../screens/add-animal.dart';
import '../screens/user-profile.dart';

class NavigationService {

  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(),
    '/addAnimal': (context) => const AddPetForm(),
    '/home': (context) => const MyHomePage(),
    '/profile': (context) => const UserProfilePage(),
    '/signup': (context) => const SignUpPage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
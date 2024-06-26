import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sse3401_adopter_project/screens/auth/login.dart';
import 'package:sse3401_adopter_project/screens/auth/signup.dart';
import 'package:sse3401_adopter_project/screens/pet/animal-details.dart';

import '../main.dart';
import '../screens/add-animal.dart';
import '../screens/user-profile.dart';

class NavigationService {

  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(),
    '/addAnimal': (context) => const AddPetPage(),
    '/home': (context) => const MyHomePage(),
    '/profile': (context) => UserProfilePage(),
    '/signup': (context) => const SignUpPage(),
    '/animalDetail': (context) => const AnimalDetailsPage(),
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

  void push(MaterialPageRoute route) {
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushNamedArgument(String routeName, {Object? arguments}) {
    _navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
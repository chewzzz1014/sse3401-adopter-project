import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/constants.dart';
import 'package:sse3401_adopter_project/services/alert_service.dart';
import 'package:sse3401_adopter_project/services/auth_service.dart';
import 'package:sse3401_adopter_project/services/navigation_service.dart';
import 'package:sse3401_adopter_project/services/storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late StorageService _storageService;

  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? iconImage;

  @override
  void initState() {
    super.initState();
    _loadIconImage();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _storageService = _getIt.get<StorageService>();
  }

  Future<void> _loadIconImage() async {
    try {
      String? iconImageURL = await _storageService.loadLogoImage();
      if (iconImageURL!.isNotEmpty) {
        setState(() {
          iconImage = iconImageURL;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!EMAIL_REGEX.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildUI(),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool result = await _authService.login(email!, password!);
      if (result) {
        _navigationService.pushReplacementNamed('/home');
      } else {
        _alertService.showToast(
          text: 'Failed to login, please try again',
          icon: Icons.error,
        );
      }
    }
  }

  Widget _buildUI() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: iconImage == null
                      ? const CircularProgressIndicator()
                      : Image.network(
                          iconImage!,
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    suffix: Text('Email'),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail,
                  onSaved: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePassword,
                  onSaved: (value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    _navigationService.pushReplacementNamed('/signup');
                  },
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

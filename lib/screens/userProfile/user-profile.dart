import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/constants.dart';
import 'package:sse3401_adopter_project/models/user_profile.dart';
import 'package:sse3401_adopter_project/services/database_service.dart';
import 'package:sse3401_adopter_project/services/media_service.dart';
import 'package:sse3401_adopter_project/services/storage_service.dart';

import '../../../services/alert_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/navigation_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late MediaService _mediaService;
  late StorageService _storageService;
  late DatabaseService _databaseService;

  final _formKey = GlobalKey<FormState>();
  File? selectedImage;
  UserProfile? currentUser;
  String? _username;
  String? _password;
  String? _email;
  String? _phoneNumber;
  String? _age;
  bool isUploadedImageLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    // currentUser = _databaseService.getCurrentUser(uid: _authService.user.uid!);}

  Future<void> _submitForm() async {
    setState(() {
      isUploadedImageLoading = true;
    });
    try {
      if (_formKey.currentState?.validate() ?? false && selectedImage != null) {
        _formKey.currentState?.save();
        bool result = await _authService.signup(_email!, _password!);
        if (result) {
          String? profileURL = await _storageService.uploadUserProfilePicture(
            file: selectedImage!,
            uid: _authService.user!.uid,
          );
          if (profileURL != null) {
            await _databaseService.createUserProfile(
                userProfile: UserProfile(
                  uid: _authService.user!.uid,
                  username: _username,
                  pfpURL: profileURL,
                  phoneNumber: _phoneNumber,
                  age: _age,
                ));
            _alertService.showToast(
              text: "User registered successfully",
              icon: Icons.check,
            );
            _navigationService.pushReplacementNamed('/home');
          } else {
            throw Exception("Unable to upload user profile picture");
          }
        } else {
          throw Exception("Unable to register user");
        }
        print(result);
      }
    } catch (e) {
      print(e);
      _alertService.showToast(
        text: "Failed to register. Please try again",
        icon: Icons.error,
      );
    }
    setState(() {
      isUploadedImageLoading = false;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!EMAIL_REGEX.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!PHONE_REGEX.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return 'Please enter a valid age';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isUploadedImageLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Center(child: Text('Sign Up')),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
              const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      File? file = await _mediaService.getImageFromGallery();
                      if (file != null) {
                        setState(() {
                          selectedImage = file;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : NetworkImage(USER_PLACEHOLDER_IMG) as ImageProvider,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _username = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _email = value,
                    validator: _validateEmail,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    onSaved: (value) => _password = value,
                    validator: _validatePassword,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _phoneNumber = value,
                    validator: _validatePhoneNumber,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _age = value,
                    validator: _validateAge,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

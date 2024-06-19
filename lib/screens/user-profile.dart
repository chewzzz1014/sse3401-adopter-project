import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/constants.dart';
import 'package:sse3401_adopter_project/services/alert_service.dart';
import 'package:sse3401_adopter_project/services/database_service.dart';
import 'package:sse3401_adopter_project/services/navigation_service.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/media_service.dart';
import '../services/storage_service.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late StorageService _storageService;
  late MediaService _mediaService;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  final _formKey = GlobalKey<FormState>();

  UserProfile? _userProfile;
  File? _selectedImage;
  String? _username;
  String? _pfpURL;
  String? _phoneNumber;
  String? _age;
  String? _email;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _mediaService = _getIt.get<MediaService>();
    _databaseService = _getIt.get<DatabaseService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final doc = await _databaseService.getCurrentUserProfile();
    if (doc.exists) {
      setState(() {
        isLoading = false;
        _userProfile = doc.data()!;
        _email = _authService.user?.email;
        _username = _userProfile?.username;
        _pfpURL = _userProfile?.pfpURL;
        _phoneNumber = _userProfile?.phoneNumber;
        _age = _userProfile?.age;
      });
    }
  }

  bool _hasMadeChanges() {
    return (_selectedImage != null ||
        _username != _userProfile?.username ||
        _phoneNumber != _userProfile?.phoneNumber ||
        _age != _userProfile?.age);
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      // only update when they're changed
      if (_hasMadeChanges()) {
        setState(() {
          isLoading = true;
        });

        final userId = _authService.user!.uid;
        String? imageUrl = _pfpURL;

        if (_selectedImage != null) {
          imageUrl = await _storageService.uploadUserProfilePicture(
            file: _selectedImage!,
            uid: _authService.user!.uid,
          );
        }

        final userProfile = _userProfile!.copyWith(
          username: _username,
          phoneNumber: _phoneNumber,
          age: _age,
          pfpURL: imageUrl,
        );

        await _databaseService.updateUserProfile(userId, userProfile);


        _alertService.showToast(
          text: 'Profile updated successfully!',
          icon: Icons.check,
        );

        _fetchUserProfile(); // update the latest user profile data
      }
    } catch (e) {
      _alertService.showToast(
        text: 'Failed to update profile. Please try again',
        icon: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(child: Text('Profile')),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              File? file =
                                  await _mediaService.getImageFromGallery();
                              if (file != null) {
                                setState(() {
                                  _selectedImage = file;
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.2,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : NetworkImage(_pfpURL!.isEmpty
                                      ? USER_PLACEHOLDER_IMG
                                      : _pfpURL!) as ImageProvider,
                            ),
                          ),
                          TextFormField(
                            initialValue: _email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            enabled: false,
                          ),
                          TextFormField(
                            initialValue: _username,
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
                            initialValue: _phoneNumber,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            onSaved: (value) => _phoneNumber = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!PHONE_REGEX.hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                              initialValue: _age,
                              decoration: const InputDecoration(
                                labelText: 'Age',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _age = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your age';
                                }
                                final age = int.tryParse(value);
                                if (age == null || age <= 0) {
                                  return 'Please enter a valid age';
                                }
                                return null;
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _updateUserProfile,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  _navigationService.goBack();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
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

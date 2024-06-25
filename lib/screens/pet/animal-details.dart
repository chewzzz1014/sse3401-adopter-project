import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/models/animal.dart';

import '../../services/alert_service.dart';
import '../../services/database_service.dart';
import '../../services/navigation_service.dart';
import '../../services/storage_service.dart';
import '../add-animal.dart';

class AnimalDetailsPage extends StatefulWidget {
  const AnimalDetailsPage({
    super.key,
  });

  @override
  State<AnimalDetailsPage> createState() => _AnimalDetailsPageState();
}

class _AnimalDetailsPageState extends State<AnimalDetailsPage> {
  final GetIt _getIt = GetIt.instance;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  final _formKey = GlobalKey<FormState>();

  bool _isFormValid = false;

  Animal? _animalDetail;
  File? _pickedImage;
  String? _petName;
  String? _size;
  int? _age;
  String? _description;
  String? _animalImageUrl;
  List<String>? _personality;
  bool isLoading = false;

  PlatformFile? pickedPicture;

  @override
  void initState() {
    super.initState();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _fetchAnimalDetail();
  }

  Future<void> _fetchAnimalDetail() async {
    final String documentId = ModalRoute.of(context)!.settings.arguments as String;
    final doc = await _databaseService.getCurrentAnimalProfile(documentId);
    if (doc.exists) {
      setState(() {
        isLoading = false;
        _animalDetail = doc.data()!;
        _petName = _animalDetail?.name;
        _size = _animalDetail?.size;
        _age = _animalDetail?.age;
        _description = _animalDetail?.description;
        _animalImageUrl = _animalDetail?.imageUrl;
        _personality = _animalDetail?.personality;
      });
    }
  }

  bool _hasMadeChanges() {
    return (_pickedImage != null ||
        _petName != _animalDetail?.name ||
        _size != _animalDetail?.size ||
        _age != _animalDetail?.age ||
        _description != _animalDetail?.description ||
        _personality != _animalDetail?.personality);
  }

  Future<void> _updateAnimalDetail() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      // only update when they're changed
      if (_hasMadeChanges()) {
        setState(() {
          isLoading = true;
        });

        String? imageUrl = _animalImageUrl;

        if (_pickedImage != null) {
          imageUrl = await _storageService.uploadAnimalsImage(
            file: File(_pickedImage!.path),
            petName: _petName!,
          );
        }

        final animalDetail = _animalDetail!.copyWith(
          name: _petName,
          size: _size,
          age: _age,
          imageURL: imageUrl,
          description: _description,
          personality: _personality
        );

        final String documentId = ModalRoute.of(context)!.settings.arguments as String;

        await _databaseService.updateAnimalDetail(documentId, animalDetail);


        _alertService.showToast(
          text: 'Animal details updated successfully!',
          icon: Icons.check,
        );

        _fetchAnimalDetail(); // update the latest user profile data
      }
    } catch (e) {
      _alertService.showToast(
        text: 'Failed to update animal detail. Please try again',
        icon: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Placeholder();
  }
}

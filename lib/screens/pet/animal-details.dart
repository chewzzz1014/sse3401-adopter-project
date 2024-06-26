import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sse3401_adopter_project/models/animal.dart';
import 'package:sse3401_adopter_project/services/auth_service.dart';

import '../../constants.dart';
import '../../services/alert_service.dart';
import '../../services/database_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/multi_select_tags_drop_down.dart';
import '../../widgets/pet-personality-badge.dart';
import '../add-animal.dart';
import '../../constants.dart' as Constants;

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
  late AlertService _alertService;
  late AuthService _authService;
  final _formKey = GlobalKey<FormState>();

  Animal? _animalDetail;
  File? _pickedImage;
  String? _ownerId;
  String? _petName;
  String? _size;
  int? _age;
  String? _description;
  String? _animalImageUrl;
  List<String>? _personality;
  bool isLoading = false;
  bool isOwner = false;

  PlatformFile? pickedPicture;

  final MultiSelectController _multiDropdownController =
  MultiSelectController();
  static const List<String> _initialTags = Constants.personalityTags;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _fetchAnimalDetail();
      _isInitialized = true;
      _multiDropdownController.setOptions(_initialTags.map((tag) {
        return ValueItem<String>(
          label: tag,
          value: tag,
        );
      }).toList());

    }
  }

  bool checkIfOwner() {
    final currentUserId = _authService.user!.uid;
    print(_ownerId);
    print(currentUserId);
    return _ownerId == currentUserId;
  }

  Future<void> _fetchAnimalDetail() async {
    setState(() {
      isLoading = true;
    });
    final String documentId = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    final doc = await _databaseService.getCurrentAnimalProfile(documentId);
    if (doc.exists) {
      setState(() {
        isLoading = false;
        _animalDetail = doc.data()!;
        print(_animalDetail);
        _ownerId = _animalDetail?.ownerId;
        _petName = _animalDetail?.name;
        _size = _animalDetail?.size;
        _age = _animalDetail?.age;
        _description = _animalDetail?.description;
        _animalImageUrl = _animalDetail?.imageUrl;
        _personality = _animalDetail?.personality ?? [];
        _multiDropdownController.setSelectedOptions(
            _personality!.map((tag) {
              return ValueItem(label: tag, value: tag);
            }).toList()
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose the controllers
    _multiDropdownController.dispose();
  }

  bool _hasMadeChanges() {
    print("_petName != _animalDetail?.name: ${_petName != _animalDetail?.name}");
    bool hasChanges =  (_pickedImage != null ||
        _petName != _animalDetail?.name ||
        _size != _animalDetail?.size ||
        _age != _animalDetail?.age ||
        _description != _animalDetail?.description ||
        _personality != _animalDetail?.personality);

    print(hasChanges);
    return hasChanges;
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
        print("update");

        String? imageUrl = _animalImageUrl;

        if (_pickedImage != null) {
          imageUrl = await _storageService.uploadAnimalsImage(
            file: File(_pickedImage!.path),
            petName: _petName!,
          );
        }

        final List<String> selectedTags = _multiDropdownController.selectedOptions.map((item) => item.value.toString()).toList();
        final List<String> nonNullSelectedTags = selectedTags.whereType<String>().toList();
        _personality = nonNullSelectedTags;

        final animalDetail = _animalDetail!.copyWith(
          name: _petName,
          size: _size,
          age: _age,
          imageURL: imageUrl,
          description: _description,
          personality: _personality
        );
        print(_personality);

        final String documentId = ModalRoute.of(context)!.settings.arguments as String;

        await _databaseService.updateAnimalDetail(documentId, animalDetail);


        _alertService.showToast(
          text: 'Animal details updated successfully!',
          icon: Icons.check,
        );

        _fetchAnimalDetail(); // update the latest user profile data
        Navigator.pop(context);

      }
    } catch (e) {
      _alertService.showToast(
        text: 'Failed to update animal detail. Please try again',
        icon: Icons.error,
      );
      Navigator.pop(context);
    }
  }

  Future uploadImage() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isDenied) {
      return _alertService.showToast(text: "Access to storage denied");
    }

    final file = await FilePicker.platform.pickFiles();

    if (file == null) return;

    setState(() {
      pickedPicture = file.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    isOwner = checkIfOwner();

    Sex _gender;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(child: Text('Animal Details'),),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator(),)
        : _animalDetail == null
          ? const Center(child: CircularProgressIndicator(),)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        initialValue: _petName,
                        onSaved: (value) => _petName = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the pet\'s name!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Pet\'s Name',
                            labelStyle: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500)
                        ),
                        enabled: isOwner,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 80,
                              child: ListTileTheme(
                                horizontalTitleGap: 0,
                                child: RadioListTile<Sex>(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    "Male",
                                    style: GoogleFonts.inter(
                                        fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  value: Sex.Male,
                                  groupValue: _gender = _animalDetail?.gender == 'Male' ? Sex.Male : Sex.Female,
                                  onChanged: null,
                                ),
                              )),
                          SizedBox(
                              width: 100,
                              child: ListTileTheme(
                                horizontalTitleGap: 0,
                                child: RadioListTile<Sex>(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    "Female",
                                    style: GoogleFonts.inter(
                                        fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  value: Sex.Female,
                                  groupValue: _gender = _animalDetail?.gender == 'Male' ? Sex.Male : Sex.Female,
                                  onChanged: null,
                                ),
                              )),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  labelText: _animalDetail?.type,
                                  labelStyle: GoogleFonts.inter(
                                      fontSize: 16, fontWeight: FontWeight.w500)),
                              items: animalTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _size,
                              decoration: InputDecoration(
                                  labelText: 'Size (optional)',
                                  hintText: 'In centimeter (cm)',
                                  labelStyle: GoogleFonts.inter(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 16, fontWeight: FontWeight.w500)),
                              onSaved: (value) {
                                // _size = value!;
                                setState(() {
                                  _size = value;
                                });
                              },
                              enabled: isOwner,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              initialValue: _age.toString(),
                              onSaved: (value) => _age = int.tryParse(value!),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the age!';
                                }
                                if(int.tryParse(value) == null) {
                                  return 'Please enter a valid age';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Age',
                                labelStyle: GoogleFonts.inter(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              enabled: isOwner,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TextFormField(
                        initialValue: _description,
                        onSaved: (value) => _description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some description!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Pet's description",
                            labelStyle: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        maxLines: 3,
                        enabled: isOwner,
                      ),
                    ),
                    Text(
                      "Pet's personality(s)",
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    if (isOwner)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: MultiSelectTagsDropDown(
                            multiDropdownController: _multiDropdownController),
                      ),
                    if(!isOwner)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Wrap(
                          children: _personality!
                              .map((p) => PersonalityBadge(personality: p))
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isOwner ? ListTile(
                        leading: ElevatedButton(
                          onPressed: () async {
                            File? file =
                            await uploadImage();
                            if (file != null) {
                              setState(() {
                                _pickedImage = file;
                              });
                            }
                          },
                          child: Text(
                            'Upload a picture of your pet!',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        trailing: pickedPicture != null ? const Icon(Icons.check) : const Icon(Icons.close),
                      ) : Container(),
                    ),
                    if (pickedPicture != null)
                      SizedBox(
                        width: 200,
                        child: Image.file(
                          File(pickedPicture!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (_animalImageUrl != null)
                      SizedBox(
                        width: 200,
                        child: Image.network(
                          _animalImageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(isOwner)
                          ElevatedButton(
                            onPressed: _updateAnimalDetail,
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        const SizedBox(width: 16.0),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
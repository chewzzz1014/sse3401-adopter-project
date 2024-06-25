import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sse3401_adopter_project/models/animal.dart';
import 'package:sse3401_adopter_project/widgets/multi_select_tags_drop_down.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart' as Constants;
import '../constants.dart';
import '../services/alert_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';
import '../services/storage_service.dart';
import '../widgets/loading-dialog.dart';

enum Sex { Male, Female }

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final GetIt _getIt = GetIt.instance;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;
  late AuthService _authService;

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  late String _petName = '';
  late Sex _sex = Sex.Male;
  late String _type = '';
  String _size = '';
  late String _age = '';
  late String _description = '';
  late String pickedImageUrl;

  PlatformFile? pickedPicture;
  PlatformFile? pickedHealthDoc;

  final MultiSelectController _multiDropdownController =
      MultiSelectController();
  // Define TextEditingController for each text field
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  static const List<String> _initialTags = Constants.personalityTags;

  @override
  void initState() {
    super.initState();
    _multiDropdownController.setOptions(_initialTags.map((tag) {
      return ValueItem<String>(
        label: tag,
        value: tag,
      );
    }).toList());
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose the controllers
    _petNameController.dispose();
    _sizeController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _multiDropdownController.dispose();
  }

  Future uploadImage() async {
    PermissionStatus status = await Permission.storage.request();
    print('$status');
    if (status.isDenied) {
      return _alertService.showToast(text: "Access to storage denied");
    }

    final file = await FilePicker.platform.pickFiles();

    if (file == null) return;

    setState(() {
      pickedPicture = file.files.first;
    });
  }

  Future uploadHealthDoc() async {
    PermissionStatus status = await Permission.storage.request();
    debugPrint('>>>Status $status');
    if (status.isDenied) {
      return _alertService.showToast(text: "Access to storage denied");
    }

    final file = await FilePicker.platform.pickFiles();

    if (file == null) return;

    setState(() {
      pickedHealthDoc = file.files.first;
    });
  }

  Future<void> _validateInputs() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save(); // save each form

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingDialog();
        },
      );

      try {
        final imageUrl = await _storageService
            .uploadAnimalsImage(file: File(pickedPicture!.path!), petName: _petName);
        setState(() {
          pickedImageUrl = imageUrl!;
        });
        _storageService.uploadHealthDoc(file: File(pickedHealthDoc!.path!), petName: _petName);

        final List<String> selectedTags = _multiDropdownController.selectedOptions.map((item) => item.value.toString()).toList();
        final List<String> nonNullSelectedTags = selectedTags.whereType<String>().toList();
        final uid = _authService.user!.uid;
        const petId = Uuid();

        // Debug print the value of _age
        print('Age value: $_age');

        int parsedAge;
        try {
          parsedAge = int.parse(_age);
        } catch (e) {
          print('Error parsing age: $e');
          _alertService.showToast(text: "Invalid age entered");
          return;
        }

        Animal newAnimal = Animal(ownerId: uid, id: petId.v4(),
            imageUrl: imageUrl, name: _petName, gender: _sex.name,
            type: _type, size: _size, age: parsedAge, description: _description,
            personality: nonNullSelectedTags, isAdopted: false);

        await _databaseService.createAnimalProfile(animal: newAnimal);

        if (context.mounted) Navigator.of(context).pop(); // Close the loading dialog
        if (context.mounted) Navigator.of(context).pop();
      } catch (e) {
        if (context.mounted) Navigator.of(context).pop(); // Close the loading dialog
        _alertService.showToast(text: "An error occurred. Please try again.");
        print(e);
      }
    } else {
      _alertService.showToast(text: "Form is invalid.");
    }
  }

  void _updateFormState() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Add A Pet !',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: _updateFormState,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextFormField(
                  controller: _petNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the pet\'s name!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Pet\'s Name',
                      labelStyle: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  onSaved: (value) {
                    _petName = value!;
                  },
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
                            groupValue: _sex,
                            onChanged: (Sex? value) {
                              setState(() {
                                _sex = value!;
                              });
                            },
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
                            groupValue: _sex,
                            onChanged: (Sex? value) {
                              setState(() {
                                _sex = value!;
                              });
                            },
                          ),
                        )),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a type!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Type',
                            labelStyle: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        items: animalTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                          });
                        },
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
                        controller: _sizeController,
                        decoration: InputDecoration(
                            labelText: 'Size (optional)',
                            hintText: 'In centimeter (cm)',
                            labelStyle: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            hintStyle: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        onSaved: (value) {
                          _size = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the age!';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Age',
                          labelStyle: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        onSaved: (value) {
                          _age = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some description!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Describe your pet!',
                      labelStyle: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  maxLines: 3,
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
              ),
              Text(
                'Add some personality tags to your pet!',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: MultiSelectTagsDropDown(
                    multiDropdownController: _multiDropdownController),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: ElevatedButton(
                    onPressed: uploadImage,
                    child: Text(
                      'Upload a picture of your pet!',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  trailing: pickedPicture != null ? const Icon(Icons.check) : const Icon(Icons.close),
                ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: ElevatedButton(
                    onPressed: uploadHealthDoc,
                    child: Text(
                      'Upload health documents!',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  trailing: pickedHealthDoc != null ? const Icon(Icons.check) : const Icon(Icons.close),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isFormValid ? _validateInputs : null,
                    child: Text(
                      'Submit',
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

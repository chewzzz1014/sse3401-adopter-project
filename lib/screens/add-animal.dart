import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:sse3401_adopter_project/widgets/multi_select_tags_drop_down.dart';

import '../constants.dart' as Constants;

enum Sex { Male, Female }

final FirebaseAuth auth = FirebaseAuth.instance;

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  String petName = '';
  Sex sex = Sex.Male;
  String type = '';
  String size = '';
  String age = '';
  String description = '';
  String tags = '';

  final uid = auth.currentUser!.uid;

  PlatformFile? pickedPicture;
  PlatformFile? pickedHealthDoc;

  final MultiSelectController _multiDropdownController =
      MultiSelectController();

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
  }

  @override
  void dispose() {
    super.dispose();
    _multiDropdownController.dispose();
  }

  Future uploadPicture() async {
    final result = await FilePicker.platform.pickFiles();

    final path = '$uid/${pickedPicture!.name}';
    final picture = File(pickedPicture!.path!);

    if (result == null) return;

    setState(() {
      pickedPicture = result.files.first;
    });

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(picture);
  }

  Future uploadHealthDoc() async {
    final result = await FilePicker.platform.pickFiles();

    final path = '$uid/${pickedHealthDoc!.name}';
    final document = File(pickedHealthDoc!.path!);

    if (result == null) return;

    setState(() {
      pickedHealthDoc = result.files.first;
    });

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(document);
  }

  void _validateInputs() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save(); // save each form

      // TODO: Upload form to firebase
      Navigator.pop(context);
    } else {
      print("Form is invalid");
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
                    petName = value!;
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
                            groupValue: sex,
                            onChanged: (Sex? value) {
                              setState(() {
                                sex = value!;
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
                            groupValue: sex,
                            onChanged: (Sex? value) {
                              setState(() {
                                sex = value!;
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
                        items: <String>[
                          'Dog',
                          'Cat',
                          'Bird',
                          'Turtle',
                          'Fish',
                          'Salamander'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            type = value!;
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the size!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Size',
                            hintText: 'In centimeter (cm)',
                            labelStyle: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            hintStyle: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        onSaved: (value) {
                          size = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Age (optional)',
                          labelStyle: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        onSaved: (value) {
                          age = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextFormField(
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
                    description = value!;
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
                child: ElevatedButton(
                  onPressed: uploadPicture,
                  child: Text(
                    'Upload a picture!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary),
                  ),
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
                child: ElevatedButton(
                  onPressed: uploadHealthDoc,
                  child: Text(
                    'Upload health documents!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary),
                  ),
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

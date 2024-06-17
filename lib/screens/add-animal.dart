import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../const/constants.dart' as Constants;

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

  late StringTagController _stringTagController;
  late double _distanceToField;

  static const List<String> _initialTags = Constants.personalityTags;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController();
  }

  @override
  void dispose() {
    super.dispose();
    _stringTagController.dispose();
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
                        decoration: const InputDecoration(
                          labelText: 'Age',
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextFormField(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Autocomplete<String>(
                  optionsViewBuilder: (context, onSelected, options) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          elevation: 4.0,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return TextButton(
                                  onPressed: () {
                                    onSelected(option);
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '#$option',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _initialTags.where((String option) {
                      return option
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selectedTag) {
                    _stringTagController.onTagSubmitted(selectedTag);
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextFieldTags<String>(
                      textEditingController: textEditingController,
                      focusNode: focusNode,
                      textfieldTagsController: _stringTagController,
                      initialTags: const [
                        'Playful',
                      ],
                      textSeparators: const [' ', ','],
                      letterCase: LetterCase.normal,
                      validator: (String tag) {
                        if (tag == 'php') {
                          return 'No, please just no';
                        } else if (_stringTagController.getTags!
                            .contains(tag)) {
                          return 'You\'ve already entered that';
                        }
                        return null;
                      },
                      inputFieldBuilder: (context, inputFieldValues) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: TextField(
                            controller: inputFieldValues.textEditingController,
                            focusNode: inputFieldValues.focusNode,
                            decoration: InputDecoration(
                              isDense: true,
                              helperText: 'Add some personality tags to your pet!',
                              helperStyle: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              hintText: inputFieldValues.tags.isNotEmpty
                                  ? ''
                                  : "Enter tag...",
                              hintStyle: const TextStyle(fontSize: 14),
                              errorText: inputFieldValues.error,
                              prefixIconConstraints: BoxConstraints(
                                  maxWidth: _distanceToField * 0.74),
                              prefixIcon: inputFieldValues.tags.isNotEmpty
                                  ? SingleChildScrollView(
                                      controller:
                                          inputFieldValues.tagScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: inputFieldValues.tags
                                              .map((String tag) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            color: Theme.of(context).colorScheme.tertiary,
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 5.0, bottom: 5.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  '#$tag',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onTap: () {
                                                  //print("$tag selected");
                                                },
                                              ),
                                              const SizedBox(width: 4.0),
                                              InkWell(
                                                child: const Icon(
                                                  Icons.cancel,
                                                  size: 14.0,
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                ),
                                                onTap: () {
                                                  inputFieldValues
                                                      .onTagRemoved(tag);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                    )
                                  : null,
                            ),
                            onChanged: inputFieldValues.onTagChanged,
                            onSubmitted: inputFieldValues.onTagSubmitted,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: uploadPicture,
                  child: Text(
                    'Upload a picture!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
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
                        color: Theme.of(context).colorScheme.tertiary),
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
                          color: Theme.of(context).colorScheme.tertiary),
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
                          color: Theme.of(context).colorScheme.tertiary),
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

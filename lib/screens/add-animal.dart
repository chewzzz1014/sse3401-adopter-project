import 'package:flutter/material.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  final _formKey = GlobalKey<FormState>();

  String petName = '';
  String sex = '';
  String type = '';
  String size = '';
  String age = '';
  String description = '';
  String tags = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Pet\'s Name',
              ),
              onSaved: (value) {
                petName = value!;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Sex',
                    ),
                    onSaved: (value) {
                      sex = value!;
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Type',
                    ),
                    items: <String>['Dog', 'Cat', 'Bird']
                        .map((String value) {
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
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Size',
                    ),
                    items: <String>['Small', 'Medium', 'Large']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        size = value!;
                      });
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
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Describe your pet!',
              ),
              maxLines: 3,
              onSaved: (value) {
                description = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Add some personality tags to your pet!',
              ),
              onSaved: (value) {
                tags = value!;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle picture upload
              },
              child: const Text('Upload a picture!'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle health document upload
              },
              child: const Text('Upload health documents!'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle form submission
                    }
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(width: 16.0),
                OutlinedButton(
                  onPressed: () {
                    // Handle cancel action
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

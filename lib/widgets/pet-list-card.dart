import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/animal.dart';

class PetCard extends StatefulWidget {
  Animal animal;

  PetCard({
    required this.animal,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text('Three-line ListTile'),
        subtitle:
        Text('A sufficiently long subtitle warrants three lines.'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}

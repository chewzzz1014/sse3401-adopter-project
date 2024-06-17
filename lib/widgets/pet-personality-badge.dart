import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalityBadge extends StatelessWidget {
  final String personality;

  const PersonalityBadge({super.key, required this.personality});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4.0, bottom: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        personality,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

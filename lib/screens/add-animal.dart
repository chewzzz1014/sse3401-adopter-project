import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimalAddingPage extends StatefulWidget {
  const AnimalAddingPage({super.key});

  @override
  State<AnimalAddingPage> createState() => _AnimalAddingPageState();
}

class _AnimalAddingPageState extends State<AnimalAddingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // need AppBar to navigate back to Animal List page
      body: Text('add or edit animal page'),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Pet list page'),
    );
  }
}

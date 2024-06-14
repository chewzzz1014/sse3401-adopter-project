import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeAnimalPage extends StatefulWidget {
  const SwipeAnimalPage({super.key});

  @override
  State<SwipeAnimalPage> createState() => _SwipeAnimalPageState();
}

class _SwipeAnimalPageState extends State<SwipeAnimalPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Swipe animal page'),
    );
  }
}

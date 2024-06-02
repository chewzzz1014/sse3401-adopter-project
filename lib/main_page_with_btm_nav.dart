import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Adopter'),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05),
            child: const Icon(Icons.person),
          )
        ],
      ),
      body: Text('body'),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'profile',
            icon: Icon(Icons.chat_outlined),
          ),
          BottomNavigationBarItem(
            label: 'home',
            icon: Icon(Icons.swipe),
          ),
          BottomNavigationBarItem(
            label: 'settings',
            icon: Icon(Icons.list_outlined),
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onClicked;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: selectedIndex,
      onTap: onClicked,
      selectedItemColor: const Color(0xffC738BD),
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
    );
  }
}
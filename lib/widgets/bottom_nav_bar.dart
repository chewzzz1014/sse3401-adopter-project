import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onClicked;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onClicked,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: widget.selectedIndex,
      onTap: widget.onClicked,
      selectedItemColor: Theme.of(context).colorScheme.tertiary,
      unselectedItemColor: Colors.grey.shade600,
      items: const [
        BottomNavigationBarItem(
          label: 'chat',
          icon: Icon(
            Icons.message,
          ),
        ),
        BottomNavigationBarItem(
          label: 'swipe',
          icon: Icon(
            Icons.swipe,
          ),
        ),
        BottomNavigationBarItem(
          label: 'pet_list',
          icon: Icon(
            IconData(0xe4a1, fontFamily: 'MaterialIcons'),
          ),
        ),
        BottomNavigationBarItem(
          label: 'profile',
          icon: Icon(
            Icons.person,
          ),
        ),
      ],
    );
  }
}

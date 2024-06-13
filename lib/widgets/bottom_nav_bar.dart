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
      // selectedItemColor: const Color(0xffC738BD),
      items: [
        BottomNavigationBarItem(
          label: 'chat',
          icon: Icon(
            Icons.chat_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        BottomNavigationBarItem(
          label: 'swipe',
          icon: Icon(
            Icons.swipe,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        BottomNavigationBarItem(
          label: 'pet_list',
          icon: Icon(
            Icons.list_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        BottomNavigationBarItem(
          label: 'profile',
          icon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

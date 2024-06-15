import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sse3401_adopter_project/screens/chat/chat-list.dart';
import 'package:sse3401_adopter_project/screens/pet/pet-list.dart';
import 'package:sse3401_adopter_project/screens/swipe-animal.dart';
import 'package:sse3401_adopter_project/screens/user-profile.dart';
import 'widgets/bottom_nav_bar.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adopter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xffFFC97C),
          primary: Color(0xffFFC97C),
          secondary: Color(0xffC1C1C1),
          tertiary: Color(0xffEA7659),
        ),
        textTheme: GoogleFonts.wellfleetTextTheme(Theme.of(context).textTheme),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // assign btn nav bar item to pages (index is based on selectedIndex state)
  final _pageOptions = [
    ChatListPage(),
    SwipeAnimalPage(),
    PetListPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Adoptr',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          centerTitle: true,
          // backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: const Icon(Icons.person),
            )
          ],
        ),
        /*
      Change the body to test out your screens
       */
        body: _pageOptions[_selectedIndex],
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onClicked: _onClicked,
        ));
  }
}

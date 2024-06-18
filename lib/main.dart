import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sse3401_adopter_project/screens/chat/chat-list.dart';
import 'package:sse3401_adopter_project/screens/pet/pet-list.dart';
import 'package:sse3401_adopter_project/screens/swipe-animal.dart';
import 'package:sse3401_adopter_project/services/auth_service.dart';
import 'package:sse3401_adopter_project/services/navigation_service.dart';
import 'package:sse3401_adopter_project/utils.dart';
import 'package:sse3401_adopter_project/widgets/appbar-top-right-menu.dart';
import 'widgets/bottom_nav_bar.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;

  MyApp({super.key}) {
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adopter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffEA7659),
          primary: const Color(0xffEA7659),
          secondary: const Color(0xffC1C1C1),
          tertiary: const Color(0xffFFC97C),
        ),
        textTheme: GoogleFonts.wellfleetTextTheme(Theme.of(context).textTheme),
      ),
      // home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigationService.navigatorKey,
      initialRoute: _authService.user != null ? '/home' : '/login',
      routes: _navigationService.routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
  }

  void _onClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _onPressed() {
    return false;
  }

  // assign btn nav bar item to pages (index is based on selectedIndex state)
  final _pageOptions = [
    ChatListPage(),
    SwipeAnimalPage(),
    PetListPage(),
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
              child: AppBarMenuButton(),
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

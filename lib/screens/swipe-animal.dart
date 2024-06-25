import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/constants.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:sse3401_adopter_project/services/auth_service.dart';
import 'package:sse3401_adopter_project/widgets/swiping-card.dart';
import 'package:filter_list/filter_list.dart';

import '../models/animal.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../widgets/swiping-buttons.dart';
import '../services/storage_service.dart';

class SwipeAnimalPage extends StatefulWidget {
  const SwipeAnimalPage({super.key});

  @override
  State<SwipeAnimalPage> createState() => _SwipeAnimalPageState();
}

class _SwipeAnimalPageState extends State<SwipeAnimalPage>
    with TickerProviderStateMixin {
  final GetIt _getIt = GetIt.instance;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;
  late StorageService _storageService;
  late AuthService _authService;

  final AppinioSwiperController _swiperController = AppinioSwiperController();

  List<Animal> animalsToShow = [];
  List<String> selectedTypes = [];
  List<String> selectedGenders = [];
  List<String> selectedAges = [];
  bool allSwiped = false;

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    _navigationService = _getIt.get<NavigationService>();
    _storageService = _getIt.get<StorageService>();
    _authService = _getIt.get<AuthService>();
    _initAnimals();
  }

  void _initAnimals() {
    _databaseService.getAnimals().listen((QuerySnapshot<Animal> snapshot) {

      List<Animal> animals = snapshot.docs.map(
              (doc) => doc.data()
      ).where((animal) => animal.ownerId != _authService.user!.uid).toList();
      setState(() {
        animalsToShow = animals;
        allSwiped = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _swiperController.dispose();
  }

  void _applyFilters(List<Animal> animals, List<String> types,
      List<String> genders, List<String> ages) {
    List<Animal> filtered = animals;

    if (types.isNotEmpty) {
      filtered =
          filtered.where((animal) => types.contains(animal.type)).toList();
    }
    if (genders.isNotEmpty) {
      filtered =
          filtered.where((animal) => genders.contains(animal.gender)).toList();
    }
    if (ages.isNotEmpty) {
      filtered = filtered
          .where((animal) =>
              (ages.contains('Less than 3') && animal.age! < 3) ||
              (ages.contains('Equal or greater than 3') && animal.age! >= 3))
          .toList();
    }

    setState(() {
      animalsToShow = filtered;
    });
  }

  Future<void> _openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Filter animals',
      height: 500,
      listData: animalTypes + genders + ageOptions,
      selectedListData: selectedTypes + selectedGenders + selectedAges,
      choiceChipLabel: (item) => item!,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (item, query) {
        /// When search query change in search bar then this method will be called
        return item.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedTypes =
              list?.where((item) => animalTypes.contains(item)).toList() ?? [];
          selectedGenders =
              list?.where((item) => genders.contains(item)).toList() ?? [];
          selectedAges =
              list?.where((item) => ageOptions.contains(item)).toList() ?? [];
          _applyFilters(animalsToShow, selectedTypes, selectedGenders, selectedAges);
        });
        Navigator.pop(context);
      },
      onCloseWidgetPress: () {
        Navigator.pop(context, null);
      },

      /// uncomment below code to create custom choice chip
      /* choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
            color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
          )),
          child: Text(
            item.name,
            style: TextStyle(
                color: isSelected ? Colors.blue[300] : Colors.grey[500]),
          ),
        );
      }, */
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _openFilterDialog,
                  child: const Text(
                    "Filter the list >",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: allSwiped
                ? const Center(child: Text("No more animals to show :("),)
                  : FutureBuilder(
                future: Future.wait(animalsToShow.map((pet) =>
                    precacheImage(NetworkImage(pet.imageUrl!), context))),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AppinioSwiper(
                      duration: const Duration(milliseconds: 500),
                      invertAngleOnBottomDrag: true,
                      backgroundCardCount: 2,
                      swipeOptions: const SwipeOptions.all(),
                      controller: _swiperController,
                      onCardPositionChanged: (
                          SwiperPosition position,
                          ) {},
                      onSwipeEnd: _swipeEnd,
                      onEnd: _onEnd,
                      cardCount: animalsToShow.isNotEmpty ? animalsToShow.length : 1,
                      cardBuilder: (BuildContext context, int index) {
                        if (animalsToShow.isEmpty) {
                          return const Center(child: Text("No animals available"));
                        } else {
                          return AnimalCard(animal: animalsToShow[index]);
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 60),
            if (animalsToShow.isNotEmpty)
              IconTheme.merge(
                data: const IconThemeData(size: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    swipeLeftButton(_swiperController),
                    swipeRightButton(_swiperController),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    switch (activity) {
      case Swipe():
        // log('The card was swiped to the : ${activity.direction}');
        // log('previous index: $previousIndex, target index: $targetIndex');
        break;
      case Unswipe():
        // log('A ${activity.direction.name} swipe was undone.');
        // log('previous index: $previousIndex, target index: $targetIndex');
        break;
      case CancelSwipe():
        // log('A swipe was cancelled');
        break;
      case DrivenActivity():
        // log('Driven Activity');
        break;
    }
  }

  void _onEnd() {
    setState(() {
      allSwiped = true;
    });
  }
}

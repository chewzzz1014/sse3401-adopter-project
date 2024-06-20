import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/mockData/mock-pet.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
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

  late List<Animal> petsFiltered = animalList;

  final AppinioSwiperController controller = AppinioSwiperController();

  // static const List<Animal> _animalData =

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    _navigationService = _getIt.get<NavigationService>();
    _storageService = _getIt.get<StorageService>();
  }

  @override
  void didChangeDependencies() async {

    super.didChangeDependencies();

    if (petsFiltered.isNotEmpty) {
      for (var pet in petsFiltered) {
        await precacheImage(AssetImage(pet.imageUrl!), context);
      }
    }
  }

  Future<void> _openFilterDialog() async {
  //   await FilterListDialog.display<User>(
  //     context,
  //     hideSelectedTextCount: true,
  //     themeData: FilterListThemeData(
  //       context,
  //       choiceChipTheme: ChoiceChipThemeData.light(context),
  //     ),
  //     headlineText: 'Select Users',
  //     height: 500,
  //     listData: userList,
  //     selectedListData: selectedUserList,
  //     choiceChipLabel: (item) => item!.name,
  //     validateSelectedItem: (list, val) => list!.contains(val),
  //     controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
  //     onItemSearch: (user, query) {
  //       /// When search query change in search bar then this method will be called
  //       ///
  //       /// Check if items contains query
  //       return user.name!.toLowerCase().contains(query.toLowerCase());
  //     },
  //
  //     onApplyButtonClick: (list) {
  //       setState(() {
  //         selectedUserList = List.from(list!);
  //       });
  //       Navigator.pop(context);
  //     },
  //     onCloseWidgetPress: () {
  //       // Do anything with the close button.
  //       //print("hello");
  //       Navigator.pop(context, null);
  //     },
  //
  //     /// uncomment below code to create custom choice chip
  //     /* choiceChipBuilder: (context, item, isSelected) {
  //       return Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //         decoration: BoxDecoration(
  //             border: Border.all(
  //           color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
  //         )),
  //         child: Text(
  //           item.name,
  //           style: TextStyle(
  //               color: isSelected ? Colors.blue[300] : Colors.grey[500]),
  //         ),
  //       );
  //     }, */
  //   );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: const Text("Filter the list:"),
                onPressed: () {
                  _openFilterDialog;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: FutureBuilder(
                future: Future.wait(petsFiltered.map(
                    (pet) => precacheImage(AssetImage(pet.imageUrl!), context))),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AppinioSwiper(
                      duration: const Duration(milliseconds: 500),
                      invertAngleOnBottomDrag: true,
                      backgroundCardCount: 2,
                      swipeOptions: const SwipeOptions.all(),
                      controller: controller,
                      onCardPositionChanged: (
                        SwiperPosition position,
                      ) {},
                      onSwipeEnd: _swipeEnd,
                      onEnd: _onEnd,
                      cardCount: petsFiltered.length,
                      cardBuilder: (BuildContext context, int index) {
                        return AnimalCard(animal: petsFiltered[index]);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 60),
            IconTheme.merge(
              data: const IconThemeData(size: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  swipeLeftButton(controller),
                  swipeRightButton(controller),
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
    //
  }
}

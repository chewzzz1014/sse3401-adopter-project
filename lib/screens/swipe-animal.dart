import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:sse3401_adopter_project/mockData/mock-pet.dart';
import 'package:sse3401_adopter_project/widgets/multi_select_tags_drop_down.dart';
import 'package:sse3401_adopter_project/constants.dart' as Constants;
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:sse3401_adopter_project/widgets/swiping-card.dart';

import '../models/animal.dart';
import '../widgets/swiping-buttons.dart';

class SwipeAnimalPage extends StatefulWidget {
  const SwipeAnimalPage({super.key});

  @override
  State<SwipeAnimalPage> createState() => _SwipeAnimalPageState();
}

class _SwipeAnimalPageState extends State<SwipeAnimalPage>
    with TickerProviderStateMixin {
  late List<Animal> petsFiltered = animalList;

  final MultiSelectController _multiDropdownController =
      MultiSelectController();
  final AppinioSwiperController controller = AppinioSwiperController();

  static const List<String> _initialTags = Constants.personalityTags;

  @override
  void initState() {
    super.initState();
    _multiDropdownController.setOptions(_initialTags.map((tag) {
      return ValueItem<String>(
        label: tag,
        value: tag,
      );
    }).toList());
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (petsFiltered.isNotEmpty) {
      for (var pet in petsFiltered) {
        await precacheImage(AssetImage(pet.imageUrl), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Filter the list:",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: MultiSelectTagsDropDown(
                multiDropdownController: _multiDropdownController,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: FutureBuilder(
                future: Future.wait(petsFiltered.map(
                    (pet) => precacheImage(AssetImage(pet.imageUrl), context))),
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
                    return const CircularProgressIndicator();
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

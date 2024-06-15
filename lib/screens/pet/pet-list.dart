import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sse3401_adopter_project/mockData/mock-pet.dart';

import '../../widgets/pet-list-card.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(
              child: TabBar(
                tabs: [
                  Tab(text: 'My Animal'),
                  Tab(text: 'My Adoption Request'),
                ],
              ),
            ),
            Flexible(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: animalList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PetCard(
                          animal: animalList[index],
                        );
                      },
                    ),
                  ),
                  Icon(Icons.directions_transit),
                ],
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/mockData/mock-pet.dart';
import 'package:sse3401_adopter_project/widgets/adoption-list-card.dart';

import '../../models/animal-adoption-request.dart';
import '../../models/animal.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../widgets/pet-list-card.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;

  List<AdoptionRequest> adoptionRequestList = generateAdoptionRequests();

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'My Animal'),
                  Tab(text: 'My Adoption Request'),
                ],
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    children: [
                      // SingleChildScrollView(
                      // child: ListView.builder(
                      //   itemCount: animalList.length,
                      //   shrinkWrap: true,
                      //   padding: const EdgeInsets.only(top: 16),
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                      //     return PetCard(
                      //       animal: animalList[index],
                      //     );
                      //   },
                      // ),
                      // ),
                      StreamBuilder(
                        stream: _databaseService.getAnimals(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Unable to load data.'));
                          }
                          print(snapshot.data);
                          if (snapshot.hasData && snapshot.data != null) {
                            final animals = snapshot.data!.docs;
                            return SingleChildScrollView(
                              child: ListView.builder(
                                itemCount: animals.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Animal animal = animals[index].data();
                                  return PetCard(
                                    animal: animal,
                                  );
                                },
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),

                      SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: adoptionRequestList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AdoptionCard(
                              adoptionRequest: adoptionRequestList[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addAnimal');
            },
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            tooltip: "Add a pet!",
            child: const Icon(Icons.add),
          ),
        ));
  }
}

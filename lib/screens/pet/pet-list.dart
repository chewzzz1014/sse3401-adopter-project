import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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

                            if (animals.isEmpty) {
                              return const Center(
                                  child: Text(
                                "No animals available",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ));
                            }

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
                                    documentId: animals[index].id,
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
                        child: Column(
                          children: [
                            const Text(
                              'Received',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder(
                              stream: _databaseService
                                  .getReceivedAdoptionRequests(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Unable to load data.'));
                                }
                                print(snapshot.data);
                                if (snapshot.hasData && snapshot.data != null) {
                                  final receivedRequests = snapshot.data!.docs;

                                  if (receivedRequests.isEmpty) {
                                    return const Center(
                                        child: Text(
                                      "No records available :(",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ));
                                  }

                                  return ListView.builder(
                                    itemCount: receivedRequests.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 8),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      AdoptionRequest req =
                                          receivedRequests[index].data();
                                      return AdoptionCard(
                                        adoptionRequest: req,
                                        type: 'Received',
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            const Text(
                              'Sent',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder(
                              stream:
                                  _databaseService.getSentAdoptionRequests(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Unable to load data.'));
                                }
                                print(snapshot.data);
                                if (snapshot.hasData && snapshot.data != null) {
                                  final sentRequests = snapshot.data!.docs;

                                  if (sentRequests.isEmpty) {
                                    return const Center(
                                        child: Text(
                                      "No records available :(",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ));
                                  }

                                  return ListView.builder(
                                      itemCount: sentRequests.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(top: 8),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        AdoptionRequest req =
                                            sentRequests[index].data();
                                        return AdoptionCard(
                                          adoptionRequest: req,
                                          type: 'Sent',
                                        );
                                      },
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ],
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

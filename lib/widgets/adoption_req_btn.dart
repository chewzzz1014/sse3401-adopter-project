import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../constants.dart';
import '../models/animal-adoption-request.dart';
import '../models/animal.dart';
import '../services/alert_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AdoptionRequestBtn extends StatefulWidget implements PreferredSizeWidget {
  final String chatWithId;

  AdoptionRequestBtn({
    required this.chatWithId,
  });

  @override
  State<AdoptionRequestBtn> createState() => _AdoptionRequestBtnState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AdoptionRequestBtnState extends State<AdoptionRequestBtn> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  List<AdoptionRequest>? _histories;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _fetchHistories();
  }

  Future<void> _fetchHistories() async {
    try {
      // Await the snapshot from the database service
      QuerySnapshot<AdoptionRequest> snapshot = await _databaseService
          .getAdoptionRequestsBetween2Users(
            _authService.user!.uid,
            widget.chatWithId,
          )
          .first; // Using first to get a single snapshot

      // Check if snapshot has data and convert to list of AdoptionRequest objects
      if (snapshot.docs.isNotEmpty) {
        final result = snapshot.docs;
        setState(() {
          _histories = result.map((doc) => doc.data()).toList();
          print(_histories);
        });
      }
    } catch (e) {
      print('Error fetching adoption requests: $e');
    }
  }

  int getExistingRequestIndex(String animalId) {
    if (_histories == null) return -1;
    final foundIndex = _histories?.indexWhere(
      (element) => element.petId == animalId,
    );
    return foundIndex!;
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 2:
        return Colors.green;
      case 1:
        return Theme.of(context).colorScheme.primary; // Tertiary color
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 2:
        return 'Approved';
      case 1:
        return 'Rejected'; // Tertiary color
      default:
        return 'Pending';
    }
  }

  void _sendReqPopup(Animal animal) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Send Adoption Request? 🤩'),
        content: Text('Do you want to become ${animal.name}\'s new owner?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _sendAdoptionReq(
              animal.id!,
              animal.ownerId!,
              _authService.user!.uid,
            ),
            child: const Text(
              'Yes',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _sendAdoptionReq(
      String animalId, String receiverId, String senderId) async {
    await _databaseService.createNewAdoptionReq(animalId, senderId, receiverId);

    Navigator.pop(context, 'Yes');

    _alertService.showToast(
      text: 'Adoption Request Sent!',
      icon: Icons.check,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Which pet to adopt? 😝'),
                    const SizedBox(height: 16),
                    StreamBuilder(
                      stream: _databaseService
                          .getAvailableAnimalByOwnerId(widget.chatWithId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Unable to load data.'));
                        }
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

                          return SizedBox(
                            height: 150, // Adjust the height as needed
                            child: ListView.builder(
                              itemCount: animals.length,
                              itemBuilder: (context, index) {
                                Animal animal = animals[index].data();
                                final foundHistoriesIndex =
                                    getExistingRequestIndex(animal.id!);
                                final foundRecord = _histories != null &&
                                        foundHistoriesIndex > -1
                                    ? _histories![foundHistoriesIndex]
                                    : null;

                                return SimpleDialogOption(
                                  onPressed: foundRecord == null
                                      ? () {
                                          Navigator.pop(context, animal.name);
                                          _sendReqPopup(animal);
                                        }
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(animal.name!),
                                        if (foundRecord != null)
                                          Text(
                                            ' (${getStatusText(foundRecord.status!)})',
                                            style: TextStyle(
                                              color: getStatusColor(
                                                  foundRecord.status!),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
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
                  ],
                ),
              ),
            );
          },
        );
      },
      child: const Icon(
        IconData(0xe4a1, fontFamily: 'MaterialIcons'),
        color: Colors.black54,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:sse3401_adopter_project/models/animal-adoption-request.dart';
import 'package:sse3401_adopter_project/models/user_profile.dart';
import '../models/animal.dart';
import '../screens/chat/chat-page.dart';
import '../services/alert_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AdoptionCard extends StatefulWidget {
  AdoptionRequest adoptionRequest;
  String type;

  AdoptionCard({
    super.key,
    required this.adoptionRequest,
    required this.type,
  });

  @override
  State<AdoptionCard> createState() => _AdoptionCardState();
}

class _AdoptionCardState extends State<AdoptionCard> {
  final GetIt _getIt = GetIt.instance;
  late DatabaseService _databaseService;
  late AuthService _authService;
  late AlertService _alertService;
  late NavigationService _navigationService;

  Animal? _animal;
  UserProfile? _user;
  int? _adoptionRequestStatus;
  String? formattedSentAt;

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    _authService = _getIt.get<AuthService>();
    _alertService = _getIt.get<AlertService>();
    _navigationService = _getIt.get<NavigationService>();

    _fetchAnimal();
    _fetchUser();
  }

  Future<void> _fetchAnimal() async {
    final doc = await _databaseService.getAnimalById(widget.adoptionRequest.petId!);
    if (doc.exists) {
      setState(() {
        _animal = doc.data()!;
        _adoptionRequestStatus = widget.adoptionRequest.status;
        DateTime sentAt = DateTime.parse(widget.adoptionRequest.sentAt!.toDate().toString());
        formattedSentAt = DateFormat('dd/mm/yyyy kk:mm').format(sentAt);
      });
    }
  }

  Future<void> _fetchUser() async {
    final doc = await _databaseService.getUserById(widget.adoptionRequest.senderId!);
    if (doc.exists) {
      setState(() {
        _user = doc.data()!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == 'Received' ? _buildReceivedCard() : _buildSentCard();
  }

  Widget _buildReceivedCard() {
    return Card(
      child: ListTile(
        title: Text(
          'Adopt ${_animal?.name}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_user?.username} have requested to adopt ${_animal?.name} on $formattedSentAt',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getStatusText(widget.adoptionRequest.status!),
                  style: TextStyle(color: getStatusColor(widget.adoptionRequest.status!)),
                ),
                if(widget.adoptionRequest.status! == 0)
                  _buildReceivedButtonUI(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentCard() {
    return Card(
      child: ListTile(
        title: Text(
          'Adopt ${_animal?.name}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have requested to adopt ${_animal?.name} on $formattedSentAt',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getStatusText(widget.adoptionRequest.status!),
                  style: TextStyle(color: getStatusColor(widget.adoptionRequest.status!)),
                ),
                _buildSentButtonUI(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 2:
        return Colors.green;
      case 1:
        return Theme.of(context).colorScheme.primary; // Tertiary color
      case 'pending':
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
      case 'pending':
      default:
        return 'Pending';
    }
  }

  Widget _buildReceivedButtonUI() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Approve Adoption Request? 🤩'),
                      content: Text(
                          'Do you want ${_user?.username} to become ${_animal?.name}\'s new owner?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => _approveRequest(context),
                          child: const Text(
                            'Yes',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Approve',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Reject Adoption Request? 😭'),
                      content: Text(
                          'Are you sure you want to reject ${_user?.username} from adopt ${_animal?.name}?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => _rejectRequest(context),
                          child: const Text(
                            'Yes',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Reject',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSentButtonUI() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final chatExists =
            await _databaseService.checkChatExists(
              _authService.user!.uid,
              widget.adoptionRequest.receiverId!,
            );
            print(chatExists);
            if (!chatExists) {
              await _databaseService.createNewChat(
                _authService.user!.uid,
                widget.adoptionRequest.receiverId!,
              );
            }
            final result = await _databaseService.getUserById(widget.adoptionRequest.receiverId!);
            if(result.exists) {
              UserProfile chatWith = result.data();

              _navigationService.push(
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(chatUser: chatWith);
                  },
                ),
              );
            } else {
              _alertService.showToast(
                text: 'User not available',
                icon: Icons.error,
              );
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 0.8, color: Colors.grey),
          ),
          child: const Text(
            'Chat',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // TODO: direct to animal details page (passing _animal.id)
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 0.8, color: Colors.grey),
          ),
          child: Text(
            'View ${_animal?.name}',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _approveRequest(BuildContext context) async {
    Navigator.pop(context, 'Yes');

    await _databaseService.updateAnimalAdoptedStatus(widget.adoptionRequest.petId!);
    await _databaseService.updateAdoptionRequestStatus(widget.adoptionRequest.id!, 2);

    _alertService.showToast(
      text: 'Adoption Request Approved!',
      icon: Icons.check,
    );
    setState(() {
      _adoptionRequestStatus = widget.adoptionRequest.status;
    });
  }

  void _rejectRequest(BuildContext context) async {
    Navigator.pop(context, 'Yes');

    await _databaseService.updateAdoptionRequestStatus(widget.adoptionRequest.id!, 1);

    _alertService.showToast(
      text: 'Adoption Request Rejected!',
      icon: Icons.check,
    );
    setState(() {
      _adoptionRequestStatus = widget.adoptionRequest.status;
    });
  }
}

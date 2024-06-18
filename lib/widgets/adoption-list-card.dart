import 'package:flutter/material.dart';
import 'package:sse3401_adopter_project/mockData/mock-pet.dart';
import 'package:sse3401_adopter_project/mockData/mock-user.dart';
import 'package:sse3401_adopter_project/models/animal-adoption-request.dart';
import 'package:sse3401_adopter_project/models/chat-user-model.dart';
import 'package:intl/intl.dart';
import '../models/animal.dart';

class AdoptionCard extends StatefulWidget {
  AdoptionRequest adoptionRequest;

  AdoptionCard({
    super.key,
    required this.adoptionRequest,
  });

  @override
  State<AdoptionCard> createState() => _AdoptionCardState();
}

class _AdoptionCardState extends State<AdoptionCard> {
  @override
  Widget build(BuildContext context) {
    Animal? animal = getAnimalById(widget.adoptionRequest.petId);
    ChatUsers user = getChatUsersById(widget.adoptionRequest.userId);
    String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a')
        .format(widget.adoptionRequest.timestamp);
    List<String> statusList = ['Pending', 'Rejected', 'Approved'];
    int statusIdx = widget.adoptionRequest.status ?? 0;
    String status = statusList[statusIdx];

    return Card(
      child: ListTile(
        title: Text(
          'Adopt ${animal?.name}!',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle: Text('${user.name} have requested to adopt ${animal.name} on ${formattedDateTime}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${user.name} have requested to adopt ${animal?.name} on $formattedDateTime',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(color: getStatusColor(statusIdx)),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: statusIdx == 0 ? () {
                        // Implement approve logic
                      } : null,
                      child: const Text(
                        'Approve', style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: statusIdx == 0 ? () {
                        // Implement approve logic
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,),
                      child: const Text(
                        'Reject', style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
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
        return Theme
            .of(context)
            .colorScheme
            .primary; // Tertiary color
      case 'pending':
      default:
        return Theme
            .of(context)
            .colorScheme
            .tertiary;
    }
  }
}

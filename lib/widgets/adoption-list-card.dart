import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    Animal animal = getAnimalById(widget.adoptionRequest.petId);
    ChatUsers user = getChatUsersById(widget.adoptionRequest.userId);
    String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a')
        .format(widget.adoptionRequest.timestamp);
    List<String> statusList = ['Pending', 'Rejected', 'Approved'];
    int statusIdx = widget.adoptionRequest.status ?? 0;
    String status = statusList[statusIdx];

    return Card(
      child: ListTile(
        title: Text(
          'Adopt ${animal.name}!',
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
              '${user.name} have requested to adopt ${animal.name} on ${formattedDateTime}',
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Implement approve logic
                      },
                      child: Text('Approve'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Implement reject logic
                      },
                      child: Text('Reject'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
}

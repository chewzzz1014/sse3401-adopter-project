import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sse3401_adopter_project/screens/add-animal.dart';
import 'package:sse3401_adopter_project/widgets/pet-personality-badge.dart';

import '../models/animal.dart';

class PetCard extends StatefulWidget {
  Animal animal;

  PetCard({
    super.key,
    required this.animal,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

String shortenString(String id, int maxLength) {
  if (id.length <= maxLength) return id;
  return '${id.substring(0, maxLength)}...';
}

class _PetCardState extends State<PetCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AnimalAddingPage();
        }));
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(
                  widget.animal.imageUrl,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.animal.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.animal.gender} ${widget.animal.type}. ${widget.animal.age} years old',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.animal.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      children: widget.animal.personality
                          .take(3)
                          .map((p) => PersonalityBadge(personality: p))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

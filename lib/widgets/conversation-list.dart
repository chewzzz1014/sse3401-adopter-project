import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/user_profile.dart';

class ConversationList extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onTap;

  ConversationList({
    required this.userProfile,
    required this.onTap,
  });

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    var imageURL = (widget.userProfile.pfpURL == null ||
            widget.userProfile.pfpURL!.isEmpty)
        ? USER_PLACEHOLDER_IMG
        : widget.userProfile.pfpURL;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageURL!) as ImageProvider,
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.userProfile.username!,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Test message',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Today',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

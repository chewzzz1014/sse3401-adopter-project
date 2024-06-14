import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sse3401_adopter_project/widgets/chat-search-bar.dart';

import '../../models/chat-user-model.dart';
import '../../widgets/conversation-list.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
      name: "Jane Russel",
      messageText: "Awesome Setup",
      imageURL: "assets/images/userImage.jpg",
      time: "Now",
    ),
    ChatUsers(
      name: "Glady's Murphy",
      messageText: "That's Great",
      imageURL: "assets/images/userImage.jpg",
      time: "Yesterday",
    ),
    ChatUsers(
      name: "Jorge Henry",
      messageText: "Hey where are you?",
      imageURL: "assets/images/userImage.jpg",
      time: "31 Mar",
    ),
    ChatUsers(
      name: "Philip Fox",
      messageText: "Busy! Call me in 20 mins",
      imageURL: "assets/images/userImage.jpg",
      time: "28 Mar",
    ),
    ChatUsers(
      name: "Debra Hawkins",
      messageText: "Thankyou, It's awesome",
      imageURL: "assets/images/userImage.jpg",
      time: "23 Mar",
    ),
    ChatUsers(
      name: "Jacob Pena",
      messageText: "will update you in evening",
      imageURL: "assets/images/userImage.jpg",
      time: "17 Mar",
    ),
    ChatUsers(
      name: "Andrey Jones",
      messageText: "Can you please share the file?",
      imageURL: "assets/images/userImage.jpg",
      time: "24 Feb",
    ),
    ChatUsers(
      name: "John Wick",
      messageText: "How are you?",
      imageURL: "assets/images/userImage.jpg",
      time: "18 Feb",
    ),
    ChatUsers(
      name: "John Wick",
      messageText: "How are you?",
      imageURL: "assets/images/userImage.jpg",
      time: "18 Feb",
    ),
    ChatUsers(
      name: "John Wick",
      messageText: "How are you?",
      imageURL: "assets/images/userImage.jpg",
      time: "18 Feb",
    ),
    ChatUsers(
      name: "John Wick",
      messageText: "How are you?",
      imageURL: "assets/images/userImage.jpg",
      time: "18 Feb",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const ChatSearchBar(),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

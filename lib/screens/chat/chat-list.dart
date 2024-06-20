import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/models/user_profile.dart';
import 'package:sse3401_adopter_project/screens/chat/chat-page.dart';
import 'package:sse3401_adopter_project/services/database_service.dart';
import 'package:sse3401_adopter_project/widgets/chat-search-bar.dart';

import '../../services/auth_service.dart';
import '../../services/navigation_service.dart';
import '../../widgets/conversation-list.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
            Column(
              children: [
                StreamBuilder(
                  stream: _databaseService.getUserProfiles(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Unable to load data.'));
                    }
                    print(snapshot.data);
                    if (snapshot.hasData && snapshot.data != null) {
                      final users = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: users.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          UserProfile user = users[index].data();
                          return ConversationList(
                            userProfile: user,
                            onTap: () async {
                              final chatExists =
                                  await _databaseService.checkChatExists(
                                _authService.user!.uid,
                                user.uid!,
                              );
                              print(chatExists);
                              if (!chatExists) {
                                await _databaseService.createNewChat(
                                  _authService.user!.uid,
                                  user.uid!,
                                );
                              }
                              _navigationService.push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatPage(chatUser: user);
                                  },
                                ),
                              );
                            },
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
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/models/user_profile.dart';
import 'package:sse3401_adopter_project/services/database_service.dart';
import 'package:sse3401_adopter_project/widgets/chat-search-bar.dart';

import '../../mockData/mock-user.dart';
import '../../models/chat-user-model.dart';
import '../../services/auth_service.dart';
import '../../widgets/conversation-list.dart';
import 'package:uuid/uuid.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class _ChatListPageState extends State<ChatListPage> {
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

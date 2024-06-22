import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/widgets/adoption_req_btn.dart';

import '../constants.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';

class ChatPageHeader extends StatefulWidget implements PreferredSizeWidget {
  String name;
  String imageUrl;
  String chatWithId;

  ChatPageHeader({
    required this.name,
    required this.imageUrl,
    required this.chatWithId,
  });

  @override
  State<ChatPageHeader> createState() => _ChatPageHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatPageHeaderState extends State<ChatPageHeader> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    var imageURL =
        (widget.imageUrl.isEmpty) ? USER_PLACEHOLDER_IMG : widget.imageUrl;

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  _navigationService.goBack();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(imageURL),
                maxRadius: 20,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              AdoptionRequestBtn(
                chatWithId: widget.chatWithId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

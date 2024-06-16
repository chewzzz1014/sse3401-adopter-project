import 'package:flutter/material.dart';

class ChatPageHeader extends StatefulWidget implements PreferredSizeWidget {
  String name;
  String imageUrl;

  ChatPageHeader({
    required this.name,
    required this.imageUrl,
  });

  @override
  State<ChatPageHeader> createState() => _ChatPageHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatPageHeaderState extends State<ChatPageHeader> {
  @override
  Widget build(BuildContext context) {
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
                  Navigator.pop(context);
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
                backgroundImage: AssetImage(widget.imageUrl),
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
              const Icon(
                IconData(0xe4a1, fontFamily: 'MaterialIcons'),
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

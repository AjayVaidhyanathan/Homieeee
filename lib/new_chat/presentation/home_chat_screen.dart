import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/presentation/widgets/chats_list.dart';
import 'package:homieeee/new_chat/presentation/widgets/my_profile_pic.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // build chats app bar
                _buildChatsAppBar(),

                const SizedBox(height: 30),

                // Chats List
                const SizedBox(
                  height: 600,
                  child: ChatsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatsAppBar() => const Row(
        children: [
          MyProfilePic(),
          SizedBox(width: 15),
          Text(
            'Chats',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
        ],
      );

  Widget _buildChatsSearchWidget() => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFC9CCD3).withOpacity(.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 15),
            Icon(Icons.search),
            SizedBox(width: 15),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(),
                ),
              ),
            ),
          ],
        ),
      );
}

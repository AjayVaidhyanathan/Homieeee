
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/error_screens.dart';
import 'package:homieeee/new_chat/presentation/widgets/chat_tile.dart';
import 'package:homieeee/new_chat/provider/get_all_chats_provider.dart';

class ChatsList extends ConsumerWidget {
  const ChatsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsList = ref.watch(getAllChatsProvider);
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return chatsList.when(
      data: (chats) {
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats.elementAt(index);
            print(chat);
            final userId = chat.members.firstWhere((userID) => userID != myUid);
            print('other userid is $userId');
            print('myuid is $myUid');
            print('Last message is : ${chat.lastMessage}');
            print('Last messageTS is : ${chat.lastMessageTs}');
            print('chatroom id is : ${chat.chatroomId}');


            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: ChatTile(
                  userId: userId,
                  lastMessage: chat.lastMessage,
                  lastMessageTs: chat.lastMessageTs,
                  chatroomId: chat.chatroomId,
                  productID: chat.productId,
                  productTitle: chat.productTitle,
                ),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        print(error);
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
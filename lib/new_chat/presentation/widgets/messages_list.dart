import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/error_screens.dart';
import 'package:homieeee/new_chat/presentation/widgets/received_message.dart';
import 'package:homieeee/new_chat/presentation/widgets/sent_messages.dart';
import 'package:homieeee/new_chat/provider/chat_provider.dart';
import 'package:homieeee/new_chat/provider/get_allmessages_provider.dart';

class MessagesList extends ConsumerWidget {
  const MessagesList({
    super.key,
    required this.chatroomId,
    required this.imageurl
  });

  final String chatroomId;
  final String imageurl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesList = ref.watch(getAllMessagesProvider(chatroomId));
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return messagesList.when(
      data: (messages) {
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages.elementAt(index);
            final isMyMessage = message.senderId == myUid;

            if (!isMyMessage) {
              ref.read(chatProvider).seenMessage(
                    chatroomId: chatroomId,
                    messageId: message.messageId,
                  );
            }

            if (isMyMessage) {
              return SentMessage(message: message);
            } else {
              return ReceivedMessage(message: message, imageurl: imageurl,);
            }
          },
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
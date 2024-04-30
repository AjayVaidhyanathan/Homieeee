import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/models/message.dart';
import 'package:homieeee/new_chat/presentation/widgets/message_contents.dart';
import 'package:homieeee/new_chat/presentation/widgets/rounded_profile_tile.dart';



class ReceivedMessage extends ConsumerWidget {
  final Message message;
  final String imageurl;
  const ReceivedMessage({
    super.key,
    required this.message,
    required this.imageurl
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          RoundProfileTile(url: imageurl),
          const SizedBox(width: 15),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: MessageContents(message: message),
            ),
          ),
        ],
      ),
    );
  }
}
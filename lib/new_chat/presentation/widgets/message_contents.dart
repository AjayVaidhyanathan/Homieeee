import 'package:flutter/material.dart';
import 'package:homieeee/new_chat/models/message.dart';
import 'package:homieeee/new_chat/presentation/widgets/posts_image_view.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    super.key,
    required this.message,
    this.isSentMessage = false,
  });

  final Message message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'text') {
      return Text(
        message.message,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isSentMessage ? const Color(0xFFFFFFFD) : const Color(0xFF121213)),
      );
    } else {
      return PostImageVideoView(
        fileUrl: message.message,
        fileType: message.messageType,
      );
    }
  }
}

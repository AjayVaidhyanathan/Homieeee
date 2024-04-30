import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/error_screens.dart';
import 'package:homieeee/new_chat/provider/get_user_info_by_id_provider.dart';

class ChatUserInfo extends ConsumerWidget {
  const ChatUserInfo({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      getUserInfoByIdProvider(userId),
    );

    return userInfo.when(
      data: (user) {
        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.profilePicUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF121213),
                  ),
                ),
                const Text(
                  'Messenger',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFC9CCD3),
                  ),
                )
              ],
            ),
          ],
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/constants/extensions.dart';
import 'package:homieeee/new_chat/presentation/chatBetweenUsers.dart';
import 'package:homieeee/new_chat/provider/get_user_info_by_id_provider.dart';

class ChatTile extends ConsumerWidget {
  const ChatTile({
    super.key,
    required this.userId,
    required this.lastMessage,
    required this.lastMessageTs,
    required this.chatroomId,
    required this.productID,
    required this.productTitle,
  });

  final String userId;
  final String lastMessage;
  final DateTime lastMessageTs;
  final String chatroomId;
  final String productID;
  final String productTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));

    return userInfo.when(
      data: (user) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: InkWell(
            onTap: () {
              print('in chatTile page uid: $userId');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          userId: userId,
                          imageurl: user.profilePicUrl,
                          productID: productID,
                          productTitle: productTitle,
                        )),
              );
            },
            child: Row(
              children: [
                // Profile Pic
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.profilePicUrl),
                ),
                const SizedBox(width: 10),
                // Column (Name + Last Message + Last Message Timetstamp)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Listing Title:'),
                          const SizedBox(width: 5),
                          Text(
                            productTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Last Message + Ts
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  lastMessage,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 159, 159, 159),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Text(' → '),
                              Text(
                                lastMessageTs.jm(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 159, 159, 159),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Message status
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFA5ABB3),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}

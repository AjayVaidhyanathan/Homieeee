import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/modals/change_status.dart';
import 'package:homieeee/new_chat/presentation/widgets/chats_user_info.dart';
import 'package:homieeee/new_chat/presentation/widgets/messages_list.dart';
import 'package:homieeee/new_chat/provider/chat_provider.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen(
      {super.key,
      required this.userId,
      this.imageurl,
      this.productID,
      this.productTitle});

  final String userId;
  final String? imageurl;
  final String? productID;
  final String? productTitle;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController messageController;
  late final String chatroomId;

  Future<bool> doesDocumentExist(String uid, String productId) async {
    // Reference to the Firestore collection group
    var collectionGroup = FirebaseFirestore.instance.collectionGroup('active');

    // Query documents where both uid and productId match
    var querySnapshot = await collectionGroup
        .orderBy('uid', descending: false)
        .orderBy('productId', descending: false)
        .where('uid', isEqualTo: uid)
        .where('productId', isEqualTo: productId)
        .get();

    // Check if any documents are returned
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.watch(chatProvider).createChatroom(
          userId: widget.userId,
          productID: widget.productID!,
          productTitle: widget.productTitle!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        chatroomId = snapshot.data ?? 'No chatroom Id';

        return FutureBuilder(
            future: doesDocumentExist(widget.userId, widget.productID!),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the document existence future to complete
                return const CircularProgressIndicator();
              }

              // Determine whether the document exists
              bool documentExists = docSnapshot.data ?? false;

              return Scaffold(
                backgroundColor: const Color(0xFFFFFFFF),
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF0584FE),
                    ),
                  ),
                  titleSpacing: 0,
                  title: ChatUserInfo(
                    userId: widget.userId,
                  ),
                  actions: documentExists == true
                      ? [
                          TextButton(
                              onPressed: () {
                                _showReserveConfirmationDialog();
                              },
                              child: const Text('Reserved'))
                        ]
                      : [],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: MessagesList(
                        chatroomId: chatroomId,
                        imageurl: widget.imageurl!,
                      ),
                    ),
                    const Divider(),
                    _buildMessageInput(),
                  ],
                ),
              );
            });
      },
    );
  }

  // Chat Text Field
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.image,
              color: Color(0xFFA5ABB3),
            ),
            onPressed: () async {
              final image = await pickImage();
              if (image == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: image,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'image',
                  );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.videocam,
              color: Color(0xFFA5ABB3),
              size: 20,
            ),
            onPressed: () async {
              final video = await pickVideo();
              if (video == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: video,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'video',
                  );
            },
          ),
          // Text Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Aa',
                  hintStyle: TextStyle(),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Color(0xFF0584FE),
            ),
            onPressed: () async {
              // Add functionality to handle send button press
              await ref.read(chatProvider).sendMessage(
                    message: messageController.text,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                  );
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _showReserveConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(20.0), // Padding for title
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Padding for content
          title: const Text('Do you want to reserve this item for this user?'),
          content: const Text(
              'This will mark the item as reserved for this user and removes from the active listing.'), // Optional content area
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _beSuretoAgreeBeforeReserveDialog();
              }, // Close dialog on 'No'
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                print('Yes');
                Navigator.pop(context); // Close dialog on 'Yes' and reserve
                _showPickupConfirmationDialog();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showPickupConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pickup Confirmation'),
          content: const Text(
            'Have you and the other user agreed on a location and time for pickup?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAgreeBeforeReserveDialog(context);
              }, // Close dialog on 'No'
              child: const Text('No, not yet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                try {
                  updateProductStatus(widget.productID!, 'reserved');
                } catch (e) {
                  return;
                }
                _showReservationSuccessDialog(context);
              }, // Close dialog on 'Yes'
              child: const Text('Yes, confirmed'),
            ),
          ],
        );
      },
    );
  }

// All Dialog boxes
  void _showReservationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: const Text('The product has been successfully reserved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _showAgreeBeforeReserveDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent user from dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Agree Before Reserve'),
          content: const Text(
              'Please agree on a specific location and timing with the other user before making a reservation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog manually
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _beSuretoAgreeBeforeReserveDialog() async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent user from dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Besure before you reserve to the user'),
          content: const Text(
              'Please make sure that the user who gets your food is benefited.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog manually
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }
}

Future<File?> pickImage() async {
  File? image;
  final picker = ImagePicker();
  final file = await picker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 720,
    maxWidth: 720,
  );

  if (file != null) {
    image = File(file.path);
  }

  return image;
}

Future<File?> pickVideo() async {
  File? video;
  final picker = ImagePicker();
  final file = await picker.pickVideo(
    source: ImageSource.gallery,
    maxDuration: const Duration(minutes: 5),
  );

  if (file != null) {
    video = File(file.path);
  }
  return video;
}

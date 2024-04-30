import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/new_chat/constants/constants.dart';
import 'package:homieeee/new_chat/models/chatroom.dart';
import 'package:homieeee/new_chat/models/message.dart';
import 'package:uuid/uuid.dart';

String myUid = '';
class ChatRepository {
  getCurrentID() async {
    final AuthService authService = AuthService();
     myUid = authService.getCurrentUser()!.uid;
  }

  final _storage = FirebaseStorage.instance;

  Future<String> createChatroom({
    required String userId,
    required String productID,
    required String productTitle,
  }) async {
    try {
      CollectionReference chatrooms = FirebaseFirestore.instance.collection(
        FirebaseCollectionNames.chatrooms,
      );

      await getCurrentID();

      // sorted members
      final sortedMembers = [myUid, userId]..sort((a, b) => a.compareTo(b));
      print('one uid is $myUid and the other is $userId');

      // existing chatrooms
      QuerySnapshot existingChatrooms = await chatrooms
          .where(
            FirebaseFieldNames
                .productId, // Check for product ID instead of members
            isEqualTo: productID,
          )
          .where(
            FirebaseFieldNames.members,
            isEqualTo: sortedMembers,
          )
          .get();

      if (existingChatrooms.docs.isNotEmpty) {
        return existingChatrooms.docs.first.id;
      } else {
        final chatroomId = const Uuid().v1();
        final now = DateTime.now();

        Chatroom chatroom = Chatroom(
            chatroomId: chatroomId,
            lastMessage: '',
            lastMessageTs: now,
            members: sortedMembers,
            createdAt: now,
            productId: productID,
            productTitle: productTitle);
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.chatrooms)
            .doc(chatroomId)
            .set(chatroom.toMap());

        return chatroomId;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Send message
  Future<String?> sendMessage({
    required String message,
    required String chatroomId,
    required String receiverId,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      Message newMessage = Message(
        message: message,
        messageId: messageId,
        senderId: myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: 'text',
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: message,
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Send message
  Future<String?> sendFileMessage({
    required File file,
    required String chatroomId,
    required String receiverId,
    required String messageType,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      // Save to storage
      Reference ref = _storage.ref(messageType).child(messageId);
      TaskSnapshot snapshot = await ref.putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Message newMessage = Message(
        message: downloadUrl,
        messageId: messageId,
        senderId: myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: messageType,
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: 'send a $messageType',
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId)
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .update({
        FirebaseFieldNames.seen: true,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

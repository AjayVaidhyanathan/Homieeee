import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/repository/chat_repository.dart';

final chatProvider = Provider(
  (ref) => ChatRepository(),
);
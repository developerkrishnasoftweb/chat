import 'package:chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider {
  static final _fireStore = FirebaseFirestore.instance;

  static const _collectionPath = 'chat';


  static Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    required String mediaType,
  }) async {

    final chat = ChatModel(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      mediaType: mediaType,
      createdAt: DateTime.now(),
    );
    final doc = await _fireStore.collection(_collectionPath).add(chat.toJson());
    chat.copyWith(id: doc.id);

    // Adding the id to newly added collection id
    _fireStore.collection(_collectionPath).doc(doc.id).update(chat.toJson());
  }
}

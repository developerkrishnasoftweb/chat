import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/provider/user_provider.dart';
import 'package:chat/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatProvider {
  ChatProvider._();

  static final _fireStore = FirebaseFirestore.instance;

  static const collectionPath = 'chat';

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
      createdAt: Timestamp.now(),
    );
    final doc = await _fireStore.collection(collectionPath).add(chat.toJson());
    chat.id = doc.id;

    // Adding the id to newly added collection id
    await _fireStore
        .collection(collectionPath)
        .doc(doc.id)
        .update(chat.toJson());

    final receiver = await _fireStore
        .collection(UserProvider.collectionPath)
        .where('id', isEqualTo: receiverId)
        .snapshots()
        .first;
    print(receiver.docs.first);
    if (receiver.size != 0) {
      final user = ChatUserModel.fromDoc(receiver.docs.first);
      await NotificationServices.sendFCMMessage({
        "to": [user.fcmToken],
        "notification": {
          "body": message,
          "title": "You received a notification"
        },
      });
    }
  }
}

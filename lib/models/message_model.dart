import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

class ChatModel {
  String? id;
  final String senderId;
  final String receiverId;
  final String message;
  final String mediaType;
  MessageStatus status;
  final Timestamp createdAt;

  ChatModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.mediaType,
    this.status = MessageStatus.read,
    required this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      mediaType: json['mediaType'],
      status: MessageStatus.values[json['status']],
      createdAt: (json['createdAt'] as Timestamp),
    );
  }

  factory ChatModel.fromDoc(QueryDocumentSnapshot snapshot) {
    return ChatModel(
      id: snapshot.id,
      senderId: snapshot.get('senderId'),
      receiverId: snapshot.get('receiverId'),
      message: snapshot.get('message'),
      mediaType: snapshot.get('mediaType'),
      status: MessageStatus.values[snapshot.get('status')],
      createdAt: snapshot.get('createdAt') as Timestamp,
    );
  }

  ChatModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? mediaType,
    MessageStatus? status,
    Timestamp? createdAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      mediaType: mediaType ?? this.mediaType,
      status: status ?? MessageStatus.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['message'] = message;
    map['mediaType'] = mediaType;
    map['status'] = status.index;
    map['createdAt'] = createdAt;
    return map;
  }
}

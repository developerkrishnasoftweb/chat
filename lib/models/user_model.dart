import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserModel {
  String? id;
  final String name;
  final String fcmToken;
  final DateTime createdAt;

  ChatUserModel(
      {this.id,
      required this.name,
      required this.fcmToken,
      required this.createdAt});

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'],
      name: json['name'],
      fcmToken: json['fcmToken'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory ChatUserModel.fromDoc(QueryDocumentSnapshot snapshot) {
    return ChatUserModel(
      id: snapshot.id,
      name: snapshot.get('name'),
      fcmToken: snapshot.get('fcmToken'),
      createdAt: (snapshot.get('createdAt') as Timestamp).toDate(),
    );
  }

  ChatUserModel copyWith(
      {String? id,
      String? name,
      String? fcmToken,
      DateTime? createdAt}) {
    return ChatUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fcmToken'] = fcmToken;
    data['createdAt'] = createdAt;
    return data;
  }
}

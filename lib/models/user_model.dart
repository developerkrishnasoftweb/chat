import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  final String name;
  final String fcmToken;
  final DateTime createdAt;

  UserModel(
      {this.id,
      required this.name,
      required this.fcmToken,
      required this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      fcmToken: json['fcmToken'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory UserModel.fromDoc(QueryDocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      name: snapshot.get('name'),
      fcmToken: snapshot.get('fcmToken'),
      createdAt: (snapshot.get('createdAt') as Timestamp).toDate(),
    );
  }

  UserModel copyWith(
      {String? id,
      String? name,
      String? fcmToken,
      DateTime? createdAt}) {
    return UserModel(
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

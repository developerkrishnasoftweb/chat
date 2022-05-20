import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  final String name;
  final String phoneNumber;
  final String fcmToken;
  final DateTime createdAt;

  UserModel(
      {this.id,
      required this.name,
      required this.phoneNumber,
      required this.fcmToken,
      required this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      fcmToken: json['fcmToken'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory UserModel.fromDoc(QueryDocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      name: snapshot.get('name'),
      phoneNumber: snapshot.get('phoneNumber'),
      fcmToken: snapshot.get('fcmToken'),
      createdAt: (snapshot.get('createdAt') as Timestamp).toDate(),
    );
  }

  UserModel copyWith(
      {String? id,
      String? name,
      String? phoneNumber,
      String? fcmToken,
      DateTime? createdAt}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['fcmToken'] = fcmToken;
    data['createdAt'] = createdAt;
    return data;
  }
}

import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;

  final _collectionPath = 'users';

  UserModel? _user;

  String? get id => _user?.id;

  String? get name => _user?.name;

  String? get phoneNumber => _user?.phoneNumber;

  String? get fcmToken => _user?.fcmToken;

  DateTime? get createdAt => _user?.createdAt;

  void init() {}

  /// Creating new user if the fcm token is not registered already
  /// if registered then update the user
  Future<void> login({
    required String name,
    required String phoneNumber,
  }) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final users = await _fireStore
          .collection(_collectionPath)
          .where("fcmToken", isEqualTo: token)
          .get();

      if (users.docs.isNotEmpty) {
        final user = UserModel.fromDoc(users.docs.first);
        _user = user.copyWith(name: name, phoneNumber: phoneNumber);
        _fireStore
            .collection(_collectionPath)
            .doc(user.id)
            .update(_user!.toJson());
      } else {
        final user = UserModel(
          name: name,
          phoneNumber: phoneNumber,
          fcmToken: token,
          createdAt: DateTime.now(),
        );
        final doc =
            await _fireStore.collection(_collectionPath).add(user.toJson());

        _user = user.copyWith(id: doc.id);

        // Adding the id to newly added collection id
        _fireStore
            .collection(_collectionPath)
            .doc(doc.id)
            .update(_user!.toJson());
      }
    } else {
    }
  }
}

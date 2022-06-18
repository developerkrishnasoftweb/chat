import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class UserProvider {
  UserProvider._();

  static final _fireStore = FirebaseFirestore.instance;

  static const collectionPath = 'users';

  static UserModel? _user;

  static String? get id => _user?.id;

  static String? get name => _user?.name;

  static String? get fcmToken => _user?.fcmToken;

  static DateTime? get createdAt => _user?.createdAt;

  static bool get isLoggedIn => _user != null;

  /// Creating new user if the fcm token is not registered already
  /// if registered then update the user
  static Future<void> init({String name = "Anonymous"}) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final users = await _fireStore
          .collection(collectionPath)
          .where("fcmToken", isEqualTo: token)
          .get();

      if (users.docs.isNotEmpty) {
        final user = UserModel.fromDoc(users.docs.first);
        _user = user.copyWith(name: name);
        _fireStore
            .collection(collectionPath)
            .doc(user.id)
            .update(_user!.toJson());
      } else {
        final user = UserModel(
          name: name,
          fcmToken: token,
          createdAt: DateTime.now(),
        );
        final doc =
            await _fireStore.collection(collectionPath).add(user.toJson());

        _user = user.copyWith(id: doc.id);

        // Adding the id to newly added collection id
        _fireStore
            .collection(collectionPath)
            .doc(doc.id)
            .update(_user!.toJson());
      }
    }
  }
}

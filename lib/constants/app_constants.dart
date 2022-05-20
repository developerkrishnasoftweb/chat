import 'package:chat/provider/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Name of application
const String kAppName = 'Chat';

late UserProvider kUserProvider;

FlutterSecureStorage kAppStorage = const FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

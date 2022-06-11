import 'package:chat/provider/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Name of application
const String kAppName = 'Chat';

const String kFirebaseServerKey =
    "AAAAkoDaPzE:APA91bFoKBhrpWo3sBuuYOSlMXLwz5AO23hbuEgwjpdV0nwrDI7Cx4aOz8Wpk62um8h2IXQOfP5POXitlenbZBDFPxsYK_DXEhYsMrVDWDZGGqCZ2HmLUabwLM8-4qEEstIApNFjUrTE";

late UserProvider kUserProvider;

FlutterSecureStorage kAppStorage = const FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

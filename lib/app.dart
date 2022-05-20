import 'package:chat/constants/app_constants.dart';
import 'package:chat/provider/user_provider.dart';
import 'package:chat/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      builder: (context, child) {
        kUserProvider = Provider.of<UserProvider>(context, listen: false);
        return MaterialApp(
          title: kAppName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SignIn(),
        );
      },
    );
  }
}

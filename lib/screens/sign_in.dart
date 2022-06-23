import 'package:chat/provider/user_provider.dart';
import 'package:chat/screens/chat_page.dart';
import 'package:chat/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _fcmToken = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'Name (Optional)',
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text("Connect with user"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _fcmToken,
                decoration: const InputDecoration(
                  hintText: 'Enter User id token (Optional)',
                ),
              ),
            ),
            TextButton(
              onPressed: _signIn,
              child: const Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    await UserProvider.init(name: _nameCtrl.text);

    if (UserProvider.isLoggedIn) {
      if (_fcmToken.text.isNotEmpty) {
        final user = await UserProvider.getUserFrom(_fcmToken.text);
        if (user == null) {
          showMsg("User not found on the given token");
          return;
        }
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (_) =>
                ChatPage(senderId: UserProvider.id!, receiverId: user.id!),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      }
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

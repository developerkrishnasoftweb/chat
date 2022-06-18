import 'package:chat/provider/user_provider.dart';
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
                  hintText: 'Name',
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
    // final doc = await FirebaseFirestore.instance.collection('chat').get();
    // final ref = doc.docs.first.get('user') as DocumentReference<Map<String, dynamic>>;
    // final createdAt = doc.docs.first.get('createdAt') as Timestamp;
    // print(ref.path);
    // print(createdAt);
    if (!_validate()) return;
    await UserProvider.init(name: _nameCtrl.text);
    Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (_) => const HomePage()));
  }

  bool _validate() {
    if (_nameCtrl.text.isEmpty) {
      showMsg("Please enter name");
      return false;
    }
    return true;
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

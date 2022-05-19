import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
            ),
            TextFormField(
              controller: _mobileCtrl,
              decoration: const InputDecoration(
                hintText: 'Mobile',
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
    // FirebaseFirestore.instance.collection('users').doc().update(data);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:chat/constants/app_constants.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/provider/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index].data();
                print(data);
                return ListTile(
                  title: Text(data['message']),
                  subtitle: Text(
                      'From - ${data['senderId']}, To - ${data['receiverId']}'),
                  visualDensity: VisualDensity.compact,
                  dense: true,
                );
              },
              itemCount: snapshot.data!.size,
            );
          } else {
            return const Center(
              child: Text("Data not found"),
            );
          }
        },
        stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
          ChatProvider.sendMessage(
            senderId: kUserProvider.id!,
            receiverId: widget.user.id!,
            message: "Hello world",
            mediaType: "text",
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:chat/constants/app_constants.dart';
import 'package:chat/models/message_model.dart';
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
  final TextEditingController _msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  final result = snapshot.data!.docs.where((snap) {
                    final msg = ChatModel.fromDoc(snap);
                    return (msg.senderId == kUserProvider.id &&
                            msg.receiverId == widget.user.id) ||
                        (msg.receiverId == kUserProvider.id &&
                            msg.senderId == widget.user.id);
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final data = ChatModel.fromDoc(result[index]);
                      return _buildMessageWidget(data);
                    },
                    itemCount: result.length,
                  );
                } else {
                  return const Center(
                    child: Text("Data not found"),
                  );
                }
              },
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt')
                  .snapshots(),
            ),
          ),
          _input(),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(ChatModel chat) {
    final sentMessage = chat.senderId == kUserProvider.id;
    const circular = Radius.circular(20);
    final size = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return Align(
      alignment: sentMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: UnconstrainedBox(
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width * .7),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: circular,
              topLeft: circular,
              bottomLeft: sentMessage ? circular : Radius.zero,
              bottomRight: sentMessage ? Radius.zero : circular,
            ),
            color: sentMessage ? primaryColor : Colors.grey,
          ),
          child: Text(
            chat.message,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _input() {
    final primaryColor = Theme.of(context).primaryColor;
    const border = InputBorder.none;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextFormField(
                controller: _msg,
                cursorHeight: 28,
                style: const TextStyle(
                  height: 1.5,
                ),
                onEditingComplete: _sendMessage,
                decoration: const InputDecoration(
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  hintText: "Type something...",
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final msg = _msg.text.trim();
    _msg.clear();
    if (msg.isNotEmpty) {
      ChatProvider.sendMessage(
        senderId: kUserProvider.id!,
        receiverId: widget.user.id!,
        message: msg,
        mediaType: "text",
      );
    }
  }
}

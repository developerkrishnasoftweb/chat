import 'package:chat/constants/app_constants.dart';
import 'package:chat/models/user_model.dart';
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
                return ListTile(
                  title: Text(data['message']),
                  subtitle: Text('From - ${data['from']}, To - ${data['to']}'),
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
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('senderId', isEqualTo: widget.user.id)
            .where('receiverId', isEqualTo: kUserProvider.id)
            .where('senderId', isEqualTo: kUserProvider.id)
            .where('receiverId', isEqualTo: widget.user.id)
            .snapshots(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
          FirebaseFirestore.instance.collection('chat').add({
            "id": "",
            "senderId": kUserProvider.id,
            "receiverId": widget.user.id,
            "message": "Hello, World!",
            "mediaUrl": "",
            "createdAt": DateTime.now(),
          });
        },
      ),
    );
  }
}

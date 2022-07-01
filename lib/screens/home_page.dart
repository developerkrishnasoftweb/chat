import 'package:chat/models/user_model.dart';
import 'package:chat/provider/user_provider.dart';
import 'package:chat/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        elevation: 0,
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
                final user = ChatUserModel.fromDoc(snapshot.data!.docs[index]);
                return ListTile(
                  title: Text(user.name),
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => ChatPage(
                          senderId: UserProvider.id!,
                          receiverId: user.id!,
                        ),
                      ),
                    );
                  },
                  dense: true,
                  leading: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(user.name[0].toUpperCase()),
                  ),
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
            .collection('users')
            .where('fcmToken', isNotEqualTo: UserProvider.fcmToken)
            .snapshots(),
      ),
    );
  }
}

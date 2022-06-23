import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/provider/chat_provider.dart';
import 'package:chat/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.senderId, required this.receiverId})
      : super(key: key);

  /// Sender id depicts the current user who is going to send message
  final String senderId;

  /// Receiver id depicts the other user who is going to receive message
  final String receiverId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msg = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _stream = FirebaseFirestore.instance
      .collection(ChatProvider.collectionPath)
      .snapshots();

  late Stream<QuerySnapshot<Map<String, dynamic>>> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseFirestore.instance
        .collection(UserProvider.collectionPath)
        .where('id', isEqualTo: widget.receiverId)
        .snapshots();
    // _stream.listen((querySnap) {
    //   if (querySnap.docs.isNotEmpty) {
    //     for (var doc in querySnap.docs) {
    //       final chat = ChatModel.fromDoc(doc)..status = MessageStatus.read;
    //       FirebaseFirestore.instance
    //           .collection('chat')
    //           .doc(doc.id)
    //           .update(chat.toJson());
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _userStream,
      builder: (_, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (userSnapshot.hasData && userSnapshot.data!.docs.isNotEmpty) {
          final user = UserModel.fromDoc(userSnapshot.data!.docs.first);
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    builder: (context, chatsSnapshot) {
                      if (chatsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (chatsSnapshot.hasData) {
                        final result = chatsSnapshot.data!.docs.where((snap) {
                          final msg = ChatModel.fromDoc(snap);
                          return (msg.senderId == widget.senderId &&
                                  msg.receiverId == widget.receiverId) ||
                              (msg.receiverId == widget.senderId &&
                                  msg.senderId == widget.receiverId);
                        }).toList()
                          ..sort((a, b) {
                            final createdAt1 =
                                a.data()['createdAt'] as Timestamp;
                            final createdAt2 =
                                b.data()['createdAt'] as Timestamp;
                            return createdAt1.compareTo(createdAt2);
                          });

                        return ListView.builder(
                          controller: _scrollController,
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
                    stream: _stream,
                  ),
                ),
                _input(),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text("Data not found"),
          );
        }
      },
    );
  }

  Widget _buildMessageWidget(ChatModel chat) {
    final sentMessage = chat.senderId == widget.senderId;
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
                textInputAction: TextInputAction.send,
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

  void _sendMessage() async {
    final msg = _msg.text.trim();
    _msg.clear();
    if (msg.isNotEmpty) {
      await ChatProvider.sendMessage(
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        message: msg,
        mediaType: "text/plain",
      );
    }
    await Future.delayed(const Duration(seconds: 1));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 200), curve: Curves.easeIn);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/services/chat_service.dart';
import 'package:messenger/widget/chat_bubble.dart';
import 'package:messenger/widget/my_text_field.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiverUserID;
  const ChatPage(
      {super.key,
      required this.receiveruserEmail,
      required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveruserEmail),
      ),
      body: Column(children: [
        Expanded(
          child: _bildMessageList(),
        ),
        _buildMessangeInput(),
        const SizedBox(height: 25)
      ]),
    );
  }

  Widget _bildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
              children: snapshot.data!.docs
                  .map(
                    (document) => _buildMessageItem(document),
                  )
                  .toList());
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var aligment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: aligment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              Text(
                data['senderEmail'],
              ),
              const SizedBox(height: 5),
              ChatBubble(
                message: data['message'],
              ),
            ]),
      ),
    );
  }

  Widget _buildMessangeInput() {
    return Row(
      children: [
        Expanded(
            child: MTF(
          controller: _messageController,
          hintText: 'Enter message',
          obscureText: false,
        )),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ))
      ],
    );
  }
}

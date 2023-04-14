import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/mini_widget/message_bundle.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';

class ChatPage extends StatefulWidget {
  final String idroom;
  const ChatPage({Key? key, required this.idroom}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userInfo = Get.put(UserState());
  // Thay thế bằng ID phòng chat của bạn
  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore
          .collection('chatroom')
          .doc(widget.idroom.trim())
          .collection('messages')
          .add({
        'text': _messageController.text,
        'from': userInfo.user.value!.name,
        'id': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chatroom')
                  .doc(widget.idroom.trim())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      final String currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      final bool isCurrentUser = doc['id'] == currentUserId;

                      return MessageBubble(
                        text: doc['text'],
                        senderId: doc['from'],
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value){sendMessage();},
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

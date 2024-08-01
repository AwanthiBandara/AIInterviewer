import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/models/message_model.dart';
import 'package:aiinterviewer/constants/colors.dart';

class ChatScreen extends StatefulWidget {
  final String chatDocumentId;

  const ChatScreen({super.key, required this.chatDocumentId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String userUid;

  @override
  void initState() {
    super.initState();
    // Retrieve user ID from AppCubit
    final appCubit = BlocProvider.of<AppCubit>(context);
    userUid = appCubit.state.userInfo.uid;
  }

  Stream<List<Map<String, dynamic>>> _getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatDocumentId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      final messages = data?['data'] as List<dynamic>? ?? [];
      return messages.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: cardColor,
        title: Text("Chat", style: TextStyle(color: greyTextColor, fontSize: 16)),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_new_rounded, color: greyTextColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final messages = snapshot.data ?? [];

                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  physics: BouncingScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageMap = messages[index];
                    final message = MessageModel.fromMap(messageMap);

                    return Align(
                      alignment: message.sender == userUid ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: message.sender == userUid ? secondaryColor.withOpacity(0.2) : inCardColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message.message,
                          style: TextStyle(fontSize: 16.0, color: greyTextColor),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: inCardColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: white),
                    cursorColor: white,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: grayColor),
                      filled: true,
                      fillColor: inCardColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    final messageText = _messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      final message = MessageModel(
                        message: messageText,
                        sender: userUid,
                        dateTime: Timestamp.now(),
                      );

                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.chatDocumentId)
                          .update({
                        'data': FieldValue.arrayUnion([message.toMap()])
                      }).then((_) {
                        _messageController.clear();
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: inCardColor,
                    child: Icon(Icons.send, color: white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

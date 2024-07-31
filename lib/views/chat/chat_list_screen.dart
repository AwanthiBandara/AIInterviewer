import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/views/chat/chat_screen.dart';
import 'package:aiinterviewer/constants/colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: cardColor,
        title: Text("Chat", style: TextStyle(color: white, fontSize: 16)),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios_new_rounded, color: greyTextColor),
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final currentUserId = state.userInfo.uid;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('chats').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final chatDocs = snapshot.data?.docs ?? [];

              final filteredChats = chatDocs.where((doc) {
                final documentId = doc.id;
                final parts = documentId.split('_');
                return parts.contains(currentUserId);
              }).toList();

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: filteredChats.length,
                itemBuilder: (context, index) {
                  final chatDoc = filteredChats[index];
                  final data = chatDoc.data() as Map<String, dynamic>?;

                  if (data != null && data.containsKey('data')) {
                    final List<dynamic> messageList = data['data'] as List<dynamic>;
                    final lastMessage = messageList.isNotEmpty
                        ? (messageList.last as Map<String, dynamic>)['message'] ?? ''
                        : 'No messages yet';

                    // Convert dateTime field to a DateTime object
                    final lastMessageTime = messageList.isNotEmpty
                        ? (messageList.last as Map<String, dynamic>)['dateTime'] is Timestamp
                            ? (messageList.last as Map<String, dynamic>)['dateTime']?.toDate()?.toLocal()?.toString() ?? ''
                            : DateTime.tryParse((messageList.last as Map<String, dynamic>)['dateTime'] as String)?.toLocal()?.toString() ?? ''
                        : 'No messages yet';

                    final username = 'User ${index + 1}'; // Replace with actual username if available

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatDocumentId: chatDoc.id, // Pass the chat document ID
                            ),
                          ),
                        );
                      },
                      child: ChatListItem(
                        username: username,
                        lastMessage: lastMessage,
                        lastMessageTime: lastMessageTime,
                        profileImageUrl: 'https://picsum.photos/536/354', // Placeholder image URL
                      ),
                    );
                  } else {
                    return Container(); // Handle empty data case
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String username;
  final String lastMessage;
  final String lastMessageTime;
  final String profileImageUrl;

  const ChatListItem({
    Key? key,
    required this.username,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(profileImageUrl),
            backgroundColor: cardColor,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(username,
                        style: TextStyle(color: greyTextColor, fontSize: 18)),
                    Text(lastMessageTime,
                        style: TextStyle(color: greyTextColor, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 4),
                Text(lastMessage,
                    style: TextStyle(color: greyTextColor, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

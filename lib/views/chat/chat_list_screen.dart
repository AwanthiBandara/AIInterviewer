import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/chat_bloc/chat_cubit.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:aiinterviewer/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: cardColor,
        title: Text("Chats", style: TextStyle(color: white, fontSize: 16)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          UserInfoModel userInfo = BlocProvider.of<AppCubit>(context).state.userInfo;
          final currentUserId = userInfo.uid;

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

              filteredChats.sort((a, b) {
                final dataA = a.data() as Map<String, dynamic>;
                final dataB = b.data() as Map<String, dynamic>;
                final List<dynamic> messageListA = dataA['data'] as List<dynamic>;
                final List<dynamic> messageListB = dataB['data'] as List<dynamic>;

                final latestMessageTimeA = messageListA.isNotEmpty
                    ? (messageListA.last as Map<String, dynamic>)['dateTime'] is Timestamp
                        ? (messageListA.last as Map<String, dynamic>)['dateTime'].toDate()
                        : DateTime.parse((messageListA.last as Map<String, dynamic>)['dateTime'] as String)
                    : DateTime(0);

                final latestMessageTimeB = messageListB.isNotEmpty
                    ? (messageListB.last as Map<String, dynamic>)['dateTime'] is Timestamp
                        ? (messageListB.last as Map<String, dynamic>)['dateTime'].toDate()
                        : DateTime.parse((messageListB.last as Map<String, dynamic>)['dateTime'] as String)
                    : DateTime(0);

                return latestMessageTimeB.compareTo(latestMessageTimeA);
              });

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: filteredChats.length,
                itemBuilder: (context, index) {
                  final chatDoc = filteredChats[index];
                  final data = chatDoc.data() as Map<String, dynamic>?;

                  if (data != null && data.containsKey('data')) {
                    final List<dynamic> messageList = data['data'] as List<dynamic>;
                    final latestMessage = messageList.isNotEmpty
                        ? (messageList.last as Map<String, dynamic>)['message'] ?? ''
                        : 'No messages yet';

                    final latestMessageTime = messageList.isNotEmpty
                        ? timeAgo(
                            (messageList.last as Map<String, dynamic>)['dateTime'] is Timestamp
                                ? (messageList.last as Map<String, dynamic>)['dateTime'].toDate()
                                : DateTime.parse((messageList.last as Map<String, dynamic>)['dateTime'] as String),
                          )
                        : 'No messages yet';

                    // Extract other user ID from the chat document ID
                    final otherUserId = chatDoc.id.split('_').firstWhere((id) => id != currentUserId);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return Container(); // Return an empty container while waiting for user data
                        }

                        if (userSnapshot.hasError) {
                          return Center(child: Text('Error: ${userSnapshot.error}'));
                        }

                        final userData = userSnapshot.data?.data() as Map<String, dynamic>?;

                        if (userData != null) {
                          final username = '${userData['firstName']} ${userData['lastName']}';
                          final profileImageUrl = userData['userType'] == "job_seeker" ? userData['profileUrl'] : userData['companyLogoUrl'] ?? 'https://picsum.photos/536/354';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatDocumentId: chatDoc.id, // Pass the chat document ID
                                    username: username,
                                    profileUrl: profileImageUrl,
                                  ),
                                ),
                              );
                            },
                            child: ChatListItem(
                              username: username,
                              lastMessage: latestMessage,
                              lastMessageTime: latestMessageTime,
                              profileImageUrl: profileImageUrl,
                            ),
                          );
                        } else {
                          return Container(); // Handle empty user data case
                        }
                      },
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
      color: Colors.transparent,
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
                        style: TextStyle(
                            color: greyTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
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

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/models/chat_model.dart';
import 'package:aiinterviewer/models/message_model.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final CollectionReference chatCollection;

  ChatCubit()
      : chatCollection = FirebaseFirestore.instance.collection('chats'),
        super(ChatState(isLoading: false));

  Future<void> loadMyAllChats(BuildContext context) async {
    emit(state.copyWith(isLoading: true));

    final currentUserId = BlocProvider.of<AppCubit>(context).state.userInfo.uid;

    try {
      // Load chats from cache
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedChatsJson = prefs.getString('cachedChats');
      if (cachedChatsJson != null) {
        List<dynamic> cachedChatsList = jsonDecode(cachedChatsJson);
        List<ChatModel> cachedChats = cachedChatsList
            .map((chatJson) => ChatModel.fromMap(chatJson as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(isLoading: false, chats: cachedChats));
      }

      // Fetch all chat documents
      final chatDocs = await chatCollection.get();

      final List<ChatModel> chats = [];

      for (var chatDoc in chatDocs.docs) {
        final chatDocumentId = chatDoc.id;

        // Check if the current user is part of the chat
        if (chatDocumentId.contains(currentUserId)) {
          // Extract the other user's UID by checking both possible positions
          final splitIds = chatDocumentId.split('_');
          String otherUserId;
          if (splitIds[0] == currentUserId) {
            otherUserId = splitIds[1];
          } else {
            otherUserId = splitIds[0];
          }

          // Fetch other user's information
          final otherUserDoc = await FirebaseFirestore.instance.collection('users').doc(otherUserId).get();
          final otherUserData = otherUserDoc.data() as Map<String, dynamic>;

          final otherUser = UserInfoModel.fromJson(otherUserData);

          // Fetch messages for this chat
          final chatData = chatDoc.data() as Map<String, dynamic>?;
          final messagesData = chatData != null ? chatData['data'] as List<dynamic>? ?? [] : [];
          final messages = messagesData
              .map((messageMap) => MessageModel.fromMap(messageMap as Map<String, dynamic>))
              .toList();

          // Create a ChatModel instance with the other user's info and messages
          final chat = ChatModel(
            id: chatDocumentId,
            otherUser: otherUser,
            messages: messages,
            lastMessage: chatData != null ? chatData['lastMessage'] ?? '' : '',
          );

          chats.add(chat);
        }
      }

      // Save chats to cache
      String chatsJson = jsonEncode(chats.map((chat) => chat.toMap()).toList());
      await prefs.setString('cachedChats', chatsJson);

      emit(state.copyWith(isLoading: false, chats: chats));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createChat(String chatId, String applicantId) async {
    // Fetch the other user's data from Firestore
    final otherUserDoc = await FirebaseFirestore.instance.collection('users').doc(applicantId).get();
    final otherUserData = otherUserDoc.data() as Map<String, dynamic>;

    final otherUser = UserInfoModel.fromJson(otherUserData);

    // Create a new ChatModel with the necessary data
    final newChat = ChatModel(
      id: chatId,
      otherUser: otherUser,
      messages: [],
      lastMessage: '',
    );

    // Save the new chat to the database
    await FirebaseFirestore.instance.collection('chats').doc(chatId).set(newChat.toMap());

    // Update the state with the new chat
    final updatedChats = List<ChatModel>.from(state.chats ?? [])..add(newChat);
    
    // Save the updated chats to cache
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String chatsJson = jsonEncode(updatedChats.map((chat) => chat.toMap()).toList());
    await prefs.setString('cachedChats', chatsJson);

    emit(state.copyWith(chats: updatedChats));
  }
}

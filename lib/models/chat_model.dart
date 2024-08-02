import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiinterviewer/models/message_model.dart'; // Adjust the import path as necessary

class ChatModel {
  final String id;
  final UserInfoModel otherUser;
  final List<MessageModel> messages;
  final String lastMessage;
  final Timestamp lastMessageTime;

  ChatModel({
    required this.id,
    required this.otherUser,
    required this.messages,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      otherUser: UserInfoModel.fromJson(map['otherUser'] as Map<String, dynamic>),
      messages: (map['messages'] as List<dynamic>? ?? [])
          .map((msgMap) => MessageModel.fromMap(msgMap as Map<String, dynamic>))
          .toList(),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] is Timestamp
          ? map['lastMessageTime'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(map['lastMessageTime'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'otherUser': otherUser.toJson(),
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toDate().toIso8601String(),
    };
  }

  ChatModel copyWith({
    String? id,
    UserInfoModel? otherUser,
    List<MessageModel>? messages,
    String? lastMessage,
    Timestamp? lastMessageTime,
  }) {
    return ChatModel(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      messages: messages ?? this.messages,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}



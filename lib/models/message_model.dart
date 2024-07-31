import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String sender;
  final Timestamp dateTime;

  MessageModel({
    required this.message,
    required this.sender,
    required this.dateTime,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] ?? '',
      sender: map['sender'] ?? '',
      dateTime: map['dateTime'] is Timestamp 
          ? map['dateTime'] as Timestamp 
          : Timestamp.fromDate(DateTime.parse(map['dateTime'])), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender': sender,
      'dateTime': dateTime.toDate().toIso8601String(),
    };
  }
}

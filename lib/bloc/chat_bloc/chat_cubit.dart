import 'package:aiinterviewer/models/message_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  String? user1Uid;
  String? user2Uid;
  final CollectionReference chatCollection;

  ChatCubit()
      : chatCollection = FirebaseFirestore.instance.collection('chats'),
        super(ChatState(isLoading: false));

  Future<void> loadMessages() async {
    emit(ChatLoading());

    if (user1Uid == null || user2Uid == null) {
      emit(ChatError(error: "User IDs not set."));
      return;
    }

    try {
      // Check both possible document IDs
      final documentId1 = '${user1Uid}_${user2Uid}';
      final documentId2 = '${user2Uid}_${user1Uid}';

      final documentSnapshot1 = await chatCollection.doc(documentId1).get();
      final documentSnapshot2 = await chatCollection.doc(documentId2).get();

      Map<String, dynamic>? data;
      List<dynamic>? messageList;

      if (documentSnapshot1.exists) {
        data = documentSnapshot1.data() as Map<String, dynamic>?;
        messageList = data?['data'] as List<dynamic>;
      } else if (documentSnapshot2.exists) {
        data = documentSnapshot2.data() as Map<String, dynamic>?;
        messageList = data?['data'] as List<dynamic>;
      }

      if (messageList != null) {
        final messages = messageList
            .map((messageMap) => MessageModel.fromMap(messageMap as Map<String, dynamic>))
            .toList();

        emit(ChatLoaded(messages: messages));
      } else {
        emit(ChatLoaded(messages: []));
      }
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  Future<void> sendMessage(String messageText, String senderUid) async {
    if (user1Uid == null || user2Uid == null) {
      emit(ChatError(error: "User IDs not set."));
      return;
    }

    try {
      final documentId1 = '${user1Uid}_${user2Uid}';
      final documentId2 = '${user2Uid}_${user1Uid}';
      final message = MessageModel(
        message: messageText,
        sender: senderUid,
        dateTime: Timestamp.now(),
      );

      // Add message to the document that exists
      await Future.wait([
        chatCollection.doc(documentId1).update({
          'data': FieldValue.arrayUnion([message.toMap()])
        }).catchError((_) {
          // If the document doesn't exist, try the other document ID
          chatCollection.doc(documentId2).update({
            'data': FieldValue.arrayUnion([message.toMap()])
          });
        }),
        chatCollection.doc(documentId2).update({
          'data': FieldValue.arrayUnion([message.toMap()])
        }).catchError((_) {
          // If the document doesn't exist, the previous catchError will handle it
        }),
      ]);

      loadMessages(); // Reload messages after sending
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  void setUserIds(String user1, String user2) {
    user1Uid = user1;
    user2Uid = user2;
  }
}

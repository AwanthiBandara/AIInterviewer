part of 'chat_cubit.dart';

class ChatState {
  final bool isLoading;
  final String? errorMessage;
  final List<ChatModel>? chats;

  ChatState({
    required this.isLoading,
    this.errorMessage,
    this.chats,
  });

  ChatState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ChatModel>? chats,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      chats: chats ?? this.chats,
    );
  }
}

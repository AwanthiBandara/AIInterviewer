part of 'chat_cubit.dart';

class ChatState {
  final bool isLoading;
  final String? errorMessage;
  final List<MessageModel>? messages;

  ChatState({
    required this.isLoading,
    this.errorMessage,
    this.messages,
  });

  ChatState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MessageModel>? messages,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      messages: messages ?? this.messages,
    );
  }
}

class ChatLoading extends ChatState {
  ChatLoading() : super(isLoading: true);
}

class ChatLoaded extends ChatState {
  ChatLoaded({required List<MessageModel> messages})
      : super(isLoading: false, messages: messages);
}

class ChatError extends ChatState {
  ChatError({required String error}) : super(isLoading: false, errorMessage: error);
}

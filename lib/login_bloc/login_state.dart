part of 'login_cubit.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({
    required this.isLoading,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

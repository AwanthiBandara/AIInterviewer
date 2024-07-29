part of 'signup_cubit.dart';

class SignupState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  SignupState({
    required this.isLoading,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

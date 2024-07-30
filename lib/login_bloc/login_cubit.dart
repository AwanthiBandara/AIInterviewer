import 'package:aiinterviewer/views/recruiter/recruiter_main_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(isLoading: false));

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Authenticate user with FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user is successfully authenticated
      User? user = userCredential.user;
      if (user != null) {
        // Handle successful login (e.g., navigate to another screen)
        emit(state.copyWith(isLoading: false));
        // Example: Navigate to HomeScreen or another page after successful login
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RecruiterMainScreen()));
      }
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      emit(state.copyWith(isLoading: false, errorMessage: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      // Handle any other errors
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}

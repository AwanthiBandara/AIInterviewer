import 'dart:convert';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_main_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_main_screen.dart';
import 'package:aiinterviewer/widgets/screen_loading.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(isLoading: false));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    Loading().startLoading(context);
    try {
      // Authenticate user with FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user is successfully authenticated
      User? user = userCredential.user;
      if (user != null) {
        // Retrieve user information from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(user.uid).get();

        // Check if user document exists
        if (userDoc.exists) {
          UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data()!);


          // Cache the user information in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String userInfoJson = jsonEncode(userInfo.toJson());
          await prefs.setString('user_info', userInfoJson);

          emit(state.copyWith(isLoading: false));
          Loading().stopLoading(context);

          // Navigate to the appropriate screen based on user type
          if (userInfo.userType == 'recruiter') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RecruiterMainScreen()));
          } else if (userInfo.userType == 'job_seeker') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SeekerMainScreen()));
          } else {
            // Handle unexpected user types or navigate to a default screen
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        } else {
          emit(state.copyWith(isLoading: false, errorMessage: 'User document does not exist.'));
          Loading().stopLoading(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      emit(state.copyWith(isLoading: false, errorMessage: e.message ?? 'An unknown error occurred'));
      Loading().stopLoading(context);
    } catch (e) {
      // Handle any other errors
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      Loading().stopLoading(context);
    }
  }
}

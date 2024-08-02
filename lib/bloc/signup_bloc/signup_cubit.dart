import 'dart:convert';
import 'dart:io';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_main_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_main_screen.dart';
import 'package:aiinterviewer/widgets/screen_loading.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;


part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState(isLoading: false));

  Future<void> recruiterSignup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String currentPosition,
    required String companyName,
    required String companyLocation,
    required String companySize,
    required String aboutCompany,
    File? companyImage,
    required BuildContext context,  // Pass context as a required parameter
  }) async {
    emit(state.copyWith(isLoading: true));
    Loading().startLoading(context);
    try {
      // Create a user with FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Upload company image if available
        String? companyImageUrl;
        if (companyImage != null) {
          companyImageUrl = await _uploadCompanyImage(user.uid, companyImage);
        }

        // Create UserInfoModel object
        UserInfoModel userInfo = UserInfoModel(
          uid: user.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          userType: 'recruiter',
          birthday: Timestamp.fromDate(DateTime.now()), 
          profileUrl: '',
          gender: '', // Placeholder for gender
          currentPosition: currentPosition,
          companyLogoUrl: companyImageUrl ?? '',
          companyName: companyName,
          companyLocation: companyLocation,
          companySize: companySize,
          aboutCompany: aboutCompany,
        );

        // Save user info to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userInfo.toJson());

        // Save user info to SharedPreferences as a JSON string
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userInfoJson = jsonEncode(userInfo.toJson());
        await prefs.setString('user_info', userInfoJson);

        emit(state.copyWith(isLoading: false, isSuccess: true));
        print('Signup successful!');
        Loading().stopLoading(context);
        // Navigate to MainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecruiterMainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message ?? 'An unknown error occurred'));
      Loading().stopLoading(context);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      Loading().stopLoading(context);
    }
  }

  Future<String> _uploadCompanyImage(String uid, File companyImage) async {
    try {
      String filePath = 'companyLogos/$uid.png';
      await FirebaseStorage.instance.ref(filePath).putFile(companyImage);
      String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

//   Future<String> _uploadProfileImage(String uid, File profileImage) async {
//   try {
//     String filePath = 'profileImages/$uid.png';
//     await FirebaseStorage.instance.ref(filePath).putFile(profileImage);
//     String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
//     return downloadUrl;
//   } catch (e) {
//     throw Exception('Error uploading image: $e');
//   }
// }

Future<String> _uploadProfileImage(String uid, File profileImage) async {
  try {
    // Load the image
    img.Image? image = img.decodeImage(profileImage.readAsBytesSync());
    
    // Resize the image to a smaller size
    img.Image resizedImage = img.copyResize(image!, width: 100); // Resize to 100 pixels wide (maintaining aspect ratio)
    
    // Compress the image to reduce file size
    List<int> compressedImage = img.encodeJpg(resizedImage, quality: 25); // Adjust quality as needed
    
    // Convert to Uint8List
    Uint8List uint8list = Uint8List.fromList(compressedImage);

    // Upload the compressed image
    String filePath = 'profileImages/$uid.png';
    await FirebaseStorage.instance.ref(filePath).putData(uint8list);
    String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return downloadUrl;
  } catch (e) {
    throw Exception('Error uploading image: $e');
  }
}

Future<void> seekerSignup({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String currentPosition,
  required String birthday,
  required String gender,
  File? profileImage,
  required BuildContext context, // Pass context as a required parameter
}) async {
  // Assuming you have a method to emit states like in a Bloc or Cubit
  emit(state.copyWith(isLoading: true));
  try {
    // Create a user with FirebaseAuth
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      // Upload profile image if available
      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(user.uid, profileImage);
      }

      // Parse the birthday to a DateTime object
      DateTime birthdayDate = DateTime.parse(birthday);

      // Create UserInfoModel object
      UserInfoModel userInfo = UserInfoModel(
        uid: user.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        userType: 'job_seeker',
        birthday: Timestamp.fromDate(birthdayDate),
        profileUrl: profileImageUrl ?? '',
        gender: gender,
        currentPosition: currentPosition,
        companyLogoUrl: '',
        companyName: '',
        companyLocation: '',
        companySize: '',
        aboutCompany: '',
      );

      // Save user info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userInfo.toJson());

      // Save user info to SharedPreferences as a JSON string
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userInfoJson = jsonEncode(userInfo.toJson());
      await prefs.setString('user_info', userInfoJson);

      emit(state.copyWith(isLoading: false, isSuccess: true));
      print('Signup successful!');
      // Navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SeekerMainScreen()),
      );
    }
  } on FirebaseAuthException catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.message ?? 'An unknown error occurred'));
  } catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
}
}

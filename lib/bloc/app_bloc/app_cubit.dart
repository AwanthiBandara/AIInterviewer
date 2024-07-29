import 'dart:convert';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCubit extends Cubit<AppState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppCubit()
      : super(AppState(
            isLoading: false,
            userInfo: UserInfoModel(
              firstName: '',
              lastName: '',
              email: '',
              uid: '',
              aboutCompany: '',
              birthday: Timestamp.fromDate(DateTime.now()),
              companyLocation: '',
              companyLogoUrl: '',
              companyName: '',
              companySize: '',
              currentPosition: '',
              gender: '',
              profileUrl: '',
              userType: ''
            ),
            currentTabIndex: 0,
            jobs: []
          )) {
    _loadUserInfo();
    _loadJobs();
  }

  void setCurrentTabIndex(int currentTabIndex) {
    emit(state.copyWith(currentTabIndex: currentTabIndex));
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('user_info');
    if (userInfoJson != null) {
      try {
        Map<String, dynamic> userMap = jsonDecode(userInfoJson);
        UserInfoModel userInfo = UserInfoModel.fromJson(userMap);
        emit(state.copyWith(userInfo: userInfo));
      } catch (e) {
        // Handle JSON decode error
        emit(state.copyWith(
          userInfo: UserInfoModel(
            firstName: 'User',
            lastName: '',
            email: '',
            uid: '',
            aboutCompany: '',
            birthday: Timestamp.fromDate(DateTime.now()),
            companyLocation: '',
            companyLogoUrl: '',
            companyName: '',
            companySize: '',
            currentPosition: '',
            gender: '',
            profileUrl: '',
            userType: ''
          ),
          error: 'Error decoding user info: $e'
        ));
        print('Error decoding user info: $e');
      }
    } else {
      // Fetch from Firestore if not cached
      await _fetchUserInfoFromFirestore();
    }
  }

  Future<void> _fetchUserInfoFromFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          UserInfoModel userInfo = UserInfoModel.fromJson(doc.data()!);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_info', jsonEncode(userInfo.toJson()));
          emit(state.copyWith(userInfo: userInfo));
        } else {
          emit(state.copyWith(
            userInfo: UserInfoModel(
              firstName: 'User',
              lastName: '',
              email: '',
              uid: '',
              aboutCompany: '',
              birthday: Timestamp.fromDate(DateTime.now()),
              companyLocation: '',
              companyLogoUrl: '',
              companyName: '',
              companySize: '',
              currentPosition: '',
              gender: '',
              profileUrl: '',
              userType: ''
            ),
            error: 'User document does not exist'
          ));
        }
      } else {
        emit(state.copyWith(
          userInfo: UserInfoModel(
            firstName: 'User',
            lastName: '',
            email: '',
            uid: '',
            aboutCompany: '',
            birthday: Timestamp.fromDate(DateTime.now()),
            companyLocation: '',
            companyLogoUrl: '',
            companyName: '',
            companySize: '',
            currentPosition: '',
            gender: '',
            profileUrl: '',
            userType: ''
          ),
          error: 'No logged-in user'
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to fetch user info from Firestore: $e'
      ));
    }
  }

  Future<void> _loadJobs() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedJobs = prefs.getString('jobs');

      if (cachedJobs != null) {
        List<dynamic> cachedList = jsonDecode(cachedJobs);
        List<JobModel> jobs = cachedList.map((job) => JobModel.fromJson(job)).toList();
        emit(state.copyWith(jobs: jobs, isLoading: false));
        // Optionally fetch from Firestore to update cache
        _fetchJobsFromFirestore();
      } else {
        _fetchJobsFromFirestore(); // Fetch from Firestore if not cached
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load jobs: $e'
      ));
    }
  }

  Future<void> _fetchJobsFromFirestore() async {
  try {
    // Fetch jobs from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('jobs').get();

    // Convert Firestore documents to JobModel instances
    List<JobModel> jobs = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return JobModel.fromJson(data);
    }).toList();

    // Cache the fetched jobs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jobs', jsonEncode(jobs.map((job) => job.toJson()).toList()));

    // Emit state with fetched jobs and loading set to false
    emit(state.copyWith(
      jobs: jobs,
      isLoading: false
    ));
  } catch (e) {
    // Emit state with error message and loading set to false
    emit(state.copyWith(
      isLoading: false,
      error: 'Failed to fetch jobs from Firestore: $e'
    ));
  }
}


  Future<void> updateUserInfo(String firstName, String lastName) async {
    final currentState = state;
    final updatedUserInfo = currentState.userInfo.copyWith(
      firstName: firstName,
      lastName: lastName,
    );

    // Update the state
    emit(currentState.copyWith(userInfo: updatedUserInfo));

    // Update the cache
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_info', jsonEncode(updatedUserInfo.toJson()));
    } catch (e) {
      emit(currentState.copyWith(error: 'Failed to update user info cache: $e'));
    }
  }
}

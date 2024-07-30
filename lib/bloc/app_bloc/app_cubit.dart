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
  static const String _cacheKey = 'cached_jobs';

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
            jobs: [], interviewTypes: [], searchTextList: []
          )) {
    _loadUserInfo();
    _loadJobs();
    _loadInterviewTypes();
    _loadSearchTextList();
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

  Future<void> _loadInterviewTypes() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedInterviewTypes = prefs.getString('interview_types');

      if (cachedInterviewTypes != null) {
        List<dynamic> cachedList = jsonDecode(cachedInterviewTypes);
        List<String> interviewTypes = List<String>.from(cachedList);
        emit(state.copyWith(interviewTypes: interviewTypes, isLoading: false));
        // Fetch from Firestore to update cache (if needed)
        _fetchInterviewTypesFromFirestore();
      } else {
        _fetchInterviewTypesFromFirestore(); // Fetch from Firestore if not cached
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load categories: $e'));
    }
  }

  Future<void> _fetchInterviewTypesFromFirestore() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('interviewTypes').doc('interviewTypes').get();
      if (doc.exists) {
        List<String> interviewTypes = List<String>.from(doc.data()?['data'] ?? []);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('interview_types', jsonEncode(interviewTypes));
        emit(state.copyWith(interviewTypes: interviewTypes, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: 'Categories document does not exist'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to fetch categories from Firestore: $e'));
    }
  }

   Future<void> _loadSearchTextList() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedSearchTextList = prefs.getString('searchTextList');

      if (cachedSearchTextList != null) {
        List<dynamic> cachedList = jsonDecode(cachedSearchTextList);
        List<String> searchTextList = List<String>.from(cachedList);
        emit(state.copyWith(searchTextList: searchTextList, isLoading: false));
      } else {
        _updateSearchTextList();
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load search text list: $e'));
    }
  }

    Future<void> _updateSearchTextList() async {
    try {
      List<String> searchTextList = [
        ...state.interviewTypes
      ];

      // Cache search text list
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('searchTextList', jsonEncode(searchTextList));

      // Emit the updated state
      emit(state.copyWith(searchTextList: searchTextList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to update search text list: $e'));
    }
  }

  Future<void> createJob({
  required String jobTitle,
  required String jobDescription,
  required String interviewType,
}) async {
  emit(state.copyWith(isLoading: true));
  try {
    // Get the current user UID
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(state.copyWith(isLoading: false, error: 'User not logged in'));
      return;
    }
    
    String createdBy = currentUser.uid; // Get the UID

    DocumentReference docRef = await _firestore.collection('jobs').add({
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'interviewType': interviewType,
      'applicants': [], // Initially empty array
    });

    JobModel newJob = JobModel(
      jobId: docRef.id,
      jobTitle: jobTitle,
      jobDescription: jobDescription,
      createdAt: Timestamp.now(),
      createdBy: createdBy,
      applicants: [], 
      interviewType: interviewType,
    );

    await docRef.update({'jobId': docRef.id});
    
    emit(state.copyWith(isLoading: false));
    _fetchJobsAndUpdateCache(); // Refresh the list of posts
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: 'Failed to create post: $e'));
  }
}

Future<void> _fetchJobsAndUpdateCache() async {
  emit(state.copyWith(isLoading: true));
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('jobs').get();

    List<JobModel> jobs = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      String createdBy = data['createdBy'] as String;

      // Fetch user info for each post
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(createdBy).get();
      final userData = userDoc.data() ?? {};
      String firstName = userData['firstName'] ?? '';
      String lastName = userData['lastName'] ?? '';

      // Create PostModel with additional fields
      JobModel job = JobModel.fromJson(data).copyWith(
        firstName: firstName,
        lastName: lastName,
      );

      jobs.add(job);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jobsJson = jsonEncode(jobs.map((job) => job.toJson()).toList());
    await prefs.setString(_cacheKey, jobsJson);

    emit(state.copyWith(jobs: jobs, isLoading: false));
  } catch (e) {
    print('Error fetching posts: $e'); // Detailed error logging
    emit(state.copyWith(isLoading: false, error: 'Failed to fetch jobs'));
  }
}
}

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/bloc/chat_bloc/chat_cubit.dart';
import 'package:aiinterviewer/constants/data.dart';
import 'package:aiinterviewer/models/chat_model.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/models/question.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:aiinterviewer/views/seeker/seeker_interview_screen.dart';
import 'package:aiinterviewer/views/user_type_selection_screen.dart';
import 'package:aiinterviewer/widgets/screen_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
                userType: ''),
            currentTabIndex: 0,
            jobs: [],
            interviewTypes: [],
            searchTextList: [],
            allQuestions: [],
            questionsForInterview: [], currentPlayingIndex: 0, answers: [], questionIds: [], applicants: [], searchQuery: '')) {
    loadUserInfo();
    loadInterviewTypes();
    loadSearchTextList();
    loadJobs();
  }

  void setCurrentTabIndex(int currentTabIndex) {
    emit(state.copyWith(currentTabIndex: currentTabIndex));
  }

  void setCurrentPlayingIndex(int currentPlayingIndex) {
    emit(state.copyWith(currentPlayingIndex: currentPlayingIndex));
  }

  void setAnswer(String answer, String questionId) {
    emit(state.copyWith(answers: [...state.answers, answer], questionIds: [...state.questionIds, questionId]));
  }

  void resetAnswerAndIdsLists() {
    emit(state.copyWith(answers: [], questionIds: []));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  Future<void> loadUserInfo() async {
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
                userType: ''),
            error: 'Error decoding user info: $e'));
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
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection('users').doc(uid).get();
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
                  userType: ''),
              error: 'User document does not exist'));
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
                userType: ''),
            error: 'No logged-in user'));
      }
    } catch (e) {
      emit(state.copyWith(
          error: 'Failed to fetch user info from Firestore: $e'));
    }
  }

   Future<void> loadJobs() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedJobs = prefs.getString('jobs');

      if (cachedJobs != null) {
        List<dynamic> cachedList = jsonDecode(cachedJobs);
        List<JobModel> jobs =
            cachedList.map((job) => JobModel.fromJson(job)).toList();
        emit(state.copyWith(jobs: jobs, isLoading: false));
        // Optionally fetch from Firestore to update cache
        _fetchJobsFromFirestore();
      } else {
        _fetchJobsFromFirestore(); // Fetch from Firestore if not cached
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load jobs: $e'));
    }
  }

  Future<void> _fetchJobsFromFirestore() async {
  try {
    // Fetch jobs from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('jobs').get();

    List<JobModel> jobs = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final job = JobModel.fromJson(data);

      // Fetch user info for the job's createdBy field
      final userDoc = await _firestore.collection('users').doc(job.createdBy).get();
      final userData = userDoc.data();
      final userInfo = userData != null ? UserInfoModel.fromJson(userData) : null;

      // Append user info to the job model
      final updatedJob = job.copyWith(createdUser: userInfo);

      jobs.add(updatedJob);
    }

    // Cache the fetched jobs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'jobs', jsonEncode(jobs.map((job) => job.toJson()).toList()));

    // Emit state with fetched jobs and loading set to false
    emit(state.copyWith(jobs: jobs, isLoading: false));
  } catch (e) {
    print(e);
    // Emit state with error message and loading set to false
    emit(state.copyWith(
        isLoading: false, error: 'Failed to fetch jobs from Firestore: $e'));
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
      emit(
          currentState.copyWith(error: 'Failed to update user info cache: $e'));
    }
  }

  Future<void> loadInterviewTypes() async {
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
      emit(state.copyWith(
          isLoading: false, error: 'Failed to load categories: $e'));
    }
  }

  Future<void> _fetchInterviewTypesFromFirestore() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('interviewTypes')
          .doc('interviewTypes')
          .get();
      if (doc.exists) {
        List<String> interviewTypes =
            List<String>.from(doc.data()?['data'] ?? []);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('interview_types', jsonEncode(interviewTypes));
        emit(state.copyWith(interviewTypes: interviewTypes, isLoading: false));
      } else {
        emit(state.copyWith(
            isLoading: false, error: 'Categories document does not exist'));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          error: 'Failed to fetch categories from Firestore: $e'));
    }
  }

  Future<void> loadSearchTextList() async {
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
      emit(state.copyWith(
          isLoading: false, error: 'Failed to load search text list: $e'));
    }
  }

  Future<void> _updateSearchTextList() async {
    try {
      List<String> searchTextList = [...state.interviewTypes];

      // Cache search text list
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('searchTextList', jsonEncode(searchTextList));

      // Emit the updated state
      emit(state.copyWith(searchTextList: searchTextList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, error: 'Failed to update search text list: $e'));
    }
  }

 Future<void> createJob({
  required String jobTitle,
  required String jobDescription,
  required String interviewType,
  required String salaryRange,
  required String jobType,
  required String jobRequirements,
  required String jobBenefits,
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

    // Fetch user info for the current user
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(createdBy).get();
    UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data() ?? {});

    // Create job document
    DocumentReference docRef = await _firestore.collection('jobs').add({
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'interviewType': interviewType,
      'applicants': [], // Initially empty array
      'salaryRange': salaryRange,
      'jobType': jobType,
      'jobRequirements': jobRequirements,
      'jobBenefits': jobBenefits,
      'createdUser': userInfo.toJson(), // Save the user info as part of the job
    });

    JobModel newJob = JobModel(
      jobId: docRef.id,
      jobTitle: jobTitle,
      jobDescription: jobDescription,
      createdAt: Timestamp.now(),
      createdBy: createdBy,
      applicants: [],
      interviewType: interviewType,
      salaryRange: salaryRange,
      jobType: jobType,
      jobRequirements: jobRequirements,
      jobBenefits: jobBenefits,
      createdUser: userInfo,
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
      UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data() ?? {});

      // Create JobModel with additional fields
      JobModel job = JobModel.fromJson(data).copyWith(
        createdUser: userInfo,
      );

      jobs.add(job);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jobsJson = jsonEncode(jobs.map((job) => job.toJson()).toList());
    await prefs.setString(_cacheKey, jobsJson);

    emit(state.copyWith(jobs: jobs, isLoading: false));
  } catch (e) {
    print('Error fetching jobs: $e'); // Detailed error logging
    emit(state.copyWith(isLoading: false, error: 'Failed to fetch jobs'));
  }
}



  void readyInterview(
      BuildContext context, JobModel job) {
    // Filter questions by category
    List<Question> filteredQuestions =
        questionsData.where((q) => q.category == job.interviewType).toList();

    // Take only the first `count` questions
    if (filteredQuestions.length > 2) {
      filteredQuestions = filteredQuestions.sublist(0, 2);
    }

    // Shuffle the filtered questions
    filteredQuestions.shuffle(Random());

    emit(state.copyWith(
        isLoading: false, questionsForInterview: filteredQuestions));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SeekerInterviewScreen(
                job: job,
              )),
    );
  }

  Future<http.Response> predict() async {
    var url = Uri.parse('http://10.0.2.2:5000/predict-list');
    // Use the following line for local testing:
    // var url = Uri.parse('http://127.0.0.1:5000/predict');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"texts": state.answers}),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load. Status code: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }


Future<void> resultsFinalization(List<dynamic> data, JobModel job) async {
  double totalMatchingPercentage = 0.0;
  int count = data.length;

  // Iterate over the data list and compare predicted categories with questionIds in order
  for (int i = 0; i < data.length; i++) {
    // Check if the index is within the bounds of questionIds
    if (i < state.questionIds.length) {
      String predictedCategory = data[i]['predicted_category'];
      double matchingPercentage = data[i]['matching_percentage'];

      // Check if the predicted category matches the value in questionIds at the current index
      if (predictedCategory == state.questionIds[i]) {
        totalMatchingPercentage += matchingPercentage;
      }
    }
  }

  double averageMatchingPercentage = totalMatchingPercentage / count;

  // Print the average matching percentage
  print('Average Matching Percentage: $averageMatchingPercentage');

  // Retrieve the job document from Firestore
  DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance
      .collection('jobs')
      .doc(job.jobId)
      .get();

  // Extract the applicants array from the job document, handle the case when it's null
  dynamic jobData = jobSnapshot.data();
  List<dynamic> applicantsJson = [];
  if (jobData is Map<String, dynamic> && jobData.containsKey('applicants')) {
    applicantsJson = jobData['applicants'] ?? [];
  }

  // Convert the JSON to a list of Applicant objects
  List<Applicant> applicants = applicantsJson.map((applicantJson) => Applicant.fromJson(applicantJson)).toList();

  // Add the current user's data to the applicants list
  applicants.add(Applicant(
    applicantId: state.userInfo.uid, // Replace with the current user's ID
    average: averageMatchingPercentage,
    howManyTimes: "1",
  ));

  // Convert the list of Applicant objects to JSON
  List<Map<String, dynamic>> updatedApplicantsJson = applicants.map((applicant) => applicant.toJson()).toList();

  // Update the job document with the new applicants array
  await FirebaseFirestore.instance
      .collection('jobs')
      .doc(job.jobId)
      .update({
    'applicants': updatedApplicantsJson,
  });

  resetAnswerAndIdsLists();
}

 Future<void> loadApplicants(String jobId, List<Applicant> applicants) async {
    emit(state.copyWith(isLoading: true));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedApplicants = prefs.getString('applicants_$jobId');

    if (cachedApplicants != null) {
      List<dynamic> applicantsJson = jsonDecode(cachedApplicants);
      List<Applicant> cachedApplicantList = applicantsJson.map((json) => Applicant.fromJson(json)).toList();
      emit(state.copyWith(applicants: cachedApplicantList, isLoading: false));
    }

    // Fetch fresh data from Firestore
    List<Applicant> updatedApplicants = [];
    for (var applicant in applicants) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(applicant.applicantId).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        applicant.firstName = userData['firstName'] ?? '';
        applicant.lastName = userData['lastName'] ?? '';
        applicant.profileUrl = userData['profileUrl'] ?? '';
        applicant.gender = userData['gender'] ?? '';
        applicant.email = userData['email'] ?? '';
        applicant.currentPosition = userData['currentPosition'] ?? '';
      }
      updatedApplicants.add(applicant);
    }

    String updatedApplicantsJson = jsonEncode(updatedApplicants.map((e) => e.toJson()).toList());
    await prefs.setString('applicants_$jobId', updatedApplicantsJson);

    emit(state.copyWith(applicants: updatedApplicants, isLoading: false));
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
Future<void> updateProfile({
  required String companyName,
  required String companyLocation,
  required String firstName,
  required String lastName,
  required String currentPosition,
  required String companySize,
  required String aboutCompany,
  File? companyLogoFile,
  // required BuildContext context,
}) async {
  try {
    emit(state.copyWith(isLoading: true));
    // Loading().startLoading(context);

    String? companyLogoUrl = state.userInfo.companyLogoUrl;

    // Upload company logo if a new file is provided
    String? companyLogoFileUrl;
    if (companyLogoFile != null) {
      companyLogoFileUrl = await _uploadCompanyImage(state.userInfo.uid, companyLogoFile);
    }

    // Create a map of the updated profile data
    final updatedUserInfo = {
      'companyName': companyName,
      'companyLocation': companyLocation,
      'firstName': firstName,
      'lastName': lastName,
      'currentPosition': currentPosition,
      'companySize': companySize,
      'aboutCompany': aboutCompany,
      'companyLogoUrl': companyLogoFileUrl ?? companyLogoUrl, // Use the new URL if available
    };

    // Update the Firestore document
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(state.userInfo.uid);
    await userDocRef.update(updatedUserInfo);

    // Update local state and SharedPreferences
    final updatedUserInfoModel = UserInfoModel(
      uid: state.userInfo.uid,
      email: state.userInfo.email,
      companyName: companyName,
      companyLocation: companyLocation,
      firstName: firstName,
      lastName: lastName,
      currentPosition: currentPosition,
      companySize: companySize,
      aboutCompany: aboutCompany,
      companyLogoUrl: companyLogoFileUrl ?? companyLogoUrl,
      birthday: state.userInfo.birthday,
      gender: state.userInfo.gender,
      profileUrl: state.userInfo.profileUrl,
      userType: state.userInfo.userType,
    );

    // Save the updated user info to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String userInfoJson = jsonEncode(updatedUserInfoModel.toJson());
    await prefs.setString('user_info', userInfoJson);

    emit(state.copyWith(
      userInfo: updatedUserInfoModel,
      isLoading: false,
    ));

    // Loading().stopLoading(context);
  } catch (e) {
    emit(state.copyWith(isLoading: false));
    // Loading().stopLoading(context);
    // Handle error appropriately, e.g., show a snackbar or log the error
    print('Error updating profile: $e');
  }
}






  Future<String> _uploadProfileImage(String uid, File profileImage) async {
  try {
    String filePath = 'profileImages/$uid.png';
    await FirebaseStorage.instance.ref(filePath).putFile(profileImage);
    String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return downloadUrl;
  } catch (e) {
    throw Exception('Error uploading image: $e');
  }
}

Future<void> updateProfileSeeker({
  required String firstName,
  required String lastName,
  required String currentPosition,
  required DateTime birthday,
  required String gender,
  File? profileImage,
  // required BuildContext context,
}) async {
  try {
    emit(state.copyWith(isLoading: true));
    // Loading().startLoading(context);

    String? profileImageUrl = state.userInfo.profileUrl;

    // Upload profile image if a new file is provided
    if (profileImage != null) {
      profileImageUrl = await _uploadProfileImage(state.userInfo.uid, profileImage);
    }

    // Create a map of the updated profile data
    final updatedUserInfo = {
      'firstName': firstName,
      'lastName': lastName,
      'currentPosition': currentPosition,
      'gender': gender,
      'birthday': birthday,
      if (profileImageUrl != null) 'profileUrl': profileImageUrl,
    };

    // Update the Firestore document
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(state.userInfo.uid);
    await userDocRef.update(updatedUserInfo);

    // Update local state and SharedPreferences
    final updatedUserInfoModel = UserInfoModel(
      uid: state.userInfo.uid,
      email: state.userInfo.email,
      firstName: firstName,
      lastName: lastName,
      currentPosition: currentPosition,
      birthday: Timestamp.fromDate(birthday),
      gender: gender,
      profileUrl: profileImageUrl ?? '',
      userType: state.userInfo.userType,
      aboutCompany: '',
      companyLocation: '',
      companyLogoUrl: '',
      companyName: '',
      companySize: '',
    );

    // Save the updated user info to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String userInfoJson = jsonEncode(updatedUserInfoModel.toJson());
    await prefs.setString('user_info', userInfoJson);

    emit(state.copyWith(
      userInfo: updatedUserInfoModel,
      isLoading: false,
    ));
    // Loading().stopLoading(context);
  } catch (e) {
    emit(state.copyWith(isLoading: false));
    // Loading().stopLoading(context);
    // Handle error appropriately, e.g., show a snackbar or log the error
    // throw e;
  }
}



  Future<void> updateJob({required String jobId, required String jobDescription}) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'jobDescription': jobDescription,
      });

      // Update the job description in the local state
      List<JobModel> updatedJobs = state.jobs.map((job) {
        if (job.jobId == jobId) {
          return job.copyWith(jobDescription: jobDescription);
        }
        return job;
      }).toList();

      // Update the cache
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jobs', jsonEncode(updatedJobs.map((job) => job.toJson()).toList()));

      emit(state.copyWith(jobs: updatedJobs, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to update job: $e'));
    }
  }


 Future<String?> getChatIdForUser(String applicantId, BuildContext context) async {
    final currentUserUid = state.userInfo.uid;
    final chatId1 = '${currentUserUid}_$applicantId';
    final chatId2 = '${applicantId}_$currentUserUid';

    // Assuming ChatCubit is accessible and you can get the list of chat models
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    final chats = chatCubit.state.chats;

    for (ChatModel chat in chats!) {
      if (chat.id == chatId1 || chat.id == chatId2) {
        return chat.id;
      }
    }
    return null;
  }

  Future<String?> createChatWithUser(String applicantId, BuildContext context) async {
    final currentUserUid = state.userInfo.uid;
    final chatId = '${currentUserUid}_$applicantId';

    // Assuming you have a method in ChatCubit to create a new chat
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    await chatCubit.createChat(chatId, applicantId);

    return chatId;
  }
 

}

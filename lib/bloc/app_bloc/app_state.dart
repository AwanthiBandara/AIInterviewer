
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/models/question.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';

class AppState {
  final bool isLoading;
  final String? error;
  final UserInfoModel userInfo;
  final int currentTabIndex;
  final List<JobModel> jobs;
  final List<String> interviewTypes;
  final List<String> searchTextList;
  final List<Question> allQuestions;
  final List<Question> questionsForInterview;
  final int currentPlayingIndex;
  final List<String> answers;
  final List<String> questionIds;
  final List<Applicant> applicants;

  AppState({
    required this.isLoading,
    this.error,
    required this.userInfo,
    this.currentTabIndex = 0,
    required this.jobs,
    required this.interviewTypes,
    required this.searchTextList,
    required this.allQuestions,
    required this.questionsForInterview,
    required this.currentPlayingIndex,
    required this.answers,
    required this.questionIds,
    required this.applicants,
  });

  AppState copyWith({
    bool? isLoading,
    String? error,
    UserInfoModel? userInfo,
    int? currentTabIndex,
    List<JobModel>? jobs,
    List<String>? interviewTypes,
    List<String>? searchTextList,
    List<Question>? allQuestions,
    List<Question>? questionsForInterview,
    int? currentPlayingIndex,
    List<String>? answers,
    List<String>? questionIds,
    List<Applicant>? applicants,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userInfo: userInfo ?? this.userInfo,
      currentTabIndex: currentTabIndex ?? 0, 
      jobs: jobs ?? this.jobs,
      interviewTypes: interviewTypes ?? this.interviewTypes,
      searchTextList: searchTextList ?? this.searchTextList,
      allQuestions: allQuestions ?? this.allQuestions,
      questionsForInterview: questionsForInterview ?? this.questionsForInterview,
      currentPlayingIndex: currentPlayingIndex ?? this.currentPlayingIndex,
      answers: answers ?? this.answers,
      questionIds: questionIds ?? this.questionIds,
      applicants: applicants ?? this.applicants,
    );
  }
}

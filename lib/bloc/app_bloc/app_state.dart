
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';

class AppState {
  final bool isLoading;
  final String? error;
  final UserInfoModel userInfo;
  final int currentTabIndex;
  final List<JobModel> jobs;
  final List<String> interviewTypes;
  final List<String> searchTextList;

  AppState({
    required this.isLoading,
    this.error,
    required this.userInfo,
    this.currentTabIndex = 0,
    required this.jobs,
    required this.interviewTypes,
    required this.searchTextList,
  });

  AppState copyWith({
    bool? isLoading,
    String? error,
    UserInfoModel? userInfo,
    int? currentTabIndex,
    List<JobModel>? jobs,
    List<String>? interviewTypes,
    List<String>? searchTextList,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userInfo: userInfo ?? this.userInfo,
      currentTabIndex: currentTabIndex ?? 0, 
      jobs: jobs ?? this.jobs,
      interviewTypes: interviewTypes ?? this.interviewTypes,
      searchTextList: searchTextList ?? this.searchTextList,
    );
  }
}

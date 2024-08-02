import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecruiterRankingScreen extends StatefulWidget {
  final JobModel job;
  const RecruiterRankingScreen({super.key, required this.job});

  @override
  State<RecruiterRankingScreen> createState() => _RecruiterRankingScreenState();
}

class _RecruiterRankingScreenState extends State<RecruiterRankingScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context).loadApplicants(widget.job.jobId, widget.job.applicants);
  }

  Future<void> _handleChatNavigation(Applicant applicant) async {
    final appCubit = BlocProvider.of<AppCubit>(context);
    String? chatId = await appCubit.getChatIdForUser(applicant.applicantId, context);

    if (chatId == null) {
      chatId = await appCubit.createChatWithUser(applicant.applicantId, context);
    }

    if (chatId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatDocumentId: chatId!, profileUrl: applicant.profileUrl, username: applicant.firstName + " " + applicant.lastName,),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          "Ranking View",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: white),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded, color: greyTextColor)),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            // Other widgets...
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 170),
                      child: Text("Please wait...", style: TextStyle(color: greyTextColor)),
                    ),
                  );
                }

                List<Applicant> sortedApplicants = List.from(state.applicants);
                sortedApplicants.sort((a, b) => b.average.compareTo(a.average));

                if (sortedApplicants.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 170),
                      child: Text("No available applicants", style: TextStyle(color: greyTextColor)),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sortedApplicants.length,
                    itemBuilder: (context, index) {
                      Applicant applicant = sortedApplicants[index];
                      return GestureDetector(
                        onTap: () => _handleChatNavigation(applicant),
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: cardColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 65,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: inCardColor,
                                          image: DecorationImage(
                                            image: NetworkImage(applicant.profileUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${applicant.firstName} ${applicant.lastName}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: greyTextColor,
                                            ),
                                          ),
                                          Text(
                                            applicant.currentPosition,
                                            style: TextStyle(
                                              fontSize: 14,
                                              letterSpacing: 1,
                                              color: greyTextColor,
                                            ),
                                          ),
                                          const Text(
                                            "Ranked at 1st | Success Percentage 78.89%",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: cardTextColor,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "${applicant.email} | +94 77 123 1234",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: greyTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: green.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color: green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
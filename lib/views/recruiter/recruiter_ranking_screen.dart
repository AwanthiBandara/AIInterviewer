import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
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
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AppCubit>(context).loadApplicants(widget.job.jobId, widget.job.applicants);
  }
  @override
  Widget build(BuildContext context) {
    // Load applicants when the screen is first displayed

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
            child:
                Icon(Icons.arrow_back_ios_new_rounded, color: greyTextColor)),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: greyTextColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: secondaryColor.withOpacity(0.2), width: 1.2),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://penji.co/wp-content/uploads/2022/10/4.-OrSpeakIT.jpg"),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.jobTitle,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: greyTextColor),
                    ),
                    const Text(
                      "HR Head at ABC Pvt Ltd, UK",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: greyTextColor),
                    ),
                    const Text(
                      "Remote | USD85,000/yr - USD95,000/yr",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: greyTextColor),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),
            Divider(color: grayColor.withOpacity(0.5)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.job.applicants.length} applicants | ${timeAgo(widget.job.createdAt.toDate())}",
                  style: const TextStyle(
                      fontSize: 12, color: green, fontWeight: FontWeight.w500),
                ),
                Container(
                  height: 25,
                  width: 100,
                  decoration: BoxDecoration(
                      color: grayColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Text(
                      "End session",
                      style: TextStyle(color: greyTextColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Ranked applicants",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: greyTextColor,
                      letterSpacing: 0.8),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                // Sort applicants by averageRating in descending order
                List<Applicant> sortedApplicants = List.from(state.applicants);
                sortedApplicants.sort((a, b) => b.average.compareTo(a.average));

                return Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sortedApplicants.length,
                      itemBuilder: (context, index) {
                        Applicant applicant = sortedApplicants[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          // height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: cardColor),
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
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${applicant.firstName} ${applicant.lastName}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: greyTextColor),
                                      ),
                                      Text(
                                        applicant.currentPosition,
                                        style: TextStyle(
                                            fontSize: 14,
                                            letterSpacing: 1,
                                            color: greyTextColor),
                                      ),
                                      const Text(
                                        "Ranked at 1st | Success Percentage 78.89%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: cardTextColor),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "${applicant.email} | +94 77 123 1234",
                                        style: TextStyle(
                                            fontSize: 12, color: greyTextColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_ranking_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecruiterViewJobBottomSheet extends StatefulWidget {
  final JobModel job;
  RecruiterViewJobBottomSheet({super.key, required this.job});

  @override
  State<RecruiterViewJobBottomSheet> createState() =>
      _RecruiterViewJobBottomSheetState();
}

class _RecruiterViewJobBottomSheetState
    extends State<RecruiterViewJobBottomSheet> {
  final TextEditingController _jobDescriptionController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInitialValues();
  }

  setInitialValues() {
    setState(() {
      _jobDescriptionController.text = widget.job.jobDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      padding: EdgeInsets.only(left: 15, right: 15, top: 40),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.transparent, size: 20),
              ),
              // Text(
              //   job.jobTitle,
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: white,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_rounded, color: grayColor, size: 24),
              ),
            ],
          ),
          // SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                    color: secondaryColor.withOpacity(0.2),
                                    width: 1.2),
                                image: DecorationImage(
                                  image: widget.job.createdUser
                                                  ?.companyLogoUrl !=
                                              null &&
                                          widget.job.createdUser!
                                              .companyLogoUrl!.isNotEmpty
                                      ? NetworkImage(widget
                                          .job.createdUser!.companyLogoUrl!)
                                      : const AssetImage(
                                              'assets/images/company_placeholder.png')
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                                Text(
                                  "${widget.job.createdUser?.companyName}, ${widget.job.createdUser?.companyLocation}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      color: greyTextColor),
                                ),
                                Text(
                                  "${widget.job.jobType} | ${widget.job.salaryRange}",
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
                                  fontSize: 12,
                                  color: green,
                                  fontWeight: FontWeight.w500),
                            ),
                            BlocBuilder<AppCubit, AppState>(
                              builder: (context, state) {
                                return widget.job.createdBy ==
                                        state.userInfo.uid
                                    ? GestureDetector(
                                      onTap: () {
                                         context.read<AppCubit>().updateJob(jobId: widget.job.jobId, jobDescription: _jobDescriptionController.text);
                                      },
                                      child: Container(
                                          height: 25,
                                          width: 85,
                                          decoration: BoxDecoration(
                                              color: grayColor.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Center(
                                            child: Text(
                                              "Update",
                                              style:
                                                  TextStyle(color: greyTextColor),
                                            ),
                                          ),
                                        ),
                                    )
                                    : SizedBox();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Job Description",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: greyTextColor,
                                      letterSpacing: 0.8),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            BlocBuilder<AppCubit, AppState>(
                              builder: (context, state) {
                              

                                     return   state.userInfo.uid == widget.job.createdBy ? CustomTextField(
                                  controller: _jobDescriptionController,
                                  hintText: "Job description",
                                  overlineText: null,
                                  backgroundColor: inCardColor,
                                  minLines: 5,
                                  maxLines: 5,
                                ) :  
                                Text(
                              "${widget.job.jobDescription}",
                              style:
                                  TextStyle(fontSize: 12, color: cardTextColor),
                            ); 
                             
                              },
                            ),
                           
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  "Requirements",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.8,
                                      color: greyTextColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${widget.job.jobRequirements}",
                              style:
                                  TextStyle(fontSize: 12, color: cardTextColor),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  "Benefits",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.8,
                                      color: greyTextColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${widget.job.jobBenefits}",
                              style:
                                  TextStyle(fontSize: 12, color: cardTextColor),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Salary",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.8,
                                  color: greyTextColor),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${widget.job.salaryRange}",
                              style:
                                  TextStyle(fontSize: 12, color: cardTextColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              return CustomButton(
                onTap: () {
                  if (widget.job.createdBy == state.userInfo.uid) {
                    Navigator.of(context)
                        .pop(); // Close the bottom sheet after publishing
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RecruiterRankingScreen(job: widget.job)),
                    );
                  } else {
                    Navigator.of(context)
                        .pop(); // Close the bottom sheet after publishing
                  }
                },
                buttonText: widget.job.createdBy == state.userInfo.uid
                    ? "View Applicants"
                    : "Back to home",
              );
            },
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/views/seeker/seeker_end_session_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_main_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class SeekerInterviewScreen extends StatelessWidget {
  final JobModel job;
  SeekerInterviewScreen({super.key, required this.job});

  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        // Navigate to LoginScreen when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SeekerMainScreen()),
          (route) => false, // Remove all the routes until the LoginScreen
        );
        return false; // Return false to prevent the default back button behavior
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 40),
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
                        border: Border.all(color: secondaryColor.withOpacity(0.2), width: 1.2),
                        image: DecorationImage(
                          image: job.createdUser?.companyLogoUrl != null &&
                                  job.createdUser!.companyLogoUrl.isNotEmpty
                              ? NetworkImage(job.createdUser!.companyLogoUrl!)
                              : AssetImage('assets/images/company_placeholder.png') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.jobTitle,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: greyTextColor),
                      ),
                      Text(
                        "${job.createdUser?.companyName}, ${job.createdUser?.companyLocation}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: greyTextColor),
                      ),
                      Text(
                        "${job.jobType} | ${job.salaryRange}",
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                            color: greyTextColor),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${job.applicants.length} applicants | ${timeAgo(job.createdAt.toDate())}",
                    style: const TextStyle(
                        fontSize: 12, color: green, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SeekerMainScreen()),
                      );
                    },
                    child: Container(
                      height: 25,
                      width: 85,
                      decoration: BoxDecoration(
                          color: grayColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: greyTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Divider(color: grayColor.withOpacity(0.5)),
              SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    "Theoritical Interview",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: greyTextColor,
                        letterSpacing: 0.8),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "Seeking a skilled Java developer to join our team. Responsibilities include designing, developing.",
                style: TextStyle(fontSize: 12, color: cardTextColor),
              ),
              SizedBox(height: 20),
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  int index = state.currentPlayingIndex;
                  return Text(
                    state.questionsForInterview[index].question,
                    style: TextStyle(
                      fontSize: 18,
                      color: white,
                    ),
                  );
                },
              ),
              CustomTextField(
                controller: _answerController,
                hintText: 'Give your answer here',
                overlineText: "",
                maxLines: 15,
                minLines: 15,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    onTap: () {
                      _answerController.clear();
                    },
                    buttonText: "Clear Answer",
                    buttonType: ButtonType.Small,
                    buttonColor: cardColor,
                    textColor: greyTextColor,
                  ),
                  SizedBox(width: 12),
                  CustomButton(
                    onTap: () {
                      // Implement microphone functionality here
                    },
                    buttonText: "Turn on mic",
                    buttonType: ButtonType.Small,
                    buttonColor: secondaryColor.withOpacity(0.3),
                    textColor: secondaryColor,
                  ),
                ],
              ),
              Spacer(),
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return CustomButton(
                    onTap: () async {
                      context.read<AppCubit>().setAnswer(
                          _answerController.text, state.questionsForInterview[state.currentPlayingIndex].id.toString());
                      if (state.currentPlayingIndex < state.questionsForInterview.length - 1) {
                        context.read<AppCubit>().setCurrentPlayingIndex(
                            state.currentPlayingIndex + 1);
                      } else {
                        Response response = await context.read<AppCubit>().predict();
                        if (response.statusCode == 200) {
                          var data = jsonDecode(response.body);
                          print(data);
                          context.read<AppCubit>().resultsFinalization(data, job);
                          // Handle successful prediction response
                           Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SeekerEndSessionScreen(job: job,)),
                                );
    
                        } else {
                          print('Failed to get prediction.');
                          // Handle error response
                        }
                      }
                      _answerController.clear();
                    },
                    buttonText: state.currentPlayingIndex < state.questionsForInterview.length - 1
                        ? "Next"
                        : "Submit",
                    // enabled: _answerController.text.isNotEmpty,
                  );
                },
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/views/seeker/seeker_interview_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeekerBiometricScreen extends StatelessWidget {
  final JobModel job;
  SeekerBiometricScreen({super.key, required this.job});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          "Interview Process",
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
        padding: EdgeInsets.only(left: 15, right: 15),
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
                      job.jobTitle,
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
                SizedBox(),
              ],
            ),
            SizedBox(height: 6),
            Divider(color: grayColor.withOpacity(0.5)),
            SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  "Biometric verification",
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
            SizedBox(height: 12),
            CustomTextField(
              controller: _firstNameController,
              hintText: 'First Name',
              overlineText: 'First Name',
            ),
            SizedBox(height: 12),
            CustomTextField(
              controller: _lastNameController,
              hintText: 'Last Name',
              overlineText: 'Last Name',
            ),
            Spacer(),
            CustomButton(
              onTap: () {
               context.read<AppCubit>().readyInterview(context, job);
              },
              buttonText: "Verify & Start",
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecruiterMyFeedScreen extends StatelessWidget {
  RecruiterMyFeedScreen({super.key}) {}

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Feed",
                style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold, color: white)),
            const SizedBox(height: 15),
            CustomSearchBar(
              controller: _searchController,
              onChanged: (String) {},
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All published jobs",
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.w500, fontSize: 16),
                ),
                CustomButton(
                  onTap: () {},
                  buttonText: "Publish job",
                  buttonType: ButtonType.Small,
                  buttonColor: secondaryColor.withOpacity(0.3),
                  textColor: secondaryColor,
                ),
              ],
            ),
            const SizedBox(height: 15),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.jobs.length,
                  itemBuilder: (context, index) {
                    final thisJob = state.jobs[index];
                    return JobCardRecruiter(job: thisJob,
                    );
                  },
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class JobCardRecruiter extends StatelessWidget {
  final JobModel job;

  JobCardRecruiter({
    Key? key,
    required this.job,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      height: 170,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
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
                  border: Border.all(color: primaryColor, width: 1.2),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://penji.co/wp-content/uploads/2022/10/4.-OrSpeakIT.jpg"),
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
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: white),
                  ),
                  const Text(
                    "HR Head at ABC Pvt Ltd, UK",
                    style: TextStyle(
                        fontSize: 14,
                        color: white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1),
                  ),
                  const Text(
                    "Remote | USD85,000/yr - USD95,000/yr",
                    style: TextStyle(
                        fontSize: 12, letterSpacing: 0.8, color: white),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft, // Adjust alignment as needed
            child: Text(
              job.jobDescription, // Display job description
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: cardTextColor),
            ),
          ),

          // const SizedBox(height: 4),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${job.applicants!.length} applicants",
                style: const TextStyle(
                    fontSize: 12, letterSpacing: 0.6, color: white),
              ),
              Text(
                timeAgo(job.createdAt.toDate()),
                style: const TextStyle(
                    fontSize: 12, letterSpacing: 0.6, color: white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

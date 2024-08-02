import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/views/seeker/seeker_bimetric_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SeekerViewJobBottomSheet extends StatelessWidget {
  final JobModel job;
  const SeekerViewJobBottomSheet({super.key, required this.job});

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
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.transparent, size: 20),
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
                                  image: job.createdUser
                                                  ?.companyLogoUrl !=
                                              null &&
                                          job.createdUser!
                                              .companyLogoUrl.isNotEmpty
                                      ? NetworkImage(job.createdUser!.companyLogoUrl!)
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
                                Text(job.jobTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: greyTextColor),),
                                Text("${job.createdUser?.companyName}, ${job.createdUser?.companyLocation}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1, color: greyTextColor),),
                                Text( "${job.jobType} | ${job.salaryRange}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: greyTextColor),),
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
                            "${job.applicants.length} applicants | ${timeAgo(job.createdAt.toDate())}",
                              style: const TextStyle(fontSize: 12, color: green, fontWeight: FontWeight.w500),
                            ),
                            SizedBox()
                            // Container(
                            //   height: 25,
                            //   width: 85,
                            //   decoration: BoxDecoration(
                            //       color: grayColor.withOpacity(0.2),
                            //       borderRadius: BorderRadius.circular(4)),
                            //   child: Center(
                            //     child: Text(
                            //       "Edit",
                            //       style: TextStyle(color: greyTextColor),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                          children: [
                            Text(
                              "Job Description",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500, color: greyTextColor, letterSpacing: 0.8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                           "${job.jobDescription}",
                          style: TextStyle(fontSize: 12, color: cardTextColor),
                        ),
                        const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  "Requirements",
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.8, color: greyTextColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                               "${job.jobRequirements}",
                              style: TextStyle(fontSize: 12, color: cardTextColor),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  "Benefits",
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.8, color: greyTextColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${job.jobBenefits}",
                              style: TextStyle(fontSize: 12, color: cardTextColor),
                            ),
                              const SizedBox(height: 12),
                            const Text(
                              "Salary",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.8, color: greyTextColor),
                            ),
                            const SizedBox(height: 6),
                            Text(
                             "${job.salaryRange}",
                              style: TextStyle(fontSize: 12, color: cardTextColor),
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
          CustomButton(
            onTap: () {
              
              Navigator.of(context).pop(); // Close the bottom sheet after publishing
               Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SeekerBiometricScreen(job: job,)),
                        );
            },
            buttonText: "Start Interview",
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

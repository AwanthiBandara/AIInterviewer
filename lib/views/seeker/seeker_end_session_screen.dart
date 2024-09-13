import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/models/job_model.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:aiinterviewer/views/seeker/seeker_interview_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_main_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_datepicker_new.dart';
import 'package:aiinterviewer/widgets/custom_dropdown_by_array.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeekerEndSessionScreen extends StatefulWidget {
  final JobModel job;

  SeekerEndSessionScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<SeekerEndSessionScreen> createState() => _SeekerEndSessionScreenState();
}

class _SeekerEndSessionScreenState extends State<SeekerEndSessionScreen> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SeekerMainScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: white),
          ),
          leading: GestureDetector(
            onTap: () {
               Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SeekerMainScreen()),
          (route) => false, // Remove all the routes until the LoginScreen
        );
            },
            child: Icon(Icons.arrow_back_ios_new_rounded, color: greyTextColor),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
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
                        image: widget.job.createdUser?.companyLogoUrl != null &&
                                widget.job.createdUser!.companyLogoUrl.isNotEmpty
                            ? NetworkImage(widget.job.createdUser!.companyLogoUrl!)
                            : AssetImage('assets/images/company_placeholder.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.jobTitle,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: greyTextColor),
                      ),
                      Text(
                        "${widget.job.createdUser?.companyName}, ${widget.job.createdUser?.companyLocation}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1, color: greyTextColor),
                      ),
                      Text(
                        "${widget.job.jobType} | ${widget.job.salaryRange}",
                        style: TextStyle(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w500, color: greyTextColor),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.job.applicants.length} applicants | ${timeAgo(widget.job.createdAt.toDate())}",
                    style: TextStyle(fontSize: 12, color: green, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(), // Empty widget to align text properly
                ],
              ),
              SizedBox(height: 6),
              Divider(color: grayColor.withOpacity(0.5)),
              Spacer(),
              Text(
                "Thanks for the participating to AI Interview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: greyTextColor, letterSpacing: 0.6), textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "If you are best fit for this position, recruiter will contact you",
                style: TextStyle(fontSize: 16, color: cardTextColor),
                textAlign: TextAlign.center
              ),
              Spacer(),
              CustomButton(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SeekerMainScreen()),
          (route) => false, // Remove all the routes until the LoginScreen
        );
                },
                buttonText: "Back to Home",
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}


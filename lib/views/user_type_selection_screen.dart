import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_signup_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_main_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_signup_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  String userType = "job_seeker";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to LoginScreen when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // Remove all the routes until the LoginScreen
        );
        return false; // Return false to prevent the default back button behavior
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: greyTextColor,
              )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Select your path",
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w600, color: white),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          userType = "job_seeker";
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/seeker.png"),
                                  fit: BoxFit.cover,
                                ),
                                color: cardColor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: userType == "job_seeker"
                                        ? secondaryColor
                                        : Colors.transparent, width: 3)),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Job Seeker",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: greyTextColor),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          userType = "recruiter";
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              color: cardColor,
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/recruiter.png"),
                                  fit: BoxFit.cover,
                                ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: userType == "recruiter"
                                      ? secondaryColor
                                      : Colors.transparent, width: 3),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Recruiter",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: greyTextColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomButton(
                    onTap: () {
                      if (userType == "job_seeker") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeekerSignupScreen()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecruiterSignupScreen()),
                        );
                      }
                    },
                    buttonText: "Continue"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: grayColor, fontSize: 14),
                          ),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                                color: greyTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

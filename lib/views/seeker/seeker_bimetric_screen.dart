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

class SeekerBiometricScreen extends StatefulWidget {
  final JobModel job;

  SeekerBiometricScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<SeekerBiometricScreen> createState() => _SeekerBiometricScreenState();
}

class _SeekerBiometricScreenState extends State<SeekerBiometricScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPositionController = TextEditingController();
  DateTime? _birthday;
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    setInitialValues();
  }

  void setInitialValues() {
    UserInfoModel userInfo = BlocProvider.of<AppCubit>(context).state.userInfo;
    setState(() {
      _firstNameController.text = userInfo.firstName;
      _lastNameController.text = userInfo.lastName;
      _currentPositionController.text = userInfo.currentPosition;
      _emailController.text = userInfo.email;
      _birthday = userInfo.birthday.toDate();
      _selectedGender = userInfo.gender;
    });
  }

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
            "Interview Process",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: white),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded, color: greyTextColor),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // Ensures scrolling works if needed
          child: Container(
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
                SizedBox(height: 12),
                Text(
                  "Biometric Verification",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: greyTextColor, letterSpacing: 0.8),
                ),
                SizedBox(height: 6),
                Text(
                  "Seeking a skilled Java developer to join our team. Responsibilities include designing, developing.",
                  style: TextStyle(fontSize: 12, color: cardTextColor),
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _firstNameController,
                  hintText: 'First Name',
                  overlineText: 'First Name',
                ),
                SizedBox(height: 18),
                CustomTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  overlineText: 'Last Name',
                ),
                SizedBox(height: 18),
                // CustomTextField(
                //   controller: _emailController,
                //   hintText: 'Email',
                //   overlineText: 'Email',
                //   editable: false,
                // ),
                // SizedBox(height: 18),
                CustomTextField(
                  controller: _currentPositionController,
                  hintText: 'Current Position',
                  overlineText: 'Current Position',
                ),
                SizedBox(height: 18),
                CustomDatePickerNew(
                  initialDate: _birthday,
                  overLineHeaderText: "Date of Birth",
                  placeHolderText: "DD/MM/YYYY",
                  onChanged: (value) {
                    setState(() {
                      _birthday = value;
                    });
                  },
                ),
                SizedBox(height: 18),
                CustomDropdownByArray(
                  items: ['Male', 'Female'],
                  selectedValue: _selectedGender,
                  hintText: 'Select gender',
                  overlineText: 'Gender',
                  backgroundColor: cardColor,
                  textColor: white,
                  hintColor: grayColor,
                  overlineTextColor: white,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value ?? "";
                    });
                  },
                ),
                SizedBox(height: 18),
                CustomButton(
                  onTap: () {
                    context.read<AppCubit>().readyInterview(context, widget.job);
                  },
                  buttonText: "Verify & Start",
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


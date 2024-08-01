import 'dart:io';

import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecruiterProfileScreen extends StatefulWidget {
  const RecruiterProfileScreen({super.key});

  @override
  _RecruiterProfileScreenState createState() => _RecruiterProfileScreenState();
}

class _RecruiterProfileScreenState extends State<RecruiterProfileScreen> {
  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_info');
      await prefs.remove('jobs');
      await prefs.remove('interview_types');
      await prefs.remove('searchTextList');
      await prefs.remove('cached_jobs');

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      context.read<AppCubit>().setCurrentTabIndex(0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _currentPositionController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyLocationController =
      TextEditingController();
  final TextEditingController _companySizeController = TextEditingController();
  final TextEditingController _aboutCompanyController = TextEditingController();

  File? _companyImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _companyImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInitialValues();
  }

setInitialValues(){
  UserInfoModel userInfo = BlocProvider.of<AppCubit>(context).state.userInfo;
setState(() {
  _companyNameController.text = userInfo.companyName;
  _companyLocationController.text = userInfo.companyLocation;
  _firstNameController.text = userInfo.firstName;
  _lastNameController.text = userInfo.lastName;
  _currentPositionController.text = userInfo.currentPosition;
  _companySizeController.text = userInfo.companySize;
  _aboutCompanyController.text = userInfo.aboutCompany;
  _emailController.text = userInfo.email;
});
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: cardColor,
            centerTitle: true,
            title: const Text(
              'Profile',
              style: TextStyle(fontSize: 16),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            image: _companyImage != null
                                ? DecorationImage(
                                    image: FileImage(_companyImage!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                        state.userInfo.companyLogoUrl),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Tap to update company logo",
                          style: TextStyle(fontSize: 14, color: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _companyNameController,
                    hintText: 'ABC Pvt Ltd',
                    overlineText: 'Company Name',
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _companyLocationController,
                    hintText: 'City, Country',
                    overlineText: 'Company Location',
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _firstNameController,
                          hintText: 'First Name',
                          overlineText: 'First Name',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: _lastNameController,
                          hintText: 'Last Name',
                          overlineText: 'Last Name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    overlineText: 'Email',
                    editable: false,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _currentPositionController,
                    hintText: 'Current Position',
                    overlineText: 'Enter your current position',
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _companySizeController,
                    hintText: '0 - 10',
                    overlineText: 'Company Size',
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _aboutCompanyController,
                    hintText: 'Type here',
                    overlineText: 'About Company',
                    maxLines: 4,
                    minLines: 4,
                  ),
                  const SizedBox(height: 18),
                  CustomButton(
                    onTap: () {
                       context.read<AppCubit>().updateProfile(
                            companyName: _companyNameController.text,
                            companyLocation: _companyLocationController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            currentPosition: _currentPositionController.text,
                            companySize: _companySizeController.text,
                            aboutCompany: _aboutCompanyController.text,
                            companyLogoFile: _companyImage,
                          );
                    },
                    buttonText: "Update",
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

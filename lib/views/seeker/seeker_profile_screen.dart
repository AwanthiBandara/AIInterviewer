import 'dart:io';

import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_datepicker_new.dart';
import 'package:aiinterviewer/widgets/custom_dropdown_by_array.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeekerProfileScreen extends StatefulWidget {
  const SeekerProfileScreen({super.key});

  @override
  _SeekerProfileScreenState createState() => _SeekerProfileScreenState();
}

class _SeekerProfileScreenState extends State<SeekerProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _currentPositionController = TextEditingController();

  DateTime? _birthday;
  String _selectedGender = 'Male';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    setInitialValues();
  }

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: SingleChildScrollView(
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
                            shape: BoxShape.circle,
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: state.userInfo.profileUrl.isNotEmpty
                                        ? NetworkImage(state.userInfo.profileUrl)
                                        : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Tap to update profile image",
                          style: TextStyle(fontSize: 14, color: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    overlineText: 'Current Position',
                  ),
                  const SizedBox(height: 18),
                  CustomDatePickerNew(
                    initialDate: _birthday,
                    overLineHeaderText: "Date of Birth",
                    placeHolderText: "DD/MM/YYYY",
                    onChanged: (value) {
                      setState(() {
                        _birthday = value;
                        _birthdayController.text = value.toString(); // or format the date as needed
                      });
                    },
                  ),
                  const SizedBox(height: 18),
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
                  const SizedBox(height: 32),
                  CustomButton(
                    onTap: () {
                      context.read<AppCubit>().updateProfileSeeker(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        currentPosition: _currentPositionController.text,
                        birthday: _birthday!,
                        gender: _selectedGender,
                        profileImage: _profileImage,
                        context: context,
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

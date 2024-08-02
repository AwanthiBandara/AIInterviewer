import 'dart:io';
import 'package:aiinterviewer/bloc/signup_bloc/signup_cubit.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_main_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_datepicker.dart';
import 'package:aiinterviewer/widgets/custom_datepicker_new.dart';
import 'package:aiinterviewer/widgets/custom_dropdown_by_array.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SeekerSignupScreen extends StatefulWidget {
  const SeekerSignupScreen({Key? key}) : super(key: key);

  @override
  _SeekerSignupScreenState createState() => _SeekerSignupScreenState();
}

class _SeekerSignupScreenState extends State<SeekerSignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _currentPositionController =
      TextEditingController();
  DateTime? _birthday;
  String _selectedGender = 'Male';

  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _signup() {
    context.read<SignupCubit>().seekerSignup(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          currentPosition: _currentPositionController.text,
          birthday: _birthdayController
              .text, // Assuming you have a controller for birthday
          gender: _selectedGender,
          profileImage: _profileImage,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 2,
          title: Text("Signup", style: TextStyle(color: white, fontSize: 16)),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: grayColor,
            ),
          ),
        ),
        body: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RecruiterMainScreen()),
              );
            } else if (state.errorMessage != null) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Sign up failed: ${state.errorMessage}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profileImage == null
                              ? Center(
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: grayColor,
                                    size: 26,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Tap to set profile logo",
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
                          overlineText: 'Enter your first name',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: _lastNameController,
                          hintText: 'Last Name',
                          overlineText: 'Enter your last name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    overlineText: 'Enter email',
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    overlineText: 'Enter password',
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _currentPositionController,
                    hintText: 'Current Position',
                    overlineText: 'Enter your current position',
                  ),
                  const SizedBox(height: 18),
                  CustomDatePickerNew(
                    overLineHeaderText: "Date of Birth",
                    placeHolderText: "DD/MM/YYYY",
                    onChanged: (value) {
                      setState(() {
                        _birthday = value;
                        _birthdayController.text =
                            value.toString(); // or format the date as needed
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                   CustomDropdownByArray(
                      items: ['Male', 'Female'],
                      selectedValue:
                          'Male', // Must match exactly one item in the list
                      hintText: 'Select gender',
                      overlineText: 'Gender',
                      backgroundColor: cardColor,
                      textColor: white,
                      hintColor: grayColor,
                      overlineTextColor: white,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value??"";
                        });
                      },
                    ),
                  //    CustomDatePicker(onChanged: (value){
                  //   setState(() {
                  //     _birthday = value;
                  //     _birthdayController.text = value.toString(); // or format the date as needed
                  //   });
                  //   print(value.toString());
                  // }),
                  const SizedBox(height: 32),

                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      return state.isLoading
                          ? CircularProgressIndicator()
                          : CustomButton(
                              onTap: _signup,
                              buttonText: "Register",
                            );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style:
                                    TextStyle(color: grayColor, fontSize: 14),
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
        ),
      ),
    );
  }
}

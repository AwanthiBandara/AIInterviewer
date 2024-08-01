import 'dart:io';
import 'package:aiinterviewer/bloc/signup_bloc/signup_cubit.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_main_screen.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RecruiterSignupScreen extends StatefulWidget {
  const RecruiterSignupScreen({Key? key}) : super(key: key);

  @override
  _RecruiterSignupScreenState createState() => _RecruiterSignupScreenState();
}

class _RecruiterSignupScreenState extends State<RecruiterSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

  void _signup() {
    context.read<SignupCubit>().recruiterSignup(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          currentPosition: _currentPositionController.text,
          companyName: _companyNameController.text,
          companyLocation: _companyLocationController.text,
          companySize: _companySizeController.text,
          aboutCompany: _aboutCompanyController.text,
          companyImage: _companyImage,
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
                            image: _companyImage != null
                                ? DecorationImage(
                                    image: FileImage(_companyImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _companyImage == null
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
                          "Tap to set company logo",
                          style: TextStyle(fontSize: 14, color: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _companyNameController,
                    hintText: 'ABC Pvt Ltd',
                    overlineText: 'Enter your company name',
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _companyLocationController,
                    hintText: 'City, Country',
                    overlineText: 'Enter your company location',
                  ),
                  const SizedBox(height: 18),
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
                    obscureText: true,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    overlineText: 'Enter password agin',
                    obscureText: true,
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
                    overlineText: 'Company size',
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: _aboutCompanyController,
                    hintText: 'Type here',
                    overlineText: 'About Company',
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      return state.isLoading
                          ? CircularProgressIndicator()
                          : CustomButton(
                              onTap: () {
                                if (_passwordController.text ==
                                    _confirmPasswordController.text) {
                                  _signup();
                                } else {}
                              },
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

import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/login_bloc/login_cubit.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.isLoading) {
              // Show loading indicator if needed
            }
            if (state.errorMessage != null) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
            // Handle successful login here, e.g., navigate to another screen
            // if (state.isLoggedIn) {
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            // }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Log in here", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: white)),
                  ],
                ),
                const SizedBox(height: 36),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  overlineText: 'Enter your email',
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  overlineText: 'Enter your password',
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onTap: () {
                    context.read<LoginCubit>().login(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      context: context
                    );
                  },
                  
                  buttonText: state.isLoading ? 'Loading...' : 'Login',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to signup screen
                      },
                      child: const Text("Not registered yet?", style: TextStyle(fontSize: 14, color: greyTextColor)),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

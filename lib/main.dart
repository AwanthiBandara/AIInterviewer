import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/signup_bloc/signup_cubit.dart';
import 'package:aiinterviewer/login_bloc/login_cubit.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignupCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => AppCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<User?>(
          future: _getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading spinner while checking auth status
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              // User is logged in
              return RecruiterMainScreen(); // Navigate to RecruiterMainScreen
            } else {
              // User is not logged in
              return const LoginScreen(); // Navigate to LoginScreen
            }
          },
        ),
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}

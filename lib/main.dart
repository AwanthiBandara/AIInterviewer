import 'package:aiinterviewer/bloc/signup_bloc/signup_cubit.dart';
import 'package:aiinterviewer/login_bloc/login_cubit.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/views/main_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_signup_screen.dart';
import 'package:aiinterviewer/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignupCubit()),
        BlocProvider(create: (context) => LoginCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}


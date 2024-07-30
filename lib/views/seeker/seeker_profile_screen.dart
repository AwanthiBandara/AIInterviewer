import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/views/login_screen.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeekerProfileScreen extends StatefulWidget {
  const SeekerProfileScreen({super.key});

  @override
  _SeekerProfileScreenState createState() => _SeekerProfileScreenState();
}

class _SeekerProfileScreenState extends State<SeekerProfileScreen> {

  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_info');
      await prefs.remove('jobs');

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      context.read<AppCubit>().setCurrentTabIndex(0);
    } catch (e) {
      // showAlert(context, 'Error signing out', red);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: inCardColor,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
        child: Column(
          children: [
        
          ],
        ),
      ),
    );
  }
}

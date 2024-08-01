import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_my_feed_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_profile_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_public_feed_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_my_feed_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_profile_screen.dart';
import 'package:aiinterviewer/views/seeker/seeker_public_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeekerMainScreen extends StatefulWidget {
  SeekerMainScreen({super.key});

  @override
  State<SeekerMainScreen> createState() => _SeekerMainScreenState();
}

class _SeekerMainScreenState extends State<SeekerMainScreen> {
  final List<Widget> _screens = [
    SeekerPublicFeedScreen(),
    SeekerMyFeedScreen(),
    const SeekerProfileScreen(),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.read<AppCubit>().setCurrentTabIndex(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AppCubit>().loadUserInfo();
    context.read<AppCubit>().loadInterviewTypes();
    context.read<AppCubit>().loadSearchTextList();
    context.read<AppCubit>().loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return _screens[state.currentTabIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Public',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: 'My',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: state.currentTabIndex,
            onTap: (index) => _onItemTapped(context, index),
            selectedItemColor: greyTextColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: inCardColor,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}

import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/bloc/app_bloc/app_state.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/views/chat/chat_list_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_my_feed_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_profile_screen.dart';
import 'package:aiinterviewer/views/recruiter/recruiter_public_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecruiterMainScreen extends StatelessWidget {
  RecruiterMainScreen({super.key});

  final List<Widget> _screens = [
    RecruiterPublicFeedScreen(),
    RecruiterMyFeedScreen(),
    ChatListScreen(),
    const RecruiterProfileScreen(),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.read<AppCubit>().setCurrentTabIndex(index);
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
                icon: Icon(Icons.chat),
                label: 'Chat',
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

import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        color: cardColor, // Light gray background color
        borderRadius: BorderRadius.circular(8.0), // Border radius of 8.0
        border: Border.all(
          color: Colors.transparent, // Light gray border color
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: grayColor), // Left side search icon
          SizedBox(width: 8.0), // Add some spacing between the icon and the text field
          Expanded(
            child: TextField(
              style: TextStyle(color: white),
              controller: controller,
              onChanged: onChanged, // Pass the onChanged callback
              decoration: InputDecoration(
                hintText: 'Search jobs here',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: grayColor),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle the tap event for the list icon
              print('List icon tapped');
            },
            child: Icon(Icons.menu_rounded, color: grayColor), // Right side list icon
          ),
        ],
      ),
    );
  }
}

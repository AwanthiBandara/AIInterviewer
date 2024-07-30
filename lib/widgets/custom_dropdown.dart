import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const CustomDropdown({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
                  "Interview type",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: white),
                ),
          ],
        ),
        Container(
          height: 48.0,
          decoration: BoxDecoration(
            color: inCardColor, // Light gray background color
            borderRadius: BorderRadius.circular(8.0), // Border radius of 8.0
            border: Border.all(
              color: Colors.transparent, // Light gray border color
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: white),
                  cursorColor: white,
                  controller: controller,
                  onChanged: onChanged, // Pass the onChanged callback
                  decoration: InputDecoration(
                    hintText: 'Search interview type here',
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
                child: Icon(Icons.keyboard_arrow_down_rounded, color: grayColor), // Right side list icon
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String overlineText;
  final bool obscureText;
  final double borderRadius;
  final Color borderColor;
  final int? maxLines;
  final int minLines;
  final Color backgroundColor;
  final bool editable; // Added editable property
  final String? buttonText; // Optional button text
  final VoidCallback? onTapTextButton; // Callback for button press

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.overlineText,
    this.obscureText = false,
    this.borderRadius = 8.0,
    this.borderColor = Colors.transparent, 
    this.maxLines = 1, 
    this.minLines = 1, 
    this.backgroundColor = cardColor,
    this.editable = true, // Default to true
    this.buttonText, // Optional button text
    this.onTapTextButton, // Callback for button press
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              overlineText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: white),
            ),
            if (buttonText != null) // Conditionally show the button if buttonText is not null
              TextButton(
                onPressed: onTapTextButton,
                child: Text(
                  buttonText!,
                  style: TextStyle(color: white),
                ),
              ),
          ],
        ),
        SizedBox(
          child: Container(
            decoration: BoxDecoration(
              color: editable ? backgroundColor : grayColor.withOpacity(0.5), // Change color if not editable
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: editable ? borderColor : grayColor),
            ),
            child: TextField(
              minLines: minLines,
              maxLines: maxLines,
              keyboardType: TextInputType.multiline,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                hintText: hintText,
                hintStyle: TextStyle(color: editable ? grayColor : white.withOpacity(0.5)),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              obscureText: obscureText,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: editable ? white : white.withOpacity(0.5),
              style: TextStyle(color: editable ? white : white.withOpacity(0.5)),
              enabled: editable, // Use editable property here
            ),
          ),
        ),
      ],
    );
  }
}

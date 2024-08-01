import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownByArray extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final String hintText;
  final String overlineText;
  final Color backgroundColor;
  final Color textColor;
  final Color hintColor;
  final Color overlineTextColor;
  final void Function(String?)? onChanged;

  CustomDropdownByArray({
    required this.items,
    this.selectedValue,
    required this.hintText,
    required this.overlineText,
    this.backgroundColor = inCardColor,
    this.textColor = white,
    this.hintColor = grayColor,
    this.overlineTextColor = white,
    this.onChanged,
  });

  @override
  _CustomDropdownByArrayState createState() => _CustomDropdownByArrayState();
}

class _CustomDropdownByArrayState extends State<CustomDropdownByArray> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.overlineText,
          style: TextStyle(
            color: widget.overlineTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              _selectedValue = newValue;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            filled: true,
            fillColor: widget.backgroundColor,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: widget.hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: widget.backgroundColor,
          iconEnabledColor: widget.textColor,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: grayColor,),
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                child: Text(
                  item,
                  style: TextStyle(color: widget.textColor),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

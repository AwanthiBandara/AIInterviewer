import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final String? placeHolderText;
  final String? overLineHeaderText;
  final TextStyle? overLineHeaderTextStyle;
  final double? overLineHeaderMarginBottom;
  final Color? fillColor;
  final String? errorText;
  final Function(DateTime) onChanged;
  final String dateFormat;

  const CustomDatePicker({
    Key? key,
    this.placeHolderText = '',
    this.fillColor = cardColor,
    this.overLineHeaderText,
    this.overLineHeaderTextStyle,
    this.overLineHeaderMarginBottom,
    this.errorText,
    this.dateFormat = "yyyy/MM/dd",
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
             "Select your birthday",
             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: white),
           ),
           const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: widget.fillColor ?? Colors.white,
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _selectedDate != null
                      ? Text(
                          DateFormat(widget.dateFormat).format(_selectedDate!),
                          style: TextStyle(color: white),
                        )
                      : Text(
                          "Birthday",
                          style: TextStyle(color: grayColor, fontSize: 16),
                        ),
                  Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (widget.errorText != null && widget.errorText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                widget.errorText!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';

class CustomDatePickerNew extends StatefulWidget {
  final double? height;
  final String? placeHolderText;
  final String? overLineHeaderText;
  final TextStyle? overLineHeaderTextStyle;
  final double? overLineHeaderMarginBottom;
  final Color? fillColor;
  final Function(DateTime) onChanged;
  final String dateFormat;
  final bool? isRtlDirection;
  final DateTime? initialDate; // Added this line

  const CustomDatePickerNew({
    Key? key,
    this.placeHolderText = '',
    this.fillColor = black,
    this.height,
    this.overLineHeaderText,
    this.overLineHeaderTextStyle,
    this.overLineHeaderMarginBottom,
    this.dateFormat = "dd/MM/yyyy",
    required this.onChanged,
    this.isRtlDirection,
    this.initialDate, // Added this line
  }) : super(key: key);

  @override
  _CustomDatePickerNewState createState() => _CustomDatePickerNewState();
}

class _CustomDatePickerNewState extends State<CustomDatePickerNew> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Dialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: inCardColor,
          child: DatePicker(
            initialDate: _selectedDate ?? DateTime.now(), // Updated this line
            selectedDate: _selectedDate ?? DateTime.now(), // Updated this line
            minDate: DateTime(1900, 1, 1),
            maxDate: DateTime.now(),
            centerLeadingDate: true,
            selectedCellTextStyle: const TextStyle(
              fontSize: 14,
              color: white,
            ),
            disabledCellsTextStyle: const TextStyle(
              fontSize: 14,
              color: grayColor,
            ),
            enabledCellsTextStyle: const TextStyle(
              fontSize: 14,
              color: white,
            ),
            daysOfTheWeekTextStyle: const TextStyle(
              fontSize: 14,
              color: white,
            ),
            currentDateTextStyle: const TextStyle(
              fontSize: 16,
              color: white,
            ),
            selectedCellDecoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: secondaryColor),
            ),
            currentDateDecoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              shape: BoxShape.circle,
            ),
            leadingDateTextStyle: const TextStyle(
              fontSize: 16,
              color: white,
              fontWeight: FontWeight.w700,
            ),
            slidersColor: white,
            splashColor: secondaryColor.withOpacity(0.5),
            splashRadius: 20,
            onDateSelected: (value) {
              _onDateSelected(value);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() => _selectedDate = selectedDate);
    widget.onChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.overLineHeaderText != null)
            Padding(
              padding: EdgeInsets.only(bottom: widget.overLineHeaderMarginBottom ?? 5),
              child: Text(
                widget.overLineHeaderText!,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: white),
              ),
            ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent), // Default border
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate != null
                        ? DateFormat(widget.dateFormat).format(_selectedDate!)
                        : widget.placeHolderText ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate != null ? white : grayColor,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today, // Replace with CustomImageSVG if needed
                    color: grayColor,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

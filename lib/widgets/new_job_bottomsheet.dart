import 'package:aiinterviewer/bloc/app_bloc/app_cubit.dart';
import 'package:aiinterviewer/constants/colors.dart';
import 'package:aiinterviewer/helper/helper_functions.dart';
import 'package:aiinterviewer/widgets/custom_button.dart';
import 'package:aiinterviewer/widgets/custom_dropdown.dart';
import 'package:aiinterviewer/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewJobBottomSheet extends StatefulWidget {
  const NewJobBottomSheet({super.key});

  @override
  _NewJobBottomSheetState createState() => _NewJobBottomSheetState();
}

class _NewJobBottomSheetState extends State<NewJobBottomSheet> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _interviewTypeController = TextEditingController();

  List<String> filteredSearchTextList = [];

  @override
  void initState() {
    super.initState();
    _interviewTypeController.addListener(_filterSearchText);
  }

  void _filterSearchText() {
    final query = _interviewTypeController.text.toLowerCase();
    final allSearchTextList = context.read<AppCubit>().state.interviewTypes;
    setState(() {
      filteredSearchTextList = allSearchTextList
          .where((i) => i.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onSuggestionTap(String suggestion) {
    final allInterviewTypes = context.read<AppCubit>().state.interviewTypes;
    if (allInterviewTypes.contains(suggestion)) {
      _interviewTypeController.text = suggestion;
      setState(() {
        filteredSearchTextList.clear();
      });
      closeKeyboard(context);
      // _interviewTypeController.clear();
      _dismissSuggestions();
    } else {
      _interviewTypeController.text = suggestion;
      setState(() {
        filteredSearchTextList.clear();
      });
      closeKeyboard(context);
      // _interviewTypeController.clear();
      _dismissSuggestions();
    }
  }

  void _dismissSuggestions() {
    setState(() {
      filteredSearchTextList.clear();
    });
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dismissSuggestions();
      },
      child: Container(
        color: cardColor,
        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.transparent, size: 20),
                ),
                Text(
                  "New job",
                  style: TextStyle(
                    fontSize: 16,
                    color: white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close_rounded, color: grayColor, size: 24),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    Column(
                      children: [
                        CustomDropdown(controller: _interviewTypeController, onChanged: (x) {}),
                        SizedBox(height: 8,),
                        if (filteredSearchTextList.isNotEmpty)
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              color: inCardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Scrollbar(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredSearchTextList.length,
                                itemBuilder: (context, index) {
                                  final suggestion = filteredSearchTextList[index];
                                  return ListTile(
                                    title: Text(
                                      suggestion,
                                      style: const TextStyle(color: greyTextColor),
                                    ),
                                    onTap: () => _onSuggestionTap(suggestion),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      controller: _jobTitleController,
                      hintText: "Enter job title here",
                      overlineText: "Job title",
                      minLines: 1,
                      maxLines: 1,
                      backgroundColor: inCardColor,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      controller: _jobDescriptionController,
                      hintText: "Enter job description here",
                      overlineText: "Job description",
                      minLines: 12,
                      maxLines: null,
                      backgroundColor: inCardColor,
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            CustomButton(
              onTap: () {
                context.read<AppCubit>().createJob(
                  jobTitle: _jobTitleController.text,
                  jobDescription: _jobDescriptionController.text, 
                  interviewType: _interviewTypeController.text,
                );
                Navigator.of(context).pop(); // Close the bottom sheet after publishing
              },
              buttonText: "Publish",
              enabled: _jobTitleController.text.isNotEmpty && _jobDescriptionController.text.isNotEmpty,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  
}

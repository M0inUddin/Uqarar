// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeneratePlan extends StatefulWidget {
  final List<String> failedCourseCodes;

  GeneratePlan({Key? key, required this.failedCourseCodes}) : super(key: key);

  @override
  _GeneratePlanState createState() => _GeneratePlanState();
}

class _GeneratePlanState extends State<GeneratePlan> {
  final currentSemester = TextEditingController();
  final failedCourses = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the failedCourses controller with the provided course codes.
    failedCourses.text = widget.failedCourseCodes
        .join(', '); // Join the codes if they are in a list.
  }

  var apiResponse;

  Future generatePlan() async {
    var res = await http.post(
      Uri.parse("http://192.168.1.5:5000/courses"),
      body: jsonEncode(
        {
          "current_semester": currentSemester.text.toString(),
          "failed_courses": failedCourses.text.trim(),
        },
      ),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    );
    apiResponse = await jsonDecode(res.body);
  }

  Future showPopup(context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Generated Plan"),
          content: SizedBox(
            width: double.infinity,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  ...apiResponse['courses'].map(
                    (course) => SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Title: ${course['title']}"),
                              Text("Credit Hours: ${course['credit_hours']}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter Student Details",
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              const SizedBox(height: 27),
              TextField(
                controller: currentSemester,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Current Semester",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 17),
              TextField(
                controller: failedCourses,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Failed Courses",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 17),
              SizedBox(
                width: double.infinity,
                height: 51,
                child: ElevatedButton(
                  onPressed: () async {
                    await generatePlan();
                    print("==========\n$apiResponse");
                    showPopup(context);
                  },
                  child: const Text("Generate Plan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

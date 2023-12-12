import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/cameraImage.dart';
import 'package:fyp/screens/generate_plan.dart';

import '../widgets/transcript_widgets/custom_text.dart';
import '../widgets/transcript_widgets/section_heading.dart';
import '../widgets/transcript_widgets/semester_table.dart';

class Transcript extends StatefulWidget {
  final Map<String, dynamic> studentDetails;
  final String userRole, batch, department;
  Transcript({
    super.key,
    required this.batch,
    required this.department,
    required this.userRole,
    required this.studentDetails,
  });

  @override
  State<Transcript> createState() => _TranscriptState();
}

class _TranscriptState extends State<Transcript> {
  TextEditingController courseCode = TextEditingController();
  TextEditingController courseGrade = TextEditingController();
  String selectedSemester = "Select";

  Future updateResult(context) async {
    try {
      final List semesterCodes =
          widget.studentDetails["program_details"][selectedSemester]["codes"];
      for (var codeIndex = 0; codeIndex < semesterCodes.length; codeIndex++) {
        if (semesterCodes[codeIndex] == courseCode.text) {
          widget.studentDetails["program_details"][selectedSemester]["grades"]
              [codeIndex] = courseGrade.text;
        }
      }

      print(widget.studentDetails["program_details"][selectedSemester]);
      print(widget.batch);
      print(widget.department);
      print(widget.studentDetails["id"]);

      await FirebaseFirestore.instance
          .collection('batch')
          .doc(widget.batch)
          .collection('department')
          .doc(widget.department)
          .collection("students")
          .doc(widget.studentDetails["id"])
          .set(widget.studentDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Grade updated successfully!"),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid details"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userRole);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeading(
                          text: "Official SS-CASE-IT Transcript"),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                heading: "Full Name:",
                                text: widget.studentDetails["name"]),
                            CustomText(
                                heading: "Address:",
                                text: widget.studentDetails["address"]),
                            CustomText(
                                heading: "Phone Number:",
                                text: widget.studentDetails["phone"]),
                            CustomText(
                                heading: "Email:",
                                text: widget.studentDetails["email"]),
                            CustomText(
                                heading: "Date Of Birth:",
                                text: widget.studentDetails["dob"]),
                          ],
                        ),
                      ),
                      const SectionHeading(text: "Academic Record"),
                      (widget.userRole == "Admin")
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return AlertDialog(
                                                content: const Text(
                                                  "Please enter the Course Code and New Grade",
                                                ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      DropdownButton(
                                                        value: selectedSemester,
                                                        items: const [
                                                          DropdownMenuItem(
                                                            value: "Select",
                                                            child:
                                                                Text("Select"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_one",
                                                            child: Text(
                                                                "Semester 01"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_two",
                                                            child: Text(
                                                                "Semester 02"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_three",
                                                            child: Text(
                                                                "Semester 03"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_four",
                                                            child: Text(
                                                                "Semester 04"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_five",
                                                            child: Text(
                                                                "Semester 05"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_six",
                                                            child: Text(
                                                                "Semester 06"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_seven",
                                                            child: Text(
                                                                "Semester 07"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                "semester_eight",
                                                            child: Text(
                                                                "Semester 08"),
                                                          ),
                                                        ],
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            selectedSemester =
                                                                newValue
                                                                    .toString();
                                                            print(
                                                                selectedSemester);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              courseCode,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "Course Code",
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              courseGrade,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "New Grade",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await updateResult(
                                                          context);
                                                    },
                                                    child: const Text(
                                                      "Update Result",
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                          });
                                    },
                                    child: const Text("Update Result"),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 01",
                        semesterDetails: widget
                            .studentDetails["program_details"]["semester_one"],
                      ),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 02",
                        semesterDetails: widget
                            .studentDetails["program_details"]["semester_two"],
                      ),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 03",
                        semesterDetails:
                            widget.studentDetails["program_details"]
                                ["semester_three"],
                      ),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 04",
                        semesterDetails: widget
                            .studentDetails["program_details"]["semester_four"],
                      ),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 05",
                        semesterDetails: widget
                            .studentDetails["program_details"]["semester_five"],
                      ),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 06",
                        semesterDetails: widget
                            .studentDetails["program_details"]["semester_six"],
                      ),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 07",
                        semesterDetails:
                            widget.studentDetails["program_details"]
                                ["semester_seven"],
                      ),
                      SemesterTable(
                        userRole: widget.userRole,
                        title: "Semester 08",
                        semesterDetails:
                            widget.studentDetails["program_details"]
                                ["semester_eight"],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyCameraImage(),
                        ),
                      );
                    },
                    child: const Text("Open Camera"),
                  ),
                  const SizedBox(width: 17),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GeneratePlan(
                            failedCourseCodes: widget
                                .studentDetails["program_details"]
                                    [selectedSemester]["codes"]
                                .where((code) =>
                                    widget.studentDetails["program_details"]
                                        [selectedSemester]["grades"] ==
                                    "F")
                                .toList(),
                          ),
                        ),
                      );
                    },
                    child: const Text("Generate Plan"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

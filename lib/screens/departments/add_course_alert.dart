import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/add_course_service.dart';
import 'courses.dart';

class AddCourseAlert extends StatelessWidget {
  final className;
  AddCourseAlert({required this.className});

  final courseController = TextEditingController();

  get studentName => null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Text(
                    "Add New Department",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontSize: 17),
                      controller: courseController,
                      decoration: InputDecoration(
                        labelText: "Enter Department",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text(
                        "Add Department",
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        if (courseController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG,
                          );
                        } else {
                          AddCourseService()
                              .addMyCourse(
                                  className: "$className",
                                  courseName: courseController.text.trim())
                              .then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CoursesScreen(
                                          className: className,
                                        )),
                                (route) => false);
                          });
                        }
                      },
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/add_chapter_service.dart';
import 'chapters.dart';

class AddChapterAlert extends StatelessWidget {
  final className, courseName;
  AddChapterAlert({required this.className, required this.courseName});

  final chapterController = TextEditingController();

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
                    "Add New Chapter",
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
                      controller: chapterController,
                      decoration: InputDecoration(
                        labelText: "Enter chapter name",
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
                        "Add Chapter",
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        if (chapterController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG,
                          );
                        } else {
                          AddChapterService()
                              .addChapter(
                                  className: className,
                                  courseName: courseName,
                                  chapterName: chapterController.text.trim())
                              .then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChaptersScreen(
                                        className: className,
                                        courseName: courseName)),
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
*/
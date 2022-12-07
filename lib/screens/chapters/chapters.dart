import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uqarar_fyp/screens/students/student_list_screen.dart';

import '../departments/courses.dart';

import "./custom_card.dart";
import 'add_chapter_alert.dart';

class ChaptersScreen extends StatefulWidget {
  final className, courseName, studentName;
  ChaptersScreen(
      {required this.className, required this.courseName, this.studentName});

  @override
  State<ChaptersScreen> createState() => _ChaptersState();
}

class _ChaptersState extends State<ChaptersScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  List chapters = [];
  var _getChapters;

  Future getChapters(
      {required String className, required String courseName}) async {
    await firestore
        .collection('teachers')
        .doc(user!.uid)
        .collection('my_classes')
        .doc(className)
        .collection('courses')
        .doc(courseName)
        .collection('chapters')
        .get()
        .then((value) =>
            chapters += value.docs.map((doc) => doc.data()).toList());

    return "Request Successful";
  }

  @override
  void initState() {
    super.initState();
    _getChapters =
        getChapters(className: widget.className, courseName: widget.courseName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 36, 117),
        title: Text(widget.courseName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CoursesScreen(className: widget.className)),
                (route) => false);
          },
        ),
      ),
      body: Center(
        child: FutureBuilder(
            future: _getChapters,
            builder: (context, snapshot) {
              return StudentListScreen();
              // StudentScreen(studentName: '');

              /*GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                childAspectRatio: 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: chapters.map((chapter) {
                  return CustomCard(className: chapter['chapterName']);
                }).toList(),
              );*/
            }),
      ),
    );
  }
}

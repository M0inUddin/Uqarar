import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../all_screens.dart';
import "./custom_card.dart";

import 'add_course_alert.dart';

class CoursesScreen extends StatefulWidget {
  final className;

  CoursesScreen({required this.className});

  @override
  State<CoursesScreen> createState() => _CoursesState();
}

class _CoursesState extends State<CoursesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  List myCourses = [];
  var _getMyCourses;

  get students => null;

  Future getMyCourses({required String className}) async {
    await firestore
        .collection('teachers')
        .doc(user!.uid)
        .collection('my_classes')
        .doc(className)
        .collection('courses')
        .get()
        .then((value) =>
            myCourses += value.docs.map((doc) => doc.data()).toList());

    return "Request Successful";
  }

  @override
  void initState() {
    super.initState();
    _getMyCourses = getMyCourses(className: widget.className);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 36, 117),
        title: Text(widget.className),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AllScreens("Home")),
                (route) => false);
          },
        ),
      ),
      body: Center(
        child: FutureBuilder(
            future: _getMyCourses,
            builder: (context, snapshot) {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                childAspectRatio: 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: myCourses.map((course) {
                  return CustomCard(
                    className: widget.className,
                    courseName: course['courseName'],
                  );
                }).toList(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Department"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddCourseAlert(className: widget.className),
          );
        },
      ),
    );
  }
}

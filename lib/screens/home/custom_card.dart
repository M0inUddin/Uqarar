import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../all_screens.dart';
import '../departments/courses.dart';

class CustomCard extends StatelessWidget {
  final String className;

  CustomCard({required this.className});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoursesScreen(
                        className: className,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 6.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0xff7851a9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          className,
                          style: const TextStyle(fontSize: 21),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.warning,
                        text: "Are you sure you want to remove $className",
                        confirmBtnColor: Colors.redAccent,
                        confirmBtnText: "Confirm",
                        onConfirmBtnTap: () async {
                          await FirebaseFirestore.instance
                              .collection('teachers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('my_classes')
                              .doc(className)
                              .delete();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllScreens('Home')),
                              (route) => false);
                        });
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

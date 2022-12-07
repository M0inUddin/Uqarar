import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../navigation_drawer/navigation_drawer.dart';
import 'add_class_alert.dart';
import 'custom_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  List myClasses = [];
  var _getMyClasses;

  get studentName => null;

  Future getMyClasses() async {
    await firestore
        .collection('teachers')
        .doc(user!.uid)
        .collection('my_classes')
        .get()
        .then((value) =>
            myClasses += value.docs.map((doc) => doc.data()).toList());

    return "Request Successful";
  }

  @override
  void initState() {
    super.initState();
    _getMyClasses = getMyClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      body: Center(
        child: FutureBuilder(
            future: _getMyClasses,
            builder: (context, snapshot) {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                childAspectRatio: 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: myClasses.map((className) {
                  return CustomCard(
                    className: className['className'],
                  );
                }).toList(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Batch"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddClassAlert(),
          );
        },
      ),
    );
  }
}

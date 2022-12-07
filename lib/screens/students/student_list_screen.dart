import 'package:flutter/material.dart';
import 'package:uqarar_fyp/screens/students/student_detail_screen.dart';

import 'model/student.dart';

class StudentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              Student student = studentList[index];
              return Card(
                child: ListTile(
                  title: Text(student.title),
                  subtitle: Text(student.year.toString()),
                  leading: Image.network(student.imageUrl),
                  trailing: Icon(Icons.arrow_forward_rounded),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailsScreen(student)));
                  },
                ),
              );
            }));
  }
}

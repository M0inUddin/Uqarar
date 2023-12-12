import 'package:flutter/material.dart';

import 'package:fyp/firebaseService/firebase_database.dart';
import 'package:fyp/widgets/department_tile.dart';
import 'createdepartment.dart';
import 'department_process.dart';

class DepartmentDetail extends StatelessWidget {
  final String departmentName;
  final String batch;
  final String role;

  const DepartmentDetail(this.departmentName, this.batch, this.role,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            batch,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff1F6E8C),
        ),
        floatingActionButton: role == 'Admin'
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateDepartment("Department", batch),
                      ));
                })
            : const SizedBox(),
        body: role == 'Teacher'
            ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: showTeacherDepartment())
            : Padding(
                padding: const EdgeInsets.only(top: 20),
                child: StreamBuilder(
                  stream: FirebaseStoreDatabase().readDepartment(batch),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final departments = snapshot.data!;

                      return GridView.builder(
                        itemCount: departments.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 220, crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DepartmentProcess(
                                          departments[index].departmentName,
                                          batch,
                                          role),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: DepartmentTile(
                                    departments[index].departmentName,
                                    batch,
                                    index,
                                    role),
                              ));
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ));
  }

  Widget showTeacherDepartment() {
    return FutureBuilder(
      future: FirebaseStoreDatabase()
          .readDepartmentForTeacher(batch, departmentName),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final departments = snapshot.data!;

          return GridView.builder(
            itemCount: departments.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 220, crossAxisCount: 2),
            itemBuilder: (context, index) {
              return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepartmentProcess(
                              departments[index].departmentName, batch, role),
                        ));
                  },
                  child: DepartmentTile(
                      departments[index].departmentName, batch, index, role));
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

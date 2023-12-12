import 'package:flutter/material.dart';
import 'package:fyp/firebaseService/firebase_database.dart';
import 'package:fyp/screens/transcript.dart';

class ShowStudent extends StatelessWidget {
  const ShowStudent(this.role, this.batch, this.department, {super.key});
  final String batch;
  final String department;
  final String role;
  @override
  Widget build(BuildContext context) {
    print(batch);
    print(department);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Show Students"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: FutureBuilder(
            future:
                FirebaseStoreDatabase().readStudentsofBatch(batch, department),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data[0]["name"]);
                final data = snapshot.data!;

                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Transcript(
                              userRole: role,
                              batch: batch,
                              department: department,
                              studentDetails: data[index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                data[index]["name"],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$batch\t$department",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[index]["rollno"],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:fyp/utils/notification_util.dart';
import '../firebaseService/firebase_database.dart';
import '../model/accounts_model.dart';

List<Accounts> teachers = [];

class CreateDepartment extends StatefulWidget {
  const CreateDepartment(this.departmentHeading, this.batch, {super.key});
  final String departmentHeading;
  final String batch;

  @override
  State<CreateDepartment> createState() => _CreateDepartmentState();
}

class _CreateDepartmentState extends State<CreateDepartment> {
  final TextEditingController departmentname = TextEditingController();

  final TextEditingController batchYear = TextEditingController();

  final FirebaseStoreDatabase _firebasedb = FirebaseStoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create ${widget.departmentHeading}"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
                EdgeInsets.only(top: 60.0, bottom: 10, left: 30, right: 30),
            child: Text(
              "Department Name",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          widget.batch == 'Batch'
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 10, left: 30, right: 30),
                  child: TextField(
                    controller: departmentname,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Department Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
          const Padding(
            padding:
                EdgeInsets.only(top: 20.0, bottom: 10, left: 30, right: 30),
            child: Text(
              "Batch",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 30, left: 30, right: 30),
            child: TextFormField(
              initialValue: widget.batch,
              readOnly: true,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Batch",
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Ink(
                  height: 45,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff1F6E8C)),
                  child: const Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.departmentHeading == "Department" &&
                      departmentname.text.isNotEmpty) {
                    _firebasedb.addDepartment(
                        departmentname.text, widget.batch);
                    departmentname.clear();
                    NotificationUtils().successNotifier(
                        context, "Department created successfully!");
                  } else {
                    NotificationUtils().failedNotifier(
                        context, "Please write department name");
                  }
                },
                child: Ink(
                  height: 45,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff1F6E8C)),
                  child: const Center(
                    child: Text(
                      "Create",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

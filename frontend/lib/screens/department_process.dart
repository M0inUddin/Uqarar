// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fyp/screens/showStudents.dart';
import 'package:fyp/utils/notification_util.dart';
import '../firebaseService/firebase_auth.dart';
import '../firebaseService/firebase_database.dart';
import '../model/accounts_model.dart';
import '../model/meetings.dart';
import '../widgets/operationButton.dart';
import 'createmeeting.dart';

class DepartmentProcess extends StatefulWidget {
  const DepartmentProcess(this.departmentName, this.batch, this.role,
      {super.key});
  final String departmentName;
  final String batch;
  final String role;

  @override
  State<DepartmentProcess> createState() => _DepartmentProcessState();
}

class _DepartmentProcessState extends State<DepartmentProcess> {
  List<Accounts> teacherData = [];
  String teacherID = '';

  @override
  void initState() {
    getTeacherData();
    getTeacherID();
    setState(() {});
    super.initState();
  }

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
          widget.departmentName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff1F6E8C),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: 250,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('./assets/logo.png'))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        print("===================${widget.role}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => widget.role == 'Teacher'
                                    ? CreateMeeting(
                                        widget.batch, widget.departmentName)
                                    : AddStudent(
                                        widget.batch, widget.departmentName)));
                      },
                      child: widget.role == 'Teacher'
                          ? const OperationButton(
                              'student.png', "Create Meeting")
                          : const OperationButton(
                              'student.png', "Add Student")),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => widget.role == 'Teacher'
                                    ? checkMeetings(
                                        widget.batch,
                                        widget.departmentName,
                                        AuthService().getUserID())
                                    : AddTeacher(teacherData, widget.batch,
                                        widget.departmentName)));
                      },
                      child: widget.role == "Teacher"
                          ? const OperationButton("student.png", "My Meetings")
                          : const OperationButton(
                              "student.png", "Add Teacher")),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowStudent(widget.role,
                                  widget.batch, widget.departmentName),
                            ));
                      },
                      child: const OperationButton(
                          'students.png', 'Show Student')),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowStudent("", "", ""),
                            ));
                      },
                      child: const OperationButton(
                          'transcript.png', 'Transcript')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getTeacherData() async {
    teacherData = await FirebaseStoreDatabase().readTeachers();
    setState(() {});
  }

  Future getTeacherID() async {
    teacherID = await AuthService().getUserID();
  }

  Widget checkMeetings(String batch, String department, String teacherID) {
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
          title: const Text(
            "Meetings",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff1F6E8C),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: StreamBuilder<List<Meetings>>(
            stream: FirebaseStoreDatabase().readMeetingsForTeacher(teacherID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xffF6F6F6),
                      child: ListTile(
                        leading:
                            const ImageIcon(AssetImage("./assets/meeting.png")),
                        title: Text(data[index].meetingName),
                        subtitle: Text(
                            "${data[index].meetingDate} ${data[index].meetingTime}"),
                        trailing: IconButton(
                            padding: const EdgeInsets.all(0),
                            color: const Color(0xff1F6E8C),
                            onPressed: () {
                              FirebaseStoreDatabase().deleteMeeting(
                                  data[index].meetingID, teacherID);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete_rounded)),
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

class AddTeacher extends StatefulWidget {
  const AddTeacher(this.teacherData, this.batch, this.department, {super.key});
  final String department;
  final String batch;
  final List<Accounts> teacherData;

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  List<Accounts> selectedTeachers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  "Assign Teachers to department",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedTeachers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    title: Text(selectedTeachers[index].userName),
                    trailing: IconButton(
                        onPressed: () {
                          selectedTeachers.removeAt(index);
                          setState(() {});
                        },
                        icon: const Icon(Icons.close)),
                  ));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
                child: DropdownButtonFormField(
                    items: widget.teacherData
                        .map((data) => DropdownMenuItem(
                            value: data.userID, child: Text(data.userName)))
                        .toList(),
                    onChanged: (value) {
                      var selectedTeacher = widget.teacherData.singleWhere(
                          (element) => element.userID.toString() == value);
                      selectedTeachers.add(selectedTeacher);
                      setState(() {});
                    }),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                child: Row(
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
                        FirebaseStoreDatabase().addTeacherToDepartment(
                            selectedTeachers, widget.batch, widget.department);
                      },
                      child: Ink(
                        height: 45,
                        width: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff1F6E8C)),
                        child: const Center(
                          child: Text(
                            "Add",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class AddStudent extends StatelessWidget {
  AddStudent(this.batchYear, this.departmentName, {super.key});

  String batchYear;
  String departmentName;

  TextEditingController studentName = TextEditingController();
  TextEditingController studentRegistrationNo = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();

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
          title: const Text(
            "Add Student",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff1F6E8C),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Student Name"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                    controller: studentName,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffF9F5F6),
                        filled: true,
                        hintText: "Student Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid name";
                      }
                      return null;
                    }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Student RegistrationNo."),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                    controller: studentRegistrationNo,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffF9F5F6),
                        filled: true,
                        hintText: "Student RegistrationNo.",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid reg no.";
                      }
                      return null;
                    }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Student Address"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffF9F5F6),
                        filled: true,
                        hintText: "Student Address",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid address";
                      }
                      return null;
                    }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Student Phone"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffF9F5F6),
                        filled: true,
                        hintText: "Student Phone",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid phone";
                      }
                      return null;
                    }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Student Email"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffF9F5F6),
                        filled: true,
                        hintText: "Student Email",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid email";
                      }
                      return null;
                    }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Date of Birth"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                    controller: dob,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffF9F5F6),
                        filled: true,
                        hintText: "Date of Birth",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid date of birth";
                      }
                      return null;
                    }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Batch year"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  initialValue: batchYear,
                  readOnly: true,
                  decoration: InputDecoration(
                      fillColor: const Color(0xffF9F5F6),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: Text("Department"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  initialValue: departmentName,
                  readOnly: true,
                  decoration: InputDecoration(
                      fillColor: const Color(0xffF9F5F6),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
              child: SizedBox(
                child: Row(
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
                        if (studentName.text != "" &&
                            studentRegistrationNo.text != "") {
                          FirebaseStoreDatabase().addStudent(
                            batchYear,
                            departmentName,
                            studentName.text,
                            studentRegistrationNo.text,
                            address.text,
                            phone.text,
                            email.text,
                            dob.text,
                          );

                          NotificationUtils()
                              .successNotifier(context, "Student added");
                        } else {
                          NotificationUtils().failedNotifier(
                              context, "Fields must not be empty");
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
                            "Add",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}

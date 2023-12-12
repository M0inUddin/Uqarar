import 'package:flutter/material.dart';
import 'package:fyp/firebaseService/firebase_auth.dart';
import 'package:fyp/firebaseService/firebase_database.dart';
import 'package:fyp/model/meetings.dart';
import 'package:fyp/utils/notification_util.dart';

import '../model/accounts_model.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting(this.batch, this.department, {super.key});
  final String batch;
  final String department;

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  String confirmDate = '';
  String confirmTime = '';
  TextEditingController meetingName = TextEditingController();
  static var date = DateTime.now();
  var customeDate = "${date.day}-${date.month}-${date.year}";
  var customeTime = "${date.hour}-${date.minute}-${date.second}";
  List<Accounts> studentData = [];
  List<String> meetingDetail = [];
  List<Accounts> selectedStudentList = [];

  @override
  void initState() {
    getStudentData();
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
        title: const Text(
          "Create meeting",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff1F6E8C),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            headingsForTextbox("Meeting name"),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                    controller: meetingName,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffF9F5F6),
                        filled: true,
                        hintText: "Meeting name",
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
            headingsForTextbox("Meeting Date"),
            datePickerWidget("Select Date for meeting"),
            headingsForTextbox("Meeting Time"),
            timePickerWidget("Select Time for meeting"),
            addStudentToMeeting(),
          ],
        ),
      ),
    );
  }

  Widget headingsForTextbox(String heading) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 8, top: 30),
      child: Text(
        heading,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget datePickerWidget(String date) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        dateTimeCard(context, date, confirmDate),
        Material(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
              ).then((pickedDate) {
                setState(() {
                  customeDate =
                      "${pickedDate?.day.toString().padLeft(2, '0')}-${pickedDate?.month.toString().padLeft(2, '0')}-${pickedDate?.year.toString()}";
                  confirmDate = customeDate;
                });
              });
            },
            child: const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xff1F6E8C),
                child: ImageIcon(
                  AssetImage('./assets/calendar.png'),
                  color: Colors.white,
                )),
          ),
        )
      ]),
    );
  }

  Widget timePickerWidget(String time) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        dateTimeCard(context, time, confirmTime),
        Material(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            onTap: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((pickedDate) {
                setState(() {
                  customeTime =
                      "${pickedDate!.hour.toInt() > 12 ? pickedDate.hour.toInt() - 12 : pickedDate.hour}:${pickedDate.minute.toString().padLeft(2, '0')}:00 ${pickedDate.hour.toInt() > 12 ? 'PM' : 'AM'}";
                  confirmTime = customeTime;
                });
              });
            },
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xff1F6E8C),
              child: ImageIcon(
                AssetImage('./assets/clock.png'),
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget dateTimeCard(
      BuildContext context, String date, String confirmSelectedDate) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 100,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xffF9F5F6),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 12),
        child: Text(
          confirmSelectedDate.isEmpty ? date : confirmSelectedDate,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  getStudentData() async {
    studentData = await FirebaseStoreDatabase().readStudent();
    setState(() {});
  }

  Widget addStudentToMeeting() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18.0, top: 30),
            child: Text("Select student",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedStudentList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                title: Text(selectedStudentList[index].userName),
                trailing: IconButton(
                    onPressed: () {
                      selectedStudentList.removeAt(index);
                      setState(() {});
                    },
                    icon: const Icon(Icons.close)),
              ));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: DropdownButtonFormField(
                items: studentData
                    .map((data) => DropdownMenuItem(
                        value: data.userID, child: Text(data.userName)))
                    .toList(),
                onChanged: (value) {
                  var selectedStudent = studentData.singleWhere(
                      (element) => element.userID.toString() == value);

                  setState(() {
                    selectedStudentList.add(selectedStudent);
                  });
                }),
          ),
          const SizedBox(
            height: 50,
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
                  String teacherID = AuthService().getUserID();
                  FirebaseStoreDatabase().addTeacherMeeting(
                    Meetings(
                        meetingID: meetingName.text,
                        meetingName: meetingName.text,
                        meetingDate: confirmDate,
                        meetingTime: confirmTime,
                        batchID: widget.batch,
                        departmentID: widget.department,
                        participent:
                            selectedStudentList.map((e) => e.userID).toList()),
                    teacherID,
                  );

                  NotificationUtils()
                      .successNotifier(context, "Meeting created successfully");
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
        ],
      ),
    );
  }
}

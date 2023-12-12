import 'package:flutter/material.dart';
import 'package:fyp/firebaseService/firebase_database.dart';
import 'package:fyp/screens/cameraImage.dart';
import 'package:fyp/shared/drawer.dart';
import 'package:fyp/utils/notification_util.dart';
import '../model/accounts_model.dart';
import '../model/batch.dart';
import '../model/meetings.dart';
import '../widgets/department_tile.dart';

import 'departmentdetail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.roleValue, this.userDetail, {super.key});
  final String roleValue;
  final Accounts userDetail;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController departmentName = TextEditingController();
  TextEditingController batchYear = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff1F6E8C),
        ),
        floatingActionButton: widget.roleValue == "Admin"
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return addBatch("Create Batch");
                    },
                  ));
                })
            : const SizedBox(),
        drawer: MyDrawer(context, widget.userDetail),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.roleValue == 'Student' || widget.roleValue == "Admin"
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 25, left: 20, right: 20, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyCameraImage(),
                            ));
                      },
                      child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width - 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 151, 208, 255)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('./assets/camera.png'),
                              color: Color.fromARGB(255, 0, 0, 0),
                              size: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Open Camera",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            widget.roleValue == 'Student' || widget.roleValue == "Admin"
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.only(
                      left: 25.0,
                      bottom: 20,
                    ),
                    child: Text(
                      "Batch",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
            Expanded(
              child: SizedBox(
                child: widget.roleValue == 'Student'
                    ? studentMeetings()
                    : Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: StreamBuilder<List<Batchs>>(
                          stream: FirebaseStoreDatabase().readBatch(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final batches = snapshot.data!;

                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 230, crossAxisCount: 2),
                                itemCount: batches.length,
                                itemBuilder: (context, index) {
                                  return Material(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DepartmentDetail(
                                                        batches[index]
                                                            .batchYear,
                                                        batches[index]
                                                            .batchYear,
                                                        widget.roleValue),
                                              ));
                                        },
                                        child: DepartmentTile(
                                            "",
                                            batches[index].batchYear,
                                            index,
                                            widget.roleValue)),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
              ),
            )
          ],
        ));
  }

  Widget studentMeetings() {
    return StreamBuilder<List<Meetings>>(
      stream: FirebaseStoreDatabase().readMeetings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xffF6F6F6),
                child: ListTile(
                  leading: const ImageIcon(AssetImage("./assets/meeting.png")),
                  title: Text(data[index].meetingName),
                  subtitle: Text(
                      "${data[index].meetingDate} ${data[index].meetingTime}"),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 130, bottom: 80),
                  height: 350,
                  width: 355,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("./assets/meetinglogo.png"),
                          fit: BoxFit.cover)),
                ),
                const Text(
                  "No Meetings created for you yet.",
                  style: TextStyle(
                    color: Color.fromARGB(244, 73, 73, 73),
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 50),
                  child: Text(
                    "You don't have any meeting yet. when the teacher will create any meeting we will let you know. Be ready for updates",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color.fromARGB(244, 73, 73, 73),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget addBatch(String label) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          //mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 12.0,
                bottom: 10,
              ),
              child: Text(
                "Department Name",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 10,
              ),
              child: TextFormField(
                readOnly: true,
                initialValue: "Department name doesn't required!",
                //controller: departmentName,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Department Name doesn't required",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 10),
              child: Text(
                "Batch",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 30),
              child: TextFormField(
                controller: batchYear,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Batch",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
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
                    onTap: () async {
                      if (batchYear.text.isNotEmpty) {
                        FirebaseStoreDatabase().addBatch(batchYear.text);
                        batchYear.clear();
                        NotificationUtils().successNotifier(
                            context, "Batch added successfully");
                      } else {
                        NotificationUtils()
                            .failedNotifier(context, "Please write batch year");
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

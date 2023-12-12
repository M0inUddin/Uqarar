// import 'package:flutter/material.dart';
// import 'package:fyp/firebaseService/firebase_database.dart';

// class AddMember extends StatelessWidget {
//   AddMember(this.batch, this.department, {super.key});

//   final String batch;
//   final String department;
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController rollNoController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Add"),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding:
//                   EdgeInsets.only(top: 12.0, bottom: 10, left: 30, right: 30),
//               child: Text(
//                 "Student Name",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 12.0, bottom: 10, left: 30, right: 30),
//               child: TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                     filled: true,
//                     hintText: "Name",
//                     border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                         borderRadius: BorderRadius.circular(5))),
//               ),
//             ),
//             const Padding(
//               padding:
//                   EdgeInsets.only(top: 12.0, bottom: 10, left: 30, right: 30),
//               child: Text(
//                 "Student Registration No.",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 12.0, bottom: 60, left: 30, right: 30),
//               child: TextField(
//                 controller: rollNoController,
//                 decoration: InputDecoration(
//                     filled: true,
//                     hintText: "Registration no.",
//                     border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                         borderRadius: BorderRadius.circular(5))),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   borderRadius: BorderRadius.circular(10),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Ink(
//                     height: 45,
//                     width: 130,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: const Color(0xff1F6E8C)),
//                     child: const Center(
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Color.fromARGB(255, 255, 255, 255),
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     FirebaseStoreDatabase().addStudent(batch, department,
//                         nameController.text, rollNoController.text);
//                   },
//                   child: Ink(
//                     height: 45,
//                     width: 130,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: const Color(0xff1F6E8C)),
//                     child: const Center(
//                       child: Text(
//                         "Add",
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Color.fromARGB(255, 255, 255, 255),
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ));
//   }
// }
